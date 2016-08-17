//
//  MyNetwork.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyNetwork.h"


@interface MyNetwork ()

@end

@implementation MyNetwork


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
    
    [self.tableView reloadData];
    
    self.navigationItem.title = @"My Network";
    
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    self.userArray = [[NSMutableArray alloc] init];
    self.userKeyArray = [[NSMutableArray alloc] init];
    self.imageCache = [[NSCache alloc] init];

}

- (void)initializeDesign {
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style the navigation bar
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = @"My Network";
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
    [self.navigationController.navigationBar setBarTintColor:self.UIPrinciple.netyBlue];
    [self.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    
    
    //Set searchbar
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
}

- (void) initializeUsers {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    self.userDetailRef = [[[[self.firdatabase child:kUserDetails] child:[UserInformation getUserID]] child:kAddedUsers] queryOrderedByChild:kFirstName];
    
    [self listenForChildAdded];
    [self listenForChildRemoved];
    [self listenForChildChanged];

}

#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NoContent *noContent = [[NoContent alloc] init];

//    if ([self.userArray count] == 0) {
//        
//        NSLog(@"called");
//        NSString *contentText = [NSString stringWithFormat:@"There is no one %@ near you", self.title];
//        [self.UIPrinciple addNoContent:self setText:contentText noContentController:noContent];
//        
//    } else {
//        [self.UIPrinciple removeNoContent:noContent];
//    }
    
    return [self.userArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    MyNetworkCell *myNetworkCell = [tableView dequeueReusableCellWithIdentifier:@"MyNetworkCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    NSLog(@"cont %lu", [self.userArray count]);
    
        userDataDictionary = [self.userArray objectAtIndex:row];
        
        //Setting cell data
        myNetworkCell.myNetworkUserImage.image = [UIImage imageNamed: kDefaultUserLogoName];
        
        //Setting images
        NSString *photoUrl = [userDataDictionary objectForKey:kSmallProfilePhoto];
        if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
            NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
            [self loadAndCacheImage:myNetworkCell photoUrl:profileImageUrl cache:self.imageCache];
        } else {
            myNetworkCell.myNetworkUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
        }
        
        //Setting name
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [userDataDictionary objectForKey:kFirstName], [userDataDictionary objectForKey:kLastName]];
        myNetworkCell.myNetworkUserName.text = fullName;
        
        //Set job
        myNetworkCell.myNetworkUserJob.text = [userDataDictionary objectForKey:kIdentity];
        
        //Set description
        NSString *statusString = [userDataDictionary objectForKey:kStatus];
        NSString *summaryString = [userDataDictionary objectForKey:kSummary];
        
        if (![statusString isEqualToString:@""]) {
            
            myNetworkCell.myNetworkUserDescription.text = statusString;
            
        } else if (![summaryString isEqualToString:@""]){
        
            myNetworkCell.myNetworkUserDescription.text = summaryString;
            
        } else {
            
            myNetworkCell.myNetworkUserDescription.text = @"";
            
        }
        
        //Set selection color to blue
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
        [myNetworkCell setSelectedBackgroundView:bgColorView];
        //Set highlighted color to white
        myNetworkCell.myNetworkUserJob.highlightedTextColor = [UIColor whiteColor];
        myNetworkCell.myNetworkUserName.highlightedTextColor = [UIColor whiteColor];
        myNetworkCell.myNetworkUserDescription.highlightedTextColor = [UIColor whiteColor];
        
        
        //SWTableViewCell configuration
        NSMutableArray *myNetworkRightUtilityButtons = [[NSMutableArray alloc] init];
        
        [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyBlue
                                                             title:@"Block"];
        [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyRed
                                                             title:@"Delete"];
        
        myNetworkCell.rightUtilityButtons = myNetworkRightUtilityButtons;
        myNetworkCell.delegate = self;
        
    return myNetworkCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    Profile *profilePage = [profileStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    NSUInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
    
    profilePage.selectedUserID = [self.userKeyArray objectAtIndex:selectedRow];
    
    profilePage.selectedUserInfoDictionary = [self.userArray objectAtIndex:selectedRow];
    
    [self.navigationController pushViewController:profilePage animated:YES];
    
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            
            UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //BLOCK
                NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                NSString *userID = [UserInformation getUserID];
                NSString *otherUserID = [self.userKeyArray objectAtIndex:cellIndexPath.row];
                NSString *roomID = [self makeChatRoomID:userID otherUser:otherUserID];
                
                //Remove
                FIRDatabaseReference *otherUserChatRoomsRef = [[[self.firdatabase child:kUserChats] child:otherUserID] child:kChats];
                [[otherUserChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [self.firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
                //Adding blockedUser to UserDetails
                FIRDatabaseReference *userDetailsRef = [[[self.firdatabase child:kUserDetails] child:userID] child:kBlockedUsers];
                [userDetailsRef setValue:@{otherUserID:@0}];
                
                //Deleting addedUser from UserDetails
                FIRDatabaseReference *userAddedUsersRef = [[[self.firdatabase child:kUserDetails] child:userID] child:kAddedUsers];
                FIRDatabaseReference *otherUserAddedUsersRef = [[[self.firdatabase child:kUserDetails] child:otherUserID] child:kAddedUsers];
                [[userAddedUsersRef child:otherUserID] removeValue];
                [[otherUserAddedUsersRef child:userID] removeValue];
                
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
                NSString *userID = [UserInformation getUserID];
                NSString *otherUserID = [self.userKeyArray objectAtIndex:cellIndexPath.row];
                NSString *roomID = [self makeChatRoomID:userID otherUser:otherUserID];
                
                //Remove
                FIRDatabaseReference *otherUserChatRoomRef = [[[self.firdatabase child:kUserChats] child:otherUserID] child:kChats];
                [[otherUserChatRoomRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[self.firdatabase child:kUserChats] child:userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [self.firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
                //Deleting addedUser from UserDetails
                FIRDatabaseReference *userAddedUsersRef = [[[self.firdatabase child:kUserDetails] child:userID] child:kAddedUsers];
                FIRDatabaseReference *otherUserAddedUsersRef = [[[self.firdatabase child:kUserDetails] child:otherUserID] child:kAddedUsers];
                [[userAddedUsersRef child:otherUserID] removeValue];
                [[otherUserAddedUsersRef child:userID] removeValue];
                
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





#pragma mark - View Disappear
//---------------------------------------------------------


//Swiped cell will reset
- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView reloadData];
}


#pragma mark - Custom methods
//---------------------------------------------------------


//Function for downloading and caching the image
-(void)loadAndCacheImage:(MyNetworkCell *)myNetworkCell photoUrl:(NSURL *)photoUrl cache:(NSCache *)imageCache {
    
    //Set default to nil
    myNetworkCell.myNetworkUserImage.image = nil;
    NSURL *profileImageUrl = photoUrl;
    UIImage *cachedImage = [imageCache objectForKey:profileImageUrl];
    
    if (cachedImage) {
        
        myNetworkCell.myNetworkUserImage.image = cachedImage;
        
    } else {
        
        [[[NSURLSession sharedSession] dataTaskWithURL:profileImageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *downloadedImage = [UIImage imageWithData:data];
                
                if (downloadedImage != nil) {
                    [imageCache setObject:downloadedImage forKey:profileImageUrl];
                }
                
                myNetworkCell.myNetworkUserImage.image = downloadedImage;
                
            });
            
        }] resume];
        
    }
    
}

- (NSString *)makeChatRoomID: (NSString *)userID otherUser:(NSString *)otherUserID {
    
    //Making a room
    NSComparisonResult result = [userID compare:otherUserID];
    NSString *chatroomID;
    
    if (result == NSOrderedAscending) {
        
        chatroomID = [NSString stringWithFormat:@"%@%@", userID, otherUserID];
        
    } else {
        
        chatroomID = [NSString stringWithFormat:@"%@%@", otherUserID, userID];

    }
    
    return chatroomID;
}

- (void) listenForChildAdded {

    [self.userDetailRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *otherUserID = snapshot.key;
        
        FIRDatabaseReference *otherUserDetail = [[self.firdatabase child:kUsers] child:otherUserID];
        
        [otherUserDetail observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
            [self.userKeyArray addObject:snapshot.key];
            
            [self.userArray addObject:snapshot.value];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } withCancelBlock:nil];
        
    } withCancelBlock:nil];
    
}

- (void) listenForChildRemoved {
    
    [self.userDetailRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *otherUserID = snapshot.key;
        NSUInteger index = [self.userKeyArray indexOfObject:otherUserID];
        
        if (index != NSNotFound) {
            [self.userArray removeObjectAtIndex:index];
            [self.userKeyArray removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } withCancelBlock:nil];
    
}

- (void) listenForChildChanged {
    
    [self.userDetailRef observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *otherUserID = snapshot.key;
        NSUInteger index = [self.userKeyArray indexOfObject:otherUserID];
        NSMutableDictionary *userInformation = [self.userArray objectAtIndex:index];
        
        if (index != NSNotFound) {
            [self.userArray replaceObjectAtIndex:index withObject:userInformation];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } withCancelBlock:nil];
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
