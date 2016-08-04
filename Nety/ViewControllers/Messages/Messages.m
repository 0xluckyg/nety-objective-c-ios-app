//
//  Messages.m
//  Nety
//
//  Created by Scott Cho on 7/7/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Messages.h"

@interface Messages ()

@end

@implementation Messages


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeSettings];
    [self initializeDesign];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(bool)hidesBottomBarWhenPushed {
    return YES;
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    self.senderId = [UserInformation getUserID];
    self.senderDisplayName = [UserInformation getName];
    
    [self createRoomAndObserveMessages];
    
    self.messages = [[NSMutableArray alloc] init];
    
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = self.selectedUserName;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    //Set up message style
    JSQMessagesBubbleImageFactory *incomingImage = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleCompactTaillessImage] capInsets:UIEdgeInsetsZero];
    JSQMessagesBubbleImageFactory *outgoingImage = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleCompactTaillessImage] capInsets:UIEdgeInsetsZero];
    
    
    self.outgoingBubbleImageView = [outgoingImage outgoingMessagesBubbleImageWithColor:self.UIPrinciple.netyBlue];
    self.incomingBubbleImageView = [incomingImage incomingMessagesBubbleImageWithColor:self.UIPrinciple.netyGray];
    
    //Set up avatar image
    if ([self.selectedUserProfileImageString isEqualToString:kDefaultUserLogoName]) {
        self.incomingBubbleAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:kDefaultUserLogoName] diameter:35.0f];
    } else {
        [self downloadSelectedUserImage];
    }
    
    //Set user avatar size to zero
    [[self.collectionView collectionViewLayout] setOutgoingAvatarViewSize:CGSizeZero];
    [[self.collectionView collectionViewLayout] setIncomingAvatarViewSize:CGSizeMake(35.0f, 35.0f)];
    [[self.collectionView collectionViewLayout] setMessageBubbleLeftRightMargin:150.0f];
    
    //Set font
    [[self.collectionView collectionViewLayout] setMessageBubbleFont:[self.UIPrinciple netyFontWithSize:15]];
    
    //Change buttons
    
    [self.inputToolbar.contentView.leftBarButtonItem setImage:[[UIImage imageNamed:@"Camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:normal];
    [self.inputToolbar.contentView.leftBarButtonItem setImage:[[UIImage imageNamed:@"Camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    self.inputToolbar.contentView.leftBarButtonItem.tintColor = self.UIPrinciple.netyGray;
    self.inputToolbar.contentView.textView.font = [self.UIPrinciple netyFontWithSize:15];
    [self.inputToolbar.contentView.rightBarButtonItem setTitle:@"Send" forState:normal];
    
    
    
    //Style the navigation bar    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.messages.count;
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *data = self.messages[indexPath.row];
    return data;
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messages removeObjectAtIndex:indexPath.row];
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *data = self.messages[indexPath.row];
    
    if ([data.senderId isEqualToString: self.senderId]) {
        return self.outgoingBubbleImageView;
    } else {
        return self.incomingBubbleImageView;
    }
    
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *data = self.messages[indexPath.row];
    
    if ([data.senderId isEqualToString: self.senderId]) {
        return nil;
    } else {
        return self.incomingBubbleAvatarImage;
    }
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

//Date for top labels
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Height for top labels has to match date for top labels
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if (indexPath.item == 0) {
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        
        if ([message.date timeIntervalSinceDate:previousMessage.date] / 60 > 1) {
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
        }
    }
    
    return nil;
}

//Height for top labels
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Height for top labels has to match date for top labels
    if (indexPath.item == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        
        if ([message.date timeIntervalSinceDate:previousMessage.date] / 60 > 1) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
    }
    
    return 0.0f;
}


#pragma mark - Buttons
//---------------------------------------------------------


- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Source"
                                                                   message:@"How would you like to send file?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        
                                                    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    
    NSNumber *secondsSince1970 = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    
    NSDictionary *messageData = @{ kSenderId: senderId,
                                   kSenderDisplayName: senderDisplayName,
                                   kDate: secondsSince1970,
                                   kText: text};
    
    [[[[[self.firdatabase child:kChatRooms] child:self.chatroomID] child:kMessages ] childByAutoId] setValue:messageData];
    
    if (otherUserStatus == 0) {
        
        readcount += 1;
        NSNumber *readcountToDatabase = @(readcount);
        
        [[[[[self.firdatabase child:kUserDetails] child:self.selectedUserID] child:kChats] child:self.chatroomID] updateChildValues:@{kUnread:readcountToDatabase}];
        
    }
    
    [self finishSendingMessage];
}


#pragma mark - View Disappear
//---------------------------------------------------------


-(void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [[[[[self.firdatabase child:kUserDetails] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kOnline: @0}];
    
    //If no messages, delete chat rooms
    if ([self.messages count] == 0) {
        
        //Remove room
        [[[self.firdatabase child:kChatRooms] child:self.chatroomID] removeValue];
        //Remove value
        [[[[[self.firdatabase child:kUserDetails]
                child:self.senderId]
                child:kChats]
                child:self.chatroomID]
                removeValue];
        
        [[[[[self.firdatabase child:kUserDetails]
                child:self.selectedUserID]
                child:kChats]
                child:self.chatroomID]
                removeValue];
        
    }
    
}


#pragma mark - Custom methods
//---------------------------------------------------------

- (void)createRoomAndObserveMessages {
    
    NSMutableDictionary *chatRoomInformation = [self makeChatRoomID];
    
    //Check if the same room exists first
    [[[[self.firdatabase child:kUserDetails] child:self.senderId] child:kChats] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"this is snapshot value %@", snapshot.value);
        
        if (![snapshot hasChild:self.chatroomID] || snapshot.value == NULL) {
            
            NSLog(@"created room");
            
            //Room
            [[[self.firdatabase child:kChatRooms] child:self.chatroomID] setValue:chatRoomInformation];
            //Add to both the user and selected user
            [[[[[[self.firdatabase child:kUserDetails]
                                    child:self.senderId]
                                    child:kChats]
                                    child:self.chatroomID]
                                    child:kUnread]
                                    setValue:@0];
            
            [[[[[[self.firdatabase child:kUserDetails]
                                    child:self.selectedUserID]
                                    child:kChats]
                                    child:self.chatroomID]
                                    child:kUnread]
                                    setValue:@0];
            
            //Set user's online status to 0 when entering chat room
            [[[[[self.firdatabase child:kUserDetails] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kOnline: @1}];
            
            [self observeMessagesFromDatabase];
            [self listenForReadCountAndOnlineStatus];
            
        } else {
            
            [self observeMessagesFromDatabase];
            
            NSLog(@"%li", (long)readcount);
            
            //Set user's own readcount to 0 when entering chat room
            [[[[[self.firdatabase child:kUserDetails] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kUnread: @0}];
            //Set user's online status to 0 when entering chat room
            [[[[[self.firdatabase child:kUserDetails] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kOnline: @1}];
            
            [self listenForReadCountAndOnlineStatus];
            
        }
        
    } withCancelBlock:nil];

}

- (void)listenForReadCountAndOnlineStatus {
    
    //Listen for other person's read count
    [[[[[self.firdatabase child:kUserDetails] child:self.selectedUserID] child:kChats] child:self.chatroomID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if ([snapshot hasChild:kUnread]) {
            NSDictionary *readCountDictionary = snapshot.value;
            readcount = [[readCountDictionary objectForKey:kUnread] integerValue];
        } else {
            readcount = 0;
        }
        
        if ([snapshot hasChild:kOnline]) {
            NSDictionary *onlineUserStatusDictionary = snapshot.value;
            otherUserStatus = [[onlineUserStatusDictionary objectForKey:kOnline] integerValue];
            
        }
        
    } withCancelBlock:nil];

}

- (void)observeMessagesFromDatabase {
    
    [[[[self.firdatabase child:kChatRooms] child:self.chatroomID] child:kMessages] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *messagesDictionary = snapshot.value;
        NSString *senderIdFromDatabase = [messagesDictionary objectForKey:kSenderId];
        NSString *senderDisplaynameFromDatabase = [messagesDictionary objectForKey:kSenderDisplayName];
        double timeSince1970Double = [[messagesDictionary objectForKey:kDate] doubleValue];
        NSDate * messageDate = [self convertDoubleToDate:timeSince1970Double];
        NSString *textFromDatabase = [messagesDictionary objectForKey:kText];
        JSQMessage *jsqMessage = [[JSQMessage alloc] initWithSenderId:senderIdFromDatabase senderDisplayName:senderDisplaynameFromDatabase date:messageDate text:textFromDatabase];
        
        [self.messages addObject:jsqMessage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } withCancelBlock:nil];

}

- (NSDate *)convertDoubleToDate: (double)timeIntervalDouble {
    NSNumber *timeIntervalInNumber = [NSNumber numberWithInt:timeIntervalDouble];
    NSTimeInterval timeInterval = [timeIntervalInNumber doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return date;
}

- (NSMutableDictionary *)makeChatRoomID {
    
    //Making a room
    NSComparisonResult result = [self.senderId compare:self.selectedUserID];
    NSMutableDictionary *chatRoomInformation;
    NSNumber *secondsSince1970 = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    
    if (result == NSOrderedAscending) {
        
        self.chatroomID = [NSString stringWithFormat:@"%@%@", self.senderId, self.selectedUserID];
        
        chatRoomInformation = [[NSMutableDictionary alloc] initWithDictionary: @{kCreated: secondsSince1970,
                                                                                 kMembers: @{
                                                                                         @"member1": self.senderId,
                                                                                         @"member2": self.selectedUserID}}];
        
        
    } else {
        
        self.chatroomID = [NSString stringWithFormat:@"%@%@", self.selectedUserID, self.senderId];
        chatRoomInformation = [[NSMutableDictionary alloc] initWithDictionary: @{kCreated: secondsSince1970,
                                                                                 kMembers: @{
                                                                                         @"member1": self.selectedUserID,
                                                                                         @"member2": self.senderId}}];
        
    }
    
    return chatRoomInformation;
}

- (void)downloadSelectedUserImage {
    
    NSURL *profileImageUrl = [NSURL URLWithString: self.selectedUserProfileImageString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:profileImageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *downloadedImage = [UIImage imageWithData:data];
            
            NSLog(@"%@", downloadedImage);
            
            self.incomingBubbleAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:downloadedImage diameter:35.0f];
            
            [self.collectionView reloadData];
            
        });
        
    }] resume];
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
