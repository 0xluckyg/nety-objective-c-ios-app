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
//    [self addDemoMessages];
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
    self.senderDisplayName = [UserInformation getUserID];
    
    
    //Check if the same room exists first
    [[[self.firdatabase child:@"userDetails"] child:self.senderId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInformation = [self makeChatRoom];
        
        NSLog(@"%@", self.chatroomID);
        
        if (![snapshot hasChild:self.chatroomID]) {
            //Room
            [[[self.firdatabase child:@"chats"] child:self.chatroomID] setValue:chatRoomInformation];
            //Add
            [[[[self.firdatabase child:@"usersDetails"] child:self.senderId] child:@"chats"] setValue:self.chatroomID];
        } else {
            [self observeMessagesFromDatabase];
        }
        
    } withCancelBlock:nil];
    
    self.messages = [[NSMutableArray alloc] init];
    
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
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
        NSLog(@"download called");
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
    self.navigationItem.title = @"Name";
    
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
    
    if (data.senderId == self.senderId) {
        return self.outgoingBubbleImageView;
    } else {
        return self.incomingBubbleImageView;
    }
    
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *data = self.messages[indexPath.row];
    
    if (data.senderId == self.senderId) {
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
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 15 == 0) {
        //        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[NSDate date]];
    }
    
    return nil;
}

//Height for top labels
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 15 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
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
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
        
    NSNumber *secondsSince1970 = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    
    NSDictionary *messageData = @{ @"senderId": senderId,
                                   @"senderDisplayName": senderDisplayName,
                                   @"date": secondsSince1970,
                                   @"text": text};
    
    [[[[self.firdatabase child:@"chats"] child:self.chatroomID] childByAutoId] setValue:messageData];
    
    [self.messages addObject:message];
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
}


#pragma mark - Custom methods
//---------------------------------------------------------


- (void)observeMessagesFromDatabase {
    
    [[[self.firdatabase child:@"chats"] child:self.chatroomID] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *messagesDictionary = snapshot.value;
        NSString *senderIdFromDatabase = [messagesDictionary objectForKey:@"senderId"];
        NSString *senderDisplaynameFromDatabase = [messagesDictionary objectForKey:@"senderDisplayName"];
        double timeSince1970Double = [[messagesDictionary objectForKey:@"date"] doubleValue];
        NSDate * messageDate = [self convertDoubleToDate:timeSince1970Double];
        NSString *textFromDatabase = [messagesDictionary objectForKey:@"text"];
        JSQMessage *jsqMessage = [[JSQMessage alloc] initWithSenderId:senderIdFromDatabase senderDisplayName:senderDisplaynameFromDatabase date:messageDate text:textFromDatabase];

        [self.messages addObject:jsqMessage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } withCancelBlock:nil];

}

- (NSDate *)convertDoubleToDate: (double)timeIntervalDouble {
    NSNumber *timeIntervalInNumber = [NSNumber numberWithDouble:timeIntervalDouble];
    NSTimeInterval timeInterval = [timeIntervalInNumber doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return date;
}

- (NSMutableDictionary *)makeChatRoom {
    
    //Making a room
    NSComparisonResult result = [self.senderId compare:self.selectedUserID];
    NSMutableDictionary *chatRoomInformation;
    NSNumber *secondsSince1970 = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    
    if (result == NSOrderedAscending) {
        
        self.chatroomID = [NSString stringWithFormat:@"%@%@", self.senderId, self.selectedUserID];
        
        chatRoomInformation = [[NSMutableDictionary alloc] initWithDictionary: @{@"created": secondsSince1970,
                                                                                 @"members": @{
                                                                                         @"member1": self.senderId,
                                                                                         @"member2": self.selectedUserID}}];
        
        
    } else {
        
        self.chatroomID = [NSString stringWithFormat:@"%@%@", self.selectedUserID, self.senderId];
        chatRoomInformation = [[NSMutableDictionary alloc] initWithDictionary: @{@"created": secondsSince1970,
                                                                                 @"members": @{
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
            
        });
        
        [self.collectionView reloadData];
        
    }] resume];
}

//- (void)addDemoMessages {
//    NSString *sender;
//    
//    for (int i = 1; i <= 10; i ++) {
//        if (i % 2 == 0) {
//            sender = @"server";
//        } else {
//            sender = self.senderId;
//        }
//        
//        NSString *messageContent = [NSString stringWithFormat:@"Messages rn. %i", i];
//        NSDate *todaysDate = [NSDate date];
//        
//        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:sender senderDisplayName:sender date:todaysDate text:messageContent];
//        
//        [self.messages addObject:message];
//        
//    }
//    
//    //Reload messages
//    [self.collectionView reloadData];
//}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
