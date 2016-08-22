
//
//  Chat.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyChats.h"
#import "ChatCell.h"
#import "NetworkData.h"
#import "SWTableViewCell.h"
#import "UIPrinciples.h"
#import "Messages.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface MyChats ()

@end

@implementation MyChats


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
    [self initializeUsers];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    self.oldChatArray = [[NSMutableArray alloc] init];
    self.oldChatRoomKeyArray = [[NSMutableArray alloc] init];
}

- (void)initializeDesign {
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
}


- (void)initializeUsers {
    
    self.firdatabase = [[FIRDatabase database] reference];
    self.chatRoomsRef = [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] queryOrderedByChild:kUpdateTime];
    
    [self listenForChildAdded];
    [self listenForChildRemoved];
    [self listenForChildChanged];
    [self listenForChildMoved];
}

#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.oldChatArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    //Setting cell data as old chats
    userDataDictionary = [self.oldChatArray objectAtIndex:row];
    
    //Set images
    chatCell.chatUserImage.image = [UIImage imageNamed: kDefaultUserLogoName];
    NSString *photoUrl = [userDataDictionary objectForKey:kProfilePhoto];
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        //[self loadAndCacheImage:chatCell photoUrl:profileImageUrl cache:self.imageCache];
        [chatCell.chatUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    }
    
    //Set name
    chatCell.chatUserName.text = [userDataDictionary objectForKey:kFullName];
    
    //Set notification
    if ([[userDataDictionary objectForKey:kUnread] integerValue] == 0) {
        chatCell.chatNotificationView.backgroundColor = [UIColor clearColor];
        chatCell.chatNotificationLabel.text = @"";
    } else {
        chatCell.chatNotificationView.backgroundColor = self.UIPrinciple.netyBlue;
        chatCell.chatNotificationLabel.text = [NSString stringWithFormat:@"%@", [userDataDictionary objectForKey:kUnread]];
        NSLog(@"Unread: %@", [userDataDictionary objectForKey:kUnread]);
    }
    
    //Set description
    NSString *descriptionText = [userDataDictionary objectForKey:kRecentMessage];
    chatCell.chatDescription.text = descriptionText;
    
    //Set date
    double timeSince1970Double = [[userDataDictionary objectForKey:kUpdateTime] doubleValue] * -1;
    NSDate *messageDate = [self convertDoubleToDate:timeSince1970Double];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    NSString *dateFormat = [dateFormatter stringFromDate:messageDate];
    chatCell.chatTime.text = dateFormat;
    
    //SWTableViewCell configuration
    NSMutableArray *chatRightUtilityButtons = [[NSMutableArray alloc] init];
            
    [chatRightUtilityButtons sw_addUtilityButtonWithColor: self.UIPrinciple.netyBlue title:@"Block"];
    [chatRightUtilityButtons sw_addUtilityButtonWithColor: self.UIPrinciple.netyRed title:@"Leave"];
    
    chatCell.rightUtilityButtons = chatRightUtilityButtons;
    chatCell.delegate = self;
    
    return chatCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *messagesStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
    Messages *messagesVC = [messagesStoryboard instantiateViewControllerWithIdentifier:@"Messages"];
    
        
    messagesVC.chatroomID = [self.oldChatRoomKeyArray objectAtIndex:indexPath.row];
    messagesVC.selectedUserID = [[[self.oldChatArray objectAtIndex:indexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
    messagesVC.selectedUserProfileImageString = [[self.oldChatArray objectAtIndex:indexPath.row] objectForKey:kProfilePhoto];
    messagesVC.selectedUserName = [[self.oldChatArray objectAtIndex:indexPath.row] objectForKey:kFullName];
    
    [self.delegateFromMyChats pushViewControllerThroughProtocolFromMyChats:messagesVC];
    
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

//Actions when right swipe buttons are tapped
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {

    //OLD
    switch (index) {
        case 0: {
            
            UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //BLOCK
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                NSString *userID = MY_USER.userID;
                NSString *roomID = [self.oldChatRoomKeyArray objectAtIndex:cellIndexPath.row];
                NSString *selectedUserID = [[[self.oldChatArray objectAtIndex:cellIndexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
                
                //Remove
                FIRDatabaseReference *selectedUserChatRoomsRef = [[[self.firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                [[selectedUserChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [self.firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
                //Adding to UserDetails
                FIRDatabaseReference *userDetailsRef = [[[self.firdatabase child:kUserDetails] child:userID] child:kBlockedUsers];
                [userDetailsRef setValue:@{selectedUserID:@0}];
                
            }];
            
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [self.UIPrinciple twoButtonAlert:cont rightButton:okay controller:@"Block?" message:@"You will not see this person on this app, and all the chats will be deleted. Are you sure to block?" viewController:self];
            
            break;
        }
        case 1: {
            
            UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //DELETE
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                
                NSString *selectedUserID = [[[self.oldChatArray objectAtIndex:cellIndexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
                NSString *roomID = [self.oldChatRoomKeyArray objectAtIndex:cellIndexPath.row];
                
                FIRDatabaseReference *selectedUserChatRoomsRef = [[[self.firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                [[selectedUserChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [self.firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
            }];
            
            UIAlertAction *okay = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [self.UIPrinciple twoButtonAlert:cont rightButton:okay controller:@"Leave?" message:@"Are you sure? All the chats will be deleted." viewController:self];
            
            break;
        }
        default: {
            break;
        }
    }
}

//Hide keyboard when search button pressed
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)oldNewSegmentedAction:(id)sender {
    
    [self.tableView reloadData];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


//Swiped cell will reset
- (void)viewWillDisappear:(BOOL)animated {
    //    [self.chatRoomsRef removeAllObservers];
    
    [self.tableView reloadData];
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void)listenForChildAdded {
    
    [self.chatRoomsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSDictionary *members = [snapshot.value objectForKey:kMembers];
        NSString *chatRoomKey = snapshot.key;
        
        NSLog(@"Got snapchat: %@", snapshot.value);
        NSLog(@"Got you: %@", [members objectForKey:@"member1"]);
        
        FIRDatabaseReference *userInfoRef = [[self.firdatabase child:kUsers] child:[members objectForKey:@"member1"]];
        [userInfoRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSString *profilePhotoUrl = [snapshot.value objectForKey:kProfilePhoto];
            NSString *name = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:kFirstName], [snapshot.value objectForKey:kLastName]];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kProfilePhoto];

            if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 1) {
                [self.oldChatArray addObject:chatRoomInfoDict];
                [self.oldChatRoomKeyArray addObject:chatRoomKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
        } withCancelBlock:nil];
        
    } withCancelBlock:nil];
    
}

-(void)listenForChildRemoved {
    
    [self.chatRoomsRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSString *chatRoomKey = snapshot.key;
        
        if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 1) {
            NSUInteger index = [self.oldChatRoomKeyArray indexOfObject:chatRoomKey];
            
            if (index != NSNotFound) {
                [self.oldChatArray removeObjectAtIndex:index];
                [self.oldChatRoomKeyArray removeObjectAtIndex:index];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        }
        
    } withCancelBlock:nil];
    
}

-(void)listenForChildChanged {
    
    //THIS PART CRASHES!!!
    [self.chatRoomsRef observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSDictionary *members = [snapshot.value objectForKey:kMembers];
        NSString *chatRoomKey = snapshot.key;
        
        //        NSLog(@"Got snapchat 2: %@", snapshot.value);
        //        NSLog(@"Got you 2: %@", [members objectForKey:@"member1"]);
        
        FIRDatabaseReference *userInfoRef = [[self.firdatabase child:kUsers] child:[members objectForKey:@"member1"]];
        [userInfoRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSString *profilePhotoUrl = [snapshot.value objectForKey:kProfilePhoto];
            NSString *name = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:kFirstName], [snapshot.value objectForKey:kLastName]];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kProfilePhoto];
            
            if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 1) {
                
                NSUInteger index = [self.oldChatRoomKeyArray indexOfObject:chatRoomKey];
                
                if (index != NSNotFound) {
                    [self.oldChatArray replaceObjectAtIndex:index withObject:chatRoomInfoDict];
                    [self.oldChatRoomKeyArray replaceObjectAtIndex:index withObject:chatRoomKey];
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } withCancelBlock:nil];
        
    } withCancelBlock:nil];
    
}

-(void)listenForChildMoved {
    
    [self.chatRoomsRef observeEventType:FIRDataEventTypeChildMoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        //        NSLog(@"moved: %@", snapshot.value);
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSDictionary *members = [snapshot.value objectForKey:kMembers];
        NSString *chatRoomKey = snapshot.key;
        
        FIRDatabaseReference *userInfoRef = [[self.firdatabase child:kUsers] child:[members objectForKey:@"member1"]];
        [userInfoRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSString *profilePhotoUrl = [snapshot.value objectForKey:kProfilePhoto];
            NSString *name = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:kFirstName], [snapshot.value objectForKey:kLastName]];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kProfilePhoto];
            
            if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 1) {
                NSUInteger index = [self.oldChatRoomKeyArray indexOfObject:chatRoomKey];
                
                if (index != NSNotFound) {
                    NSDictionary *objectAtIndex = [self.oldChatArray objectAtIndex:index];
                    [self.oldChatArray removeObjectAtIndex:index];
                    [self.oldChatArray insertObject:objectAtIndex atIndex:0];
                    NSString *roomKeyAtIndex = [self.oldChatRoomKeyArray objectAtIndex:index];
                    [self.oldChatRoomKeyArray removeObjectAtIndex:index];
                    [self.oldChatRoomKeyArray insertObject:roomKeyAtIndex atIndex:0];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } withCancelBlock:nil];
        
    } withCancelBlock:nil];
    
}

- (NSDate *)convertDoubleToDate: (double)timeIntervalDouble {
    NSNumber *timeIntervalInNumber = [NSNumber numberWithInt:timeIntervalDouble];
    NSTimeInterval timeInterval = [timeIntervalInNumber doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return date;
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
