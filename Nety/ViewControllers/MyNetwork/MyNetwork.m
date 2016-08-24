//
//  MyNetwork.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyNetwork.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const myNetworkNoContentString = @"You don't have friends yet. Swipe left on your chats to add people!";

@interface MyNetwork ()

@end

@implementation MyNetwork

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    self.navigationItem.title = @"My Network";
    
    
    //If no experiences visible, show noContent header
    if ([[self fetchedResultsController].fetchedObjects count] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"Friend"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self.UIPrinciple addNoContent:self setText:myNetworkNoContentString setImage:contentImage setColor:self.UIPrinciple.netyGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    self.noContentController = [[NoContent alloc] init];

}

- (void)initializeDesign {
    
    //No separator
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

    
    
    //Set searchbar
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
}

- (void) initializeUsers {
    

}

#pragma mark - Protocols and Delegates
//---------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];

    if ([sectionInfo numberOfObjects] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"Friend"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self.UIPrinciple addNoContent:self setText:myNetworkNoContentString setImage:contentImage setColor:self.UIPrinciple.netyGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
        
    }
    
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    MyNetworkCell *myNetworkCell = [tableView dequeueReusableCellWithIdentifier:@"MyNetworkCell" forIndexPath:indexPath];
    
    Users *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self configureCell:myNetworkCell withObject:user];
    
    //If no experiences visible, show noContent header
    if ([[self fetchedResultsController].fetchedObjects count] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"Friend"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self.UIPrinciple addNoContent:self setText:myNetworkNoContentString setImage:contentImage setColor:self.UIPrinciple.netyGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    return myNetworkCell;
}

- (void)configureCell:(MyNetworkCell*)cell withObject:(Users*)object
{
    NSString *photoUrl = object.profileImageUrl;
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        //[self loadAndCacheImage:myNetworkCell photoUrl:profileImageUrl cache:self.imageCache];
        [cell.myNetworkUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    }
    
    //Setting name
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName];
    cell.myNetworkUserName.text = fullName;
    
    //Set job
    cell.myNetworkUserJob.text = object.identity;
    
    //Set description
    NSString *statusString = object.status;
    NSString *summaryString = object.summary;
    
    if (![statusString isEqualToString:@""]) {
        
        cell.myNetworkUserDescription.text = statusString;
        
    } else if (![summaryString isEqualToString:@""]){
        
        cell.myNetworkUserDescription.text = summaryString;
        
    } else {
        
        cell.myNetworkUserDescription.text = @"";
        
    }
    
    //SWTableViewCell configuration
    NSMutableArray *myNetworkRightUtilityButtons = [[NSMutableArray alloc] init];
    
    [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyBlue
                                                         title:@"Block"];
    [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyRed
                                                         title:@"Delete"];
    
    cell.rightUtilityButtons = myNetworkRightUtilityButtons;
    cell.delegate = self;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    Profile *profilePage = [profileStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    Users *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    profilePage.selectedUser = user;
    
    __weak typeof(self) weakSelf = self;
    [self.UIPrinciple setTabBarVisible:![self.UIPrinciple tabBarIsVisible:self] animated:YES sender:self completion:^(BOOL finished) {
        NSLog(@"animation done");
        weakSelf.tabBarController.tabBar.hidden = YES;
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:profilePage animated:YES];
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:MY_API.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isFriend == YES AND isBlocked == NO"];
    if (_searchBar.text.length)
    {
        predicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[c]%@ OR lastName CONTAINS[c] %@) AND itIsMe != YES AND isFriend == YES AND isBlocked == NO",_searchBar.text,_searchBar.text];
    }
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userID" ascending:YES];
    
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

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    FIRDatabaseReference* firdatabase = [[FIRDatabase database] reference];
    Users *user = [[self fetchedResultsController] objectAtIndexPath:[self.table indexPathForCell:cell]];
    
    NSString *userID = MY_API.myUser.userID;
    NSString *otherUserID = user.userID;
    NSString *roomID = [self makeChatRoomID:userID otherUser:otherUserID];
    
    switch (index) {
        case 0: {
            
            UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //BLOCK
                
                //Remove
                FIRDatabaseReference *otherUserChatRoomsRef = [[[firdatabase child:kUserChats] child:otherUserID] child:kChats];
                [[otherUserChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[firdatabase child:kUserChats] child:userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
                //Adding blockedUser to UserDetails
                FIRDatabaseReference *userDetailsRef = [[[firdatabase child:kUserDetails] child:userID] child:kBlockedUsers];
                [userDetailsRef setValue:@{otherUserID:@0}];
                
                //Deleting addedUser from UserDetails
                FIRDatabaseReference *userAddedUsersRef = [[[firdatabase child:kUserDetails] child:userID] child:kAddedUsers];
                FIRDatabaseReference *otherUserAddedUsersRef = [[[firdatabase child:kUserDetails] child:otherUserID] child:kAddedUsers];
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
                
                //Remove
                FIRDatabaseReference *otherUserChatRoomRef = [[[firdatabase child:kUserChats] child:otherUserID] child:kChats];
                [[otherUserChatRoomRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[firdatabase child:kUserChats] child:userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
                //Deleting addedUser from UserDetails
                FIRDatabaseReference *userAddedUsersRef = [[[firdatabase child:kUserDetails] child:userID] child:kAddedUsers];
                FIRDatabaseReference *otherUserAddedUsersRef = [[[firdatabase child:kUserDetails] child:otherUserID] child:kAddedUsers];
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    _fetchedResultsController = nil;
    _fetchedResultsController.delegate = nil;
    [self.table reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [_searchBar setText:@""];
    _fetchedResultsController = nil;
    _fetchedResultsController.delegate = nil;
    [self.table reloadData];
}


#pragma mark - Buttons
//---------------------------------------------------------





#pragma mark - View Disappear
//---------------------------------------------------------



#pragma mark - Custom methods
//---------------------------------------------------------

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

//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
