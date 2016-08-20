//
//  Network.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Network.h"

@interface Network ()
{
    N_API* myAPI;
}

@end

@implementation Network

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSettings];
    [self initializeDesign];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    goingToProfileView = false;
    
    [self initializeUsers];
    //[self.tableView reloadData];
    
    self.sliderView = [[[NSBundle mainBundle] loadNibNamed:@"CustomSlider" owner:self options:nil] objectAtIndex:0];
    
    self.slider.value = self.sliderValue;
    
    [self addSlider:self.sliderView slider:self.slider];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Near Me", [self calculateDistanceToDescription]];
    self.tabBarController.tabBar.hidden = NO;
    
    
}


#pragma mark - Initialization
//---------------------------------------------------------

- (void)initializeSettings {
    
    myAPI = [N_API sharedController];
    //Set up notifications
    [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:@"4"];
    
    //Get location?
    //    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //    NSString *str = [appDelegate returnLatLongString];
    //
    //    NSLog(@"%@", str);
    
}

- (void)initializeDesign {
    
    //No separator
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style the navigation bar
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    
    self.slider.continuous = YES;
    
    self.sliderValue = (0.3);
    
    self.slider.value = self.sliderValue;
    NSLog(@"slidervalue set? %f", self.sliderValue);
    
    [self calculateSliderDistanceValue];
    
    navItem.title = @"";
    self.title = [NSString stringWithFormat:@"%@ Near Me", [self calculateDistanceToDescription]];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
    
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Near Me", [self calculateDistanceToDescription]];
    
}

- (void)initializeUsers {
    
//    self.usersArray = [[NSMutableArray alloc] init];
    self.userIDArray = [[NSMutableArray alloc] init];
    
//    self.firdatabase = [[FIRDatabase database] reference];
    
//    [self listenForChildAdded];
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:myAPI.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@""];
    //[fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userID" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:myAPI.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [self.usersArray count];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    NetworkCell *networkCell = [tableView dequeueReusableCellWithIdentifier:@"NetworkCell" forIndexPath:indexPath];
     Users *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self configureCell:networkCell withObject:object];
//    if ([self.usersArray count] > 0 ) {
    
//        //Setting cell data
//        NSDictionary *userDataDictionary = self.usersArray[row];
//        networkCell.networkUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
//        
//        //If image is not NetyBlueLogo, start downloading and caching the image
//        NSString *photoUrl = [userDataDictionary objectForKey:kProfilePhoto];
//        
//        if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
//            NSURL *profileImageUrl = [NSURL URLWithString:[userDataDictionary objectForKey:kProfilePhoto]];
//            //[self loadAndCacheImage:networkCell photoUrl:profileImageUrl cache:self.imageCache];
//            [networkCell.networkUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
//            
//        }
//        
//        
//        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [userDataDictionary objectForKey:kFirstName], [userDataDictionary objectForKey:kLastName]];
//        
//        //Set name
//        networkCell.networkUserName.text = fullName;
//        
//        //Set job
//        networkCell.networkUserJob.text = [userDataDictionary objectForKey:kIdentity];
//        
//        //Set description
//        NSString *statusString = [userDataDictionary objectForKey:kStatus];
//        NSString *summaryString = [userDataDictionary objectForKey:kSummary];
//        
//        if (![statusString isEqualToString:@""]) {
//            
//            networkCell.networkUserDescription.text = statusString;
//            
//        } else if (![summaryString isEqualToString:@""]){
//            
//            networkCell.networkUserDescription.text = summaryString;
//            
//        } else {
//            
//            networkCell.networkUserDescription.text = @"";
//            
//        }
//        
//        //DESIGN
//        //Setting font color of cells to black
//        networkCell.networkUserJob.textColor = [UIColor blackColor];
//        networkCell.networkUserName.textColor = [UIColor blackColor];
//        networkCell.networkUserDescription.textColor = [UIColor blackColor];
//        
//        //Set selection color to blue
//        UIView *bgColorView = [[UIView alloc] init];
//        bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
//        [networkCell setSelectedBackgroundView:bgColorView];
//        //Set highlighted color to white
//        networkCell.networkUserJob.highlightedTextColor = [UIColor whiteColor];
//        networkCell.networkUserName.highlightedTextColor = [UIColor whiteColor];
//        networkCell.networkUserDescription.highlightedTextColor = [UIColor whiteColor];
        
//    } else {
//        
//        NSString *contentText = [NSString stringWithFormat:@"There is no one %@ near you", self.title];
//        NoContent *noContent = [[NoContent alloc] init];
//        [self.UIPrinciple addNoContent:self setText:contentText noContentController:noContent];
//        
//    }
    
    return networkCell;
}

- (void)configureCell:(NetworkCell*)cell withObject:(Users*)object {
    //Setting cell data
    cell.networkUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    NSString *photoUrl = object.profileImageUrl;
    
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:object.profileImageUrl];
        //[self loadAndCacheImage:networkCell photoUrl:profileImageUrl cache:self.imageCache];
        [cell.networkUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
        
    }
    
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName];
    
    //Set name
    cell.networkUserName.text = fullName;
    
    //Set job
    cell.networkUserJob.text = object.identity;
    
    //Set description
    NSString *statusString = object.status;
    NSString *summaryString = object.summary;
    
    if (![statusString isEqualToString:@""]) {
        
        cell.networkUserDescription.text = statusString;
        
    } else if (![summaryString isEqualToString:@""]){
        
        cell.networkUserDescription.text = summaryString;
        
    } else {
        
        cell.networkUserDescription.text = @"";
        
    }
    
    //DESIGN
    //Setting font color of cells to black
    cell.networkUserJob.textColor = [UIColor blackColor];
    cell.networkUserName.textColor = [UIColor blackColor];
    cell.networkUserDescription.textColor = [UIColor blackColor];
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [cell setSelectedBackgroundView:bgColorView];
    //Set highlighted color to white
    cell.networkUserJob.highlightedTextColor = [UIColor whiteColor];
    cell.networkUserName.highlightedTextColor = [UIColor whiteColor];
    cell.networkUserDescription.highlightedTextColor = [UIColor whiteColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    Profile *profilePage = [profileStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
    profilePage.selectedUser = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    NSUInteger selectedRow = self.table.indexPathForSelectedRow.row;
//    
//    profilePage.selectedUserInfoDictionary = [[NSDictionary alloc] initWithDictionary: [self.usersArray objectAtIndex:selectedRow]];
//    
//    profilePage.selectedUserID = [[NSString alloc] initWithString:[self.userIDArray objectAtIndex:selectedRow]];
    
    goingToProfileView = true;
    
    __weak typeof(self) weakSelf = self;
    [self.UIPrinciple setTabBarVisible:![self.UIPrinciple tabBarIsVisible:self] animated:YES sender:self completion:^(BOOL finished) {
        NSLog(@"animation done");
        [weakSelf.sliderView removeFromSuperview];
        weakSelf.tabBarController.tabBar.hidden = YES;
    }];
    
    [self.navigationController pushViewController:profilePage animated:YES];
    
}

//Hide keyboard when search button pressed
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)sliderAction:(id)sender {
    
    NSLog(@"%f", self.slider.value);
    
    self.sliderValue = self.slider.value;
    
    [self calculateSliderDistanceValue];
    
    self.title = [NSString stringWithFormat:@"%@ Near", [self calculateDistanceToDescription]];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


-(void)viewWillDisappear:(BOOL)animated {
    
    if (goingToProfileView != true) {
        [self.sliderView removeFromSuperview];
    }
    
    //[self.tableView reloadData];
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void)addSlider:(UIView *)customSlider slider:(UISlider *)slider{
    
    float tabbarHeight = self.tabBarController.tabBar.frame.size.height;
    float sliderHeight = slider.frame.size.height;
    
    customSlider.frame = CGRectMake(0, self.view.frame.size.height-tabbarHeight - sliderHeight - 10, self.view.frame.size.width, slider.frame.size.height);
    
    slider.tintColor = self.UIPrinciple.netyBlue;
    
    customSlider.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:customSlider];
}

//-(void) listenForChildAdded {
//    
//    [[self.firdatabase child:kUsers] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        
//        NSDictionary *usersDictionary = snapshot.value;
//        NSString *otherUserID = snapshot.key;
//        NSString *userID = [UserInformation getUserID];
//        
//        if (![otherUserID isEqualToString: userID]) {
//            
//            [self.userIDArray addObject:otherUserID];
//            [self.usersArray addObject:usersDictionary];
//#warning RELOAD DATA
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//        
//    } withCancelBlock:nil];
//    
//}

-(void) calculateSliderDistanceValue {
    
    if (self.sliderValue >= 0 && self.sliderValue <= 0.1) {
        self.sliderDistanceValue = 30;
    } else if (self.sliderValue > 0.10 && self.sliderValue <= 0.20) {
        self.sliderDistanceValue = 50;
    } else if (self.sliderValue > 0.20 && self.sliderValue <= 0.30) {
        self.sliderDistanceValue = 100;
    } else if (self.sliderValue > 0.30 && self.sliderValue <= 0.40) {
        self.sliderDistanceValue = 200;
    } else if (self.sliderValue > 0.40 && self.sliderValue <= 0.50) {
        self.sliderDistanceValue = 300;
    }  else if (self.sliderValue > 0.50 && self.sliderValue <= 0.60) {
        self.sliderDistanceValue = 500;
    }  else if (self.sliderValue > 0.60 && self.sliderValue <= 0.70) {
        self.sliderDistanceValue = 5280 * 5;
    }  else if (self.sliderValue > 0.70 && self.sliderValue <= 0.80) {
        self.sliderDistanceValue = 5280 * 10;
    } else if (self.sliderValue > 0.80) {
        self.sliderDistanceValue = 5280 * 20;
    }
    
}

- (NSString *) calculateDistanceToDescription {
    
    if (self.sliderDistanceValue >= 5280) {
        return [NSString stringWithFormat:@"%i Miles", (int) self.sliderDistanceValue / 5280];
    } else {
        return [NSString stringWithFormat:@"%ift", (int) self.sliderDistanceValue];
    }
    
}

//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
