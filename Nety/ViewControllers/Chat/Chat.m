//
//  Chat.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Chat.h"
#import "ChatCell.h"
#import "NetworkData.h"
#import "SWTableViewCell.h"
#import "UIPrinciples.h"
#import "Messages.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface Chat ()

@end

@implementation Chat


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
    self.recentChatArray = [[NSMutableArray alloc] init];
    self.recentChatRoomKeyArray = [[NSMutableArray alloc] init];
    self.oldChatRoomKeyArray = [[NSMutableArray alloc] init];
    
    self.imageCache = [[NSCache alloc] init];
}

- (void)initializeDesign {
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set searchbar color
    [self.topBar setBackgroundColor:self.UIPrinciple.netyBlue];
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
    
    //Set up option view color
    [self.oldNewView setBackgroundColor:self.UIPrinciple.netyBlue];
}


- (void)initializeUsers {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    self.chatRoomsRef = [[[[self.firdatabase child:kUserChats] child:[UserInformation getUserID]] child:kChats] queryOrderedByChild:kUpdateTime];
    
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
    
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 0) {
        return [self.recentChatArray count];
    } else {
        return [self.oldChatArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 0) {
        
        //Setting cell data as recent chats
        userDataDictionary = [self.recentChatArray objectAtIndex:row];
        
    } else {
    
        //Setting cell data as old chats
        userDataDictionary = [self.oldChatArray objectAtIndex:row];
        
    }
    
    //Set images
    chatCell.chatUserImage.image = [UIImage imageNamed: kDefaultUserLogoName];
    NSString *photoUrl = [userDataDictionary objectForKey:kSmallProfilePhoto];
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        //[self loadAndCacheImage:chatCell photoUrl:profileImageUrl cache:self.imageCache];
        [chatCell.chatUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    }
//    else {
//        chatCell.chatUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
//    }
    
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
    
    
    //DESIGN
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [chatCell setSelectedBackgroundView:bgColorView];
    //Set highlighted color to white
    chatCell.chatUserName.highlightedTextColor = [UIColor whiteColor];
    chatCell.chatTime.highlightedTextColor = [UIColor whiteColor];
    chatCell.chatDescription.highlightedTextColor = [UIColor whiteColor];
    
    //SWTableViewCell configuration
    NSMutableArray *chatRightUtilityButtons = [[NSMutableArray alloc] init];
    
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 1) {
        
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyBlue
                                                        title:@"Block"];
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyRed
                                                        title:@"Leave"];
        
    } else {
        
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyGray
                                                        title:@"Block"];
        
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyBlue
                                                        title:@"Add"];
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyRed
                                                        title:@"Leave"];
        
    }
    
    chatCell.rightUtilityButtons = chatRightUtilityButtons;
    chatCell.delegate = self;
    
    return chatCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *messagesStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
    Messages *messagesVC = [messagesStoryboard instantiateViewControllerWithIdentifier:@"Messages"];
    
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 0) {
    
        messagesVC.chatroomID = [self.recentChatRoomKeyArray objectAtIndex:indexPath.row];
        messagesVC.selectedUserID = [[[self.recentChatArray objectAtIndex:indexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
        messagesVC.selectedUserProfileImageString = [[self.recentChatArray objectAtIndex:indexPath.row] objectForKey:kSmallProfilePhoto];
        messagesVC.selectedUserName = [[self.recentChatArray objectAtIndex:indexPath.row] objectForKey:kFullName];
        
    } else {
    
        messagesVC.chatroomID = [self.oldChatRoomKeyArray objectAtIndex:indexPath.row];
        messagesVC.selectedUserID = [[[self.oldChatArray objectAtIndex:indexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
        messagesVC.selectedUserProfileImageString = [[self.oldChatArray objectAtIndex:indexPath.row] objectForKey:kSmallProfilePhoto];
        messagesVC.selectedUserName = [[self.oldChatArray objectAtIndex:indexPath.row] objectForKey:kFullName];
        
    }
    
    [self.navigationController pushViewController:messagesVC animated:YES];
    
    
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

//Actions when right swipe buttons are tapped
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 0) {
        //NEW
        switch (index) {
            case 0: {
                
                UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    //BLOCK
                    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                    NSString *userID = [UserInformation getUserID];
                    NSString *roomID = [self.recentChatRoomKeyArray objectAtIndex:cellIndexPath.row];
                    NSString *selectedUserID = [[[self.recentChatArray objectAtIndex:cellIndexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
                    
                    //Remove
                    FIRDatabaseReference *selectedUserChatRoomsRef = [[[self.firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                    [[selectedUserChatRoomsRef child:roomID] removeValue];
                    
                    FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:[UserInformation getUserID]] child:kChats] ;
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
                
                //ADD
                
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                
                NSString *userID = [UserInformation getUserID];
                NSString *roomID = [self.recentChatRoomKeyArray objectAtIndex:cellIndexPath.row];
                
                FIRDatabaseReference *userChatRoomRef = [[[self.firdatabase child:kUserChats] child:userID] child:kChats];
                
                NSMutableDictionary *chatRoomItem = [self.recentChatArray objectAtIndex:cellIndexPath.row];
                [chatRoomItem setValue:@1 forKey:kType];
                
                [[userChatRoomRef child:roomID] removeValue];
                
                [[userChatRoomRef child:roomID] setValue:chatRoomItem];
                
                NSLog(@"%@", chatRoomItem);
                
                //Adding to UserDetails
                NSString *selectedUserID = [[[self.recentChatArray objectAtIndex:cellIndexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
                
                FIRDatabaseReference *userDetailsRef = [[[self.firdatabase child:kUserDetails] child:userID] child:kAddedUsers];
                [userDetailsRef setValue:@{selectedUserID:@0}];
                
                break;
            }
            case 2: {
                
                UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    //DELETE
                    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                    
                    NSString *selectedUserID = [[[self.recentChatArray objectAtIndex:cellIndexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
                    NSString *roomID = [self.recentChatRoomKeyArray objectAtIndex:cellIndexPath.row];
                    
                    FIRDatabaseReference *selectedUserChatRoomsRef = [[[self.firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                    [[selectedUserChatRoomsRef child:roomID] removeValue];
                    
                    FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:[UserInformation getUserID]] child:kChats] ;
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
        
    } else {
        //OLD
        switch (index) {
            case 0: {

                UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    //BLOCK
                    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                    NSString *userID = [UserInformation getUserID];
                    NSString *roomID = [self.oldChatRoomKeyArray objectAtIndex:cellIndexPath.row];
                    NSString *selectedUserID = [[[self.oldChatArray objectAtIndex:cellIndexPath.row] objectForKey:kMembers] objectForKey:@"member1"];
                    
                    //Remove
                    FIRDatabaseReference *selectedUserChatRoomsRef = [[[self.firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                    [[selectedUserChatRoomsRef child:roomID] removeValue];
                    
                    FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:[UserInformation getUserID]] child:kChats] ;
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
                    
                    FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:[UserInformation getUserID]] child:kChats] ;
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


//Function for downloading and caching the image
//-(void)loadAndCacheImage:(ChatCell *)chatCell photoUrl:(NSURL *)photoUrl cache:(NSCache *)imageCache {
//    
//    //Set default to nil
//    chatCell.chatUserImage.image = nil;
//    NSURL *profileImageUrl = photoUrl;
//    UIImage *cachedImage = [imageCache objectForKey:profileImageUrl];
//    
//    if (cachedImage) {
//        
//        chatCell.chatUserImage.image = cachedImage;
//        
//    } else {
//        
//        [[[NSURLSession sharedSession] dataTaskWithURL:profileImageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (error != nil) {
//                NSLog(@"%@", error);
//                return;
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                UIImage *downloadedImage = [UIImage imageWithData:data];
//                
//                if (downloadedImage != nil) {
//                    [imageCache setObject:downloadedImage forKey:profileImageUrl];
//                }
//                
//                chatCell.chatUserImage.image = downloadedImage;
//                
//            });
//            
//        }] resume];
//        
//    }
//    
//}

-(void)listenForChildAdded {
    
    [self.chatRoomsRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSDictionary *members = [snapshot.value objectForKey:kMembers];
        NSString *chatRoomKey = snapshot.key;
        
        NSLog(@"Got snapchat: %@", snapshot.value);
        NSLog(@"Got you: %@", [members objectForKey:@"member1"]);
        
        FIRDatabaseReference *userInfoRef = [[self.firdatabase child:kUsers] child:[members objectForKey:@"member1"]];
        [userInfoRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSString *profilePhotoUrl = [snapshot.value objectForKey:kSmallProfilePhoto];
            NSString *name = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:kFirstName], [snapshot.value objectForKey:kLastName]];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kSmallProfilePhoto];
            
            if (self.oldNewSegmentedControl.selectedSegmentIndex == 0) {
                
                if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 0) {
                    
                    [self.recentChatArray addObject:chatRoomInfoDict];
                    [self.recentChatRoomKeyArray addObject:chatRoomKey];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                    NSLog(@"dict value: %@", chatRoomInfoDict);
                } else {
                    [self.oldChatArray addObject:chatRoomInfoDict];
                    [self.oldChatRoomKeyArray addObject:chatRoomKey];
                }
                
            } else {
            
                if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 0) {
                    [self.recentChatArray addObject:chatRoomInfoDict];
                    [self.recentChatRoomKeyArray addObject:chatRoomKey];
                } else {
                    [self.oldChatArray addObject:chatRoomInfoDict];
                    [self.oldChatRoomKeyArray addObject:chatRoomKey];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
                
            }
            
        } withCancelBlock:nil];
        
    } withCancelBlock:nil];
    
}

-(void)listenForChildRemoved {
    
    [self.chatRoomsRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSString *chatRoomKey = snapshot.key;
        
        if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 0) {
            NSUInteger index = [self.recentChatRoomKeyArray indexOfObject:chatRoomKey];
            
            if (index != NSNotFound) {
                [self.recentChatArray removeObjectAtIndex:index];
                [self.recentChatRoomKeyArray removeObjectAtIndex:index];
                if (self.oldNewSegmentedControl.selectedSegmentIndex == 0) {
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        } else {
            NSUInteger index = [self.oldChatRoomKeyArray indexOfObject:chatRoomKey];
            
            if (index != NSNotFound) {
                [self.oldChatArray removeObjectAtIndex:index];
                [self.oldChatRoomKeyArray removeObjectAtIndex:index];
                if (self.oldNewSegmentedControl.selectedSegmentIndex == 1) {
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                }
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
        
            NSString *profilePhotoUrl = [snapshot.value objectForKey:kSmallProfilePhoto];
            NSString *name = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:kFirstName], [snapshot.value objectForKey:kLastName]];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kSmallProfilePhoto];
            
            if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 0) {
                
                NSUInteger index = [self.recentChatRoomKeyArray indexOfObject:chatRoomKey];
                
                if (index != NSNotFound) {
                    [self.recentChatArray replaceObjectAtIndex:index withObject:chatRoomInfoDict];
                    [self.recentChatRoomKeyArray replaceObjectAtIndex:index withObject:chatRoomKey];
                }

            } else {
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
            
            NSString *profilePhotoUrl = [snapshot.value objectForKey:kSmallProfilePhoto];
            NSString *name = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:kFirstName], [snapshot.value objectForKey:kLastName]];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kSmallProfilePhoto];
            
            if ([[chatRoomInfoDict objectForKey:kType] integerValue] == 0) {
                NSUInteger index = [self.recentChatRoomKeyArray indexOfObject:chatRoomKey];
                
                if (index != NSNotFound) {
                    NSDictionary *objectAtIndex = [self.recentChatArray objectAtIndex:index];
                    [self.recentChatArray removeObjectAtIndex:index];
                    [self.recentChatArray insertObject:objectAtIndex atIndex:0];
                    NSString *roomKeyAtIndex = [self.recentChatRoomKeyArray objectAtIndex:index];
                    [self.recentChatRoomKeyArray removeObjectAtIndex:index];
                    [self.recentChatRoomKeyArray insertObject:roomKeyAtIndex atIndex:0];
                }
            } else {
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
