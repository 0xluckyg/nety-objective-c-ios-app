//
//  Network.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Network.h"

@interface Network ()

@end

@implementation Network


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"2");
    
    [self initializeSettings];
    [self initializeDesign];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = @"Near me";
    
    [self initializeUsers];
    [self.tableView reloadData];
}


#pragma mark - Initialization
//---------------------------------------------------------

- (void)initializeSettings {
        
    self.imageCache = [[NSCache alloc] init];
    
    //Set up notifications
    [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:@"4"];
    
    //Get location?
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *str = [appDelegate returnLatLongString];
    
    NSLog(@"%@", str);
    
}

- (void)initializeDesign {
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style the navigation bar
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = @"Near me";
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
//    [self.navigationController.navigationBar setBarTintColor:self.UIPrinciple.netyBlue];
//    [self.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    //Set searchbar
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
    
}

- (void)initializeUsers {
    
    self.usersArray = [[NSMutableArray alloc] init];
    self.userIDArray = [[NSMutableArray alloc] init];
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    [[self.firdatabase child:kUsers] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *usersDictionary = snapshot.value;
        
        [self.userIDArray addObjectsFromArray:[usersDictionary allKeys]];
                
        [self.usersArray addObjectsFromArray:[usersDictionary allValues]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } withCancelBlock:nil];
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"array count: %lu", [self.usersArray count]);
    return [self.usersArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    NetworkCell *networkCell = [tableView dequeueReusableCellWithIdentifier:@"NetworkCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    if ([self.usersArray count] > 0 ) {
        
        //Setting cell data
        NSDictionary *userDataDictionary = self.usersArray[row];
        networkCell.networkUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
        
        //If image is not NetyBlueLogo, start downloading and caching the image
        NSString *photoUrl = [userDataDictionary objectForKey:kProfilePhoto];

        if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
            NSURL *profileImageUrl = [NSURL URLWithString:[userDataDictionary objectForKey:kProfilePhoto]];
            [self loadAndCacheImage:networkCell photoUrl:profileImageUrl cache:self.imageCache];
        } else {
            networkCell.networkUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
        }

        
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [userDataDictionary objectForKey:kFirstName], [userDataDictionary objectForKey:kLastName]];
        
        //Set name
        networkCell.networkUserName.text = fullName;
        
        //Set job
        networkCell.networkUserJob.text = [userDataDictionary objectForKey:kIdentity];
        
        //Set description
        NSString *statusString = [userDataDictionary objectForKey:kStatus];
        NSString *summaryString = [userDataDictionary objectForKey:kSummary];

        if (![statusString isEqualToString:@""]) {
            
            networkCell.networkUserDescription.text = statusString;
            
        } else if (![summaryString isEqualToString:@""]){
            
            networkCell.networkUserDescription.text = summaryString;
            
        } else {
        
            networkCell.networkUserDescription.text = @"";
            
        }
        
        //DESIGN
        //Setting font color of cells to black
        networkCell.networkUserJob.textColor = [UIColor blackColor];
        networkCell.networkUserName.textColor = [UIColor blackColor];
        networkCell.networkUserDescription.textColor = [UIColor blackColor];
        
        //Set selection color to blue
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
        [networkCell setSelectedBackgroundView:bgColorView];
        //Set highlighted color to white
        networkCell.networkUserJob.highlightedTextColor = [UIColor whiteColor];
        networkCell.networkUserName.highlightedTextColor = [UIColor whiteColor];
        networkCell.networkUserDescription.highlightedTextColor = [UIColor whiteColor];
        
    }
    
    return networkCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    Profile *profilePage = [profileStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    NSUInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
    
    NSLog(@"1: %lu", [self.usersArray count]);
    
    profilePage.selectedUserInfoDictionary = [[NSDictionary alloc] initWithDictionary: [self.usersArray objectAtIndex:selectedRow]];
    
    NSLog(@"2: %lu", [self.userIDArray count]);
    profilePage.selectedUserID = [[NSString alloc] initWithString:[self.userIDArray objectAtIndex:selectedRow]];
    
    [self.navigationController pushViewController:profilePage animated:YES];
    
}

//Hide keyboard when search button pressed
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------





#pragma mark - View Disappear
//---------------------------------------------------------


-(void)viewWillDisappear:(BOOL)animated {
   [self.tableView reloadData];
}


#pragma mark - Custom methods
//---------------------------------------------------------


//Function for downloading and caching the image
-(void)loadAndCacheImage:(NetworkCell *)networkCell photoUrl:(NSURL *)photoUrl cache:(NSCache *)imageCache {
    
    //Set default to nil
    networkCell.networkUserImage.image = nil;
    
    NSURL *profileImageUrl = photoUrl;
    
    UIImage *cachedImage = [imageCache objectForKey:profileImageUrl];
    
    if (cachedImage) {
        
        networkCell.networkUserImage.image = cachedImage;
        
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
                    
                networkCell.networkUserImage.image = downloadedImage;
                
            });
            
        }] resume];
        
    }

}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
