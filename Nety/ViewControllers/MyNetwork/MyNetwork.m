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
    
    return [self.userArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    MyNetworkCell *myNetworkCell = [tableView dequeueReusableCellWithIdentifier:@"MyNetworkCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
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
    
    [self performSegueWithIdentifier:@"ShowProfileSegue" sender:indexPath];
    
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            
            
            break;
        }
        case 1: {
            NSLog(@"1 pressed");
            
            
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
        
    } withCancelBlock:nil];
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
