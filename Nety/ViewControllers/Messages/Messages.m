//
//  Messages.m
//  Nety
//
//  Created by Scott Cho on 7/7/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Messages.h"
#import "Msg.h"
#import "ChatRooms.h"

@interface Messages ()

@end

@implementation Messages {
    NSInteger numberOfMessages;
}


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


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    
    self.tabBarController.tabBar.hidden = YES;
    self.firdatabase = [[FIRDatabase database] reference];
    
    self.senderId = MY_USER.userID;
    NSLog(@"senderId %@", self.senderId);
    self.senderDisplayName = [NSString stringWithFormat:@"%@ %@",MY_USER.firstName, MY_USER.lastName];
    
    [self createRoomAndObserveMessages];
    
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
    JSQMessagesBubbleImageFactory *incomingImage = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleRegularImage] capInsets:UIEdgeInsetsZero];
    JSQMessagesBubbleImageFactory *outgoingImage = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleRegularImage] capInsets:UIEdgeInsetsZero];
    
    
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
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    numberOfMessages = [sectionInfo numberOfObjects];
    return numberOfMessages;
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    //JSQMessage *data = self.messages[indexPath.row];
    NSLog(@"%@ mData", [self getMessageObject:indexPath]);
    NSLog(@"%lu indexPath", (long)indexPath.row);
    return [self getMessageObject:indexPath];
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *data = [self getMessageObject:indexPath];
    
    if ([data.senderId isEqualToString: self.senderId]) {
        return self.outgoingBubbleImageView;
    } else {
        return self.incomingBubbleImageView;
    }
    
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *data = [self getMessageObject:indexPath];
    
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
    
    JSQMessage *msg = [self getMessageObject:indexPath];
    
    [self configureCell:cell withObject:msg];
    return cell;
}

//Date for top labels
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Height for top labels has to match date for top labels
    JSQMessage *message = [self getMessageObject:indexPath];
    
    if (indexPath.item == 0) {
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self getMessageObject:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section]];
        
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
        JSQMessage *previousMessage = [self getMessageObject:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section]];
        JSQMessage *message = [self getMessageObject:indexPath];
        
        if ([message.date timeIntervalSinceDate:previousMessage.date] / 60 > 1) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
    }
    
    return 0.0f;
}


//When photo choosing screen shows, customize nav controller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //Customizing view controller here
    [viewController.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [viewController.navigationController.navigationBar setTranslucent:NO];
    [self.UIPrinciple addTopbarColor:viewController];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [viewController.navigationController.navigationBar setTitleTextAttributes:attributes];
    
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //You can retrieve the actual UIImage
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *editedimage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (![UIImagePNGRepresentation(image) isEqualToData:UIImagePNGRepresentation(editedimage)]) {
        image = editedimage;
    }
    
    self.chatImage = [[UIImage alloc] init];
    self.chatImage = image;
    
    NSString *senderName = [NSString stringWithFormat:@"%@ %@",MY_USER.firstName, MY_USER.lastName];
    
    [self uploadImage:self.senderId senderDisplayName:senderName pickedImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Buttons
//---------------------------------------------------------


- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Source"
                                                                   message:@"How would you like to send photo?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
                                                       pickerLibrary.delegate = (id)self;
                                                       pickerLibrary.allowsEditing = YES;
                                                       pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                       [self presentViewController:pickerLibrary animated:YES completion:nil];
                                                   }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
                                                        pickerLibrary.delegate = (id)self;
                                                        pickerLibrary.allowsEditing = YES;
                                                        pickerLibrary.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                        [self presentViewController:pickerLibrary animated:YES completion:nil];
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
    
    NSString *firstMessageSender = [[NSString alloc] init];
    
    if (numberOfMessages >= 1) {
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        
        firstMessageSender = [self getMessageObject:index].senderId;
    }
    
    //User can only send up to 1 message to a person
    if (numberOfMessages == 1 && [senderId isEqualToString:firstMessageSender]) {
        
        [self.UIPrinciple oneButtonAlert:@"OKAY" controllerTitle:@"You can only send up to 1 message" message:@"Creeper free :)" viewController:self];
        
    } else {
        
        NSNumber *secondsSince1970 = [NSNumber numberWithInt: -1 * [[NSDate date] timeIntervalSince1970]];
        
        NSDictionary *messageData = @{ kSenderId: senderId,
                                       kSenderDisplayName: senderDisplayName,
                                       kDate: secondsSince1970,
                                       kText: text};
        
        FIRDatabaseReference *messageRef = [[[self.firdatabase child:kChatRooms] child:self.chatroomID] child:kMessages ];
        [[messageRef childByAutoId] setValue:messageData];
        
        [self editChatRoomInfo:text date:secondsSince1970];
        
        [self finishSendingMessageAnimated:YES];
        
    }

}


#pragma mark - View Disappear
//---------------------------------------------------------

-(void)backButtonPressed {
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    
    if ([navigationArray count] > 2) {
        [navigationArray removeObjectAtIndex: 1];
        self.navigationController.viewControllers = navigationArray;
    }
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    FIRDatabaseReference *onlineRef = [[[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID];
    [onlineRef updateChildValues:@{kOnline: @0}];
    
    //If no messages, delete chat rooms
    NSLog(@"%lu message count", numberOfMessages);
    
    if (numberOfMessages == 0) {
        
        //Remove room
        [[[self.firdatabase child:kChatRooms] child:self.chatroomID] removeValue];
        //Remove value
        [[[[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID] removeValue];
        
        [[[[[self.firdatabase child:kUserChats] child:self.selectedUserID] child:kChats] child:self.chatroomID] removeValue];
        
    }
    
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void)editChatRoomInfo: (NSString *)text date:(NSNumber *)secondsSince1970{
    
    //Editing each user's chat room data
    FIRDatabaseReference *selectedUserChatRoomRef = [[[[self.firdatabase child:kUserChats] child:self.selectedUserID] child:kChats] child:self.chatroomID];
    FIRDatabaseReference *userChatRoomRef = [[[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID];
    
    if (otherUserStatus == 0) {
        readcount += 1;
        NSNumber *readcountToDatabase = @(readcount);
        
        [selectedUserChatRoomRef updateChildValues:@{kUnread:readcountToDatabase}];
    }
    
    [selectedUserChatRoomRef updateChildValues:@{kRecentMessage:text}];
    [selectedUserChatRoomRef updateChildValues:@{kUpdateTime:secondsSince1970}];
    
    [userChatRoomRef updateChildValues:@{kRecentMessage:text}];
    [userChatRoomRef updateChildValues:@{kUpdateTime:secondsSince1970}];
    
}

- (void)createRoomAndObserveMessages {
    
    NSMutableDictionary *chatRoomInformation = [self makeChatRoomID];
    
    FIRDatabaseReference *chatRoomRef = [[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats];
    //Check if the same room exists first
    [chatRoomRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        //If room exists
        if ([snapshot hasChild:self.chatroomID] && snapshot.value != NULL) {
            
            [self observeMessagesFromDatabase];
            
            //Set user's own readcount to 0 when entering chat room
            [[[[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kUnread: @0}];
            //Set user's online status to 0 when entering chat room
            [[[[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kOnline: @1}];
            
            [self listenForReadCountAndOnlineStatus];
        
        //If room doesn't exist
        } else {
            
            NSNumber *secondsSince1970 = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970] * -1];
            
            //Room setup
            [[[self.firdatabase child:kChatRooms] child:self.chatroomID] setValue:chatRoomInformation];
            
            //Add information to both the user and selected user
            FIRDatabaseReference *userChatRoomRef = [[[[[self firdatabase] child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID];
            [[[userChatRoomRef child:kMembers] child:@"member1"] setValue:self.selectedUserID];
            [[userChatRoomRef child:kRecentMessage] setValue:@"Typing..."];
            [[userChatRoomRef child:kType] setValue:@0];
            [[userChatRoomRef child:kUnread] setValue:@0];
            [userChatRoomRef updateChildValues:@{kUpdateTime:secondsSince1970}];
            
            FIRDatabaseReference *selectedUserChatRoomRef = [[[[[self firdatabase] child:kUserChats] child:self.selectedUserID] child:kChats] child:self.chatroomID];
            [[[selectedUserChatRoomRef child:kMembers] child:@"member1"] setValue:self.senderId];
            [[selectedUserChatRoomRef child:kRecentMessage] setValue:@"Typing..."];
            [[selectedUserChatRoomRef child:kType] setValue:@0];
            [[selectedUserChatRoomRef child:kUnread] setValue:@0];
            [selectedUserChatRoomRef updateChildValues:@{kUpdateTime:secondsSince1970}];
            
            //Set user's online status to 0 when entering chat room
            [[[[[self.firdatabase child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID] updateChildValues:@{kOnline: @1}];
            
            [self observeMessagesFromDatabase];
            [self listenForReadCountAndOnlineStatus];
            
        }
        
    } withCancelBlock:nil];
    
}

- (void)listenForReadCountAndOnlineStatus {
    
    //Listen for other person's read count
    [[[[[self.firdatabase child:kUserChats] child:self.selectedUserID] child:kChats] child:self.chatroomID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
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

        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatRooms" inManagedObjectContext:MY_API.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"chatRoomID == %@",self.chatroomID]];
        NSError *error = nil;

        NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[MY_API.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        ChatRooms* chatRoom;
        if (findUserArray.count>0) {
            chatRoom = [findUserArray lastObject];
        }
//        else
//        {
//            user = [NSEntityDescription insertNewObjectForEntityForName:@"Msg" inManagedObjectContext:MY_API.managedObjectContext];
//            [user setValue:self.chatroomID forKey:@"chatroomID"];
//            
//        }
        NSDate* msgDate = [NSDate dateWithTimeIntervalSince1970:([[messagesDictionary objectForKey:@"date"] doubleValue]*-1)];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Msg" inManagedObjectContext:MY_API.managedObjectContext]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"chatroomID == %@ AND date == %@",self.chatroomID,msgDate]];
        error = nil;
        NSMutableArray* findMsgArray = [NSMutableArray arrayWithArray:[MY_API.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        if (findMsgArray.count == 0) {
            Msg* msgObj = [NSEntityDescription insertNewObjectForEntityForName:@"Msg" inManagedObjectContext:MY_API.managedObjectContext];
            [msgObj setValue:self.chatroomID forKey:@"chatroomID"];
            
            for (NSString* keys in [messagesDictionary allKeys]) {
                @try {
                    NSLog(@"key: %@", keys);
                    NSLog(@"value?: %@",[messagesDictionary objectForKey:keys]);
                    if ([keys isEqualToString:@"date"]) {
                        [msgObj setValue:msgDate forKey:keys];
                    }
                    else
                    {
                        [msgObj setValue:[messagesDictionary objectForKey:keys] forKey:keys];
                    }
                } @catch (NSException *exception) {
                    //NSLog(@"Create user ERROR: %@",exception);
                } @finally {
                    ///
                }
            }

            [chatRoom addMesagesObject:msgObj];
            //NSLog(@"UserADD");
            [MY_API saveContext];
        }

        
        

        
    } withCancelBlock:nil];
    
}

- (JSQMessage*) getMessageObject:(NSIndexPath*)indexPath
{
    Msg* tempMessage = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
//    NSLog(@"%@ tempMessage", tempMessage);
//    NSLog(@"%lu tempMessageIndex", indexPath.row);
    
    NSString *senderIdFromDatabase = tempMessage.senderId;
    NSString *senderDisplaynameFromDatabase = tempMessage.senderDisplayName;
    NSDate * messageDate = tempMessage.date;
    NSString *textFromDatabase = tempMessage.text;
    JSQMessage *jsqMsg;
    if (tempMessage.text) {
        jsqMsg = [[JSQMessage alloc] initWithSenderId:senderIdFromDatabase senderDisplayName:senderDisplaynameFromDatabase date:messageDate text:textFromDatabase];
        
    } else {
        
        UIImageView *chatImage = [[UIImageView alloc] init];
        
        [chatImage sd_setImageWithURL:[NSURL URLWithString:tempMessage.media] placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:chatImage.image];
        
        jsqMsg = [[JSQMessage alloc] initWithSenderId:senderIdFromDatabase senderDisplayName:senderDisplaynameFromDatabase date:messageDate media:photoItem];
        
        
    }
    return jsqMsg;
}

-(void)uploadImage: (NSString *)senderID senderDisplayName:(NSString *)senderName pickedImage:(UIImage *)pickedImage {
    
    //Uploading profile image
    NSString *chatMediaImage = [[NSUUID UUID] UUIDString];
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *chatMediaImageRef = [[[storage reference]
                                               child:@"ChatImages"]
                                              child:chatMediaImage];
    
    NSData *pickedImageData = UIImagePNGRepresentation(pickedImage);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Uploading";
    hud.bezelView.color = [self.UIPrinciple.netyBlue colorWithAlphaComponent:0.3f];
    [hud showAnimated:YES];
    
    //Uploading big profile picture first
    [chatMediaImageRef putData:pickedImageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        
        if (error) {
            [hud hideAnimated:YES];
            NSLog(@"%@", error.localizedDescription);
            [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Can not upload image" message:@"Please try again at another time" viewController:self];
            
        } else {
            
            NSNumber *secondsSince1970 = [NSNumber numberWithInt: -1 * [[NSDate date] timeIntervalSince1970]];
            
            NSString *dataUrlString = [[metadata downloadURL] absoluteString];
            
            NSDictionary *photoMessageData = @{ kSenderId: senderID,
                                                kSenderDisplayName: senderName,
                                                kDate: secondsSince1970,
                                                kMedia: dataUrlString};
            
            FIRDatabaseReference *photoMessageRef = [[[self.firdatabase child:kChatRooms] child:self.chatroomID] child:kMessages ];
            [[photoMessageRef childByAutoId] setValue:photoMessageData];
            
            [self editChatRoomInfo:@"Photo" date:secondsSince1970];
            
            [hud hideAnimated:YES];
        }
        
    }];
    
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
    NSNumber *secondsSince1970 = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970] * -1];
    
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
    
    UIImageView* imView = [[UIImageView alloc] init];
    [imView sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error)
        {
            self.incomingBubbleAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:35.0f];
        }
        else
        {
            self.incomingBubbleAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:kDefaultUserLogoName] diameter:35.0f];
        }
    }];
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Msg" inManagedObjectContext:MY_API.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"chatroomID == %@",_chatroomID];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kDate ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MY_API.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.collectionView performBatchUpdates:^{
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                [self scrollToBottomAnimated:YES];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
                
            default:
                return;
        }
    } completion:nil];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    [self.collectionView performBatchUpdates:^{
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(JSQMessagesCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath] withObject:[self getMessageObject:indexPath]];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    } completion:nil];
}

- (void)configureCell:(JSQMessagesCollectionViewCell*)cell withObject:(JSQMessage *)object
{
    if (!object.isMediaMessage) {
        
        if ([object.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }

}
@end
