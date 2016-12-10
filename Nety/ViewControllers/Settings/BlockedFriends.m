//
//  BlockedFriends.m
//  Nety
//
//  Created by Scott Cho on 12/4/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "BlockedFriends.h"

@interface BlockedFriends ()

@end

@implementation BlockedFriends

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
}

- (void)initializeDesign {
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = @"Blocked Friends";
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setBarTintColor:self.UIPrinciple.netyTheme];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.table.emptyDataSetSource = self;
    self.table.emptyDataSetDelegate = self;
    self.table.tableFooterView = [UIView new];
}

#pragma mark - Protocols and Delegates
//---------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    BlockedFriendsCell *blockedFriendsCell = [tableView dequeueReusableCellWithIdentifier:@"BlockedFriendsCell" forIndexPath:indexPath];
    
    Users *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self configureCell:blockedFriendsCell withObject:user];
    
    return blockedFriendsCell;
}

- (void)configureCell:(BlockedFriendsCell*)cell withObject:(Users*)object
{
    NSString *photoUrl = object.profileImageUrl;
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        //[self loadAndCacheImage:myNetworkCell photoUrl:profileImageUrl cache:self.imageCache];
        [cell.blockedUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    }
    
    //Setting name
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName];
    cell.blockedUserName.text = fullName;
    
    //Set job
    cell.blockedUserJob.text = object.identity;
    
    //SWTableViewCell configuration
    NSMutableArray *myNetworkRightUtilityButtons = [[NSMutableArray alloc] init];
    
    [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyTheme
                                                         title:@"Unblock"];
    
    cell.rightUtilityButtons = myNetworkRightUtilityButtons;
    cell.delegate = self;
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
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isBlocked == YES"];
    if (_searchBar.text.length)
    {
        predicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[c]%@ OR lastName CONTAINS[c]%@ OR status CONTAINS[c]%@ OR summary CONTAINS[c]%@) AND isBlocked == YES AND itIsMe != YES",_searchBar.text,_searchBar.text,_searchBar.text,_searchBar.text];
    }
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:100];
    
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

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"NO BLOCKED FRIENDS";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"You can swipe right on your chat to block the person";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    FIRDatabaseReference* firdatabase = [[FIRDatabase database] reference];
    Users *user = [[self fetchedResultsController] objectAtIndexPath:[self.table indexPathForCell:cell]];
    
    NSString *userID = MY_API.myUser.userID;
    NSString *otherUserID = user.userID;
    
    switch (index) {
        case 0: {
            
            //Removing blockedUser to UserDetails
            FIRDatabaseReference *userDetailsRef = [[[[firdatabase child:kUserDetails] child:userID] child:kBlockedUsers] child:otherUserID];
            [userDetailsRef removeValue];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:MY_API.managedObjectContext];
            [fetchRequest setEntity:entity];
            
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userID == %@", otherUserID];
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            NSArray *fetchedObjects = [MY_API.managedObjectContext executeFetchRequest:fetchRequest error:&error];
       
            Users *userData = [fetchedObjects lastObject];
            [userData setIsBlocked:[NSNumber numberWithBool:NO]];
            [MY_API saveContext];
            
            
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

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)backButtonPressed {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
