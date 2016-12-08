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
        
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"sliderNetwork"] == nil) {
        self.sliderValue = 0.3;
        self.slider.value = self.sliderValue;
    } else {
        self.sliderValue = [[userDef objectForKey:@"sliderNetwork"] floatValue];
        self.slider.value = self.sliderValue;
    }
    [self calculateSliderDistanceValue];

    NSString *distanceString = [self calculateDistanceToDescription];
   
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@ nearMe", @"{distance} Near Me"), distanceString];

    navItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@ nearMe", @"{distance} Near Me"), distanceString];
    
    //If no experiences visible, show noContent header
    if ([[self fetchedResultsController].fetchedObjects count] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self.UIPrinciple addNoContent:self setText:NSLocalizedString(@"nobodyNearYou", nil) setImage:contentImage setColor:self.UIPrinciple.netyGray setSecondColor:self.UIPrinciple.defaultGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    _fetchedResultsController = nil;
    _fetchedResultsController.delegate = nil;
    [self.table reloadData];
    
    
}

#pragma mark - Initialization
//---------------------------------------------------------

- (void)initializeSettings {
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"sliderNetwork"] == nil) {
        self.sliderValue = 0.3;
        self.slider.value = self.sliderValue;
    } else {
        self.sliderValue = [[userDef objectForKey:@"sliderNetwork"] floatValue];
        self.slider.value = self.sliderValue;
    }
    
    [self calculateSliderDistanceValue];
    
    self.noContentController = [[NoContent alloc] init];
}

- (void)initializeDesign {
    
    //No separator
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style the navigation bar
    navItem= [[UINavigationItem alloc] init];
    
    self.slider.continuous = YES;
    
    [self.slider setTintColor:self.UIPrinciple.netyTheme];
    
    float sliderViewWidth = self.sliderView.frame.size.width;
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sliderViewWidth, 1)];/// change size as you need.
    separatorLineView.backgroundColor = self.UIPrinciple.netyGray;
    [self.sliderView addSubview:separatorLineView];
    
    navItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@ nearMe", @"{distance} Near Me"), [self calculateDistanceToDescription]];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
    
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@ nearMe", @"{distance} Near Me"), [self calculateDistanceToDescription]];
    navItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@ nearMe", @"{distance} Near Me"), [self calculateDistanceToDescription]];

    
    [self.searchBar setPlaceholder:NSLocalizedString(@"networkSearchbar", nil)];
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
    

    
    NSPredicate* predicate;
    if (_searchBar.text.length)
    {
        predicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[c]%@ OR lastName CONTAINS[c]%@ OR status CONTAINS[c]%@ OR summary CONTAINS[c]%@ OR ANY experiences.descript CONTAINS[c]%@ OR ANY experiences.name CONTAINS[c]%@) AND itIsMe != YES AND distance < %f AND isBlocked == NO AND imdiscoverable > distance",_searchBar.text,_searchBar.text,_searchBar.text,_searchBar.text,_searchBar.text,_searchBar.text,_sliderDistanceValue];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"itIsMe != YES  AND distance < %f AND isBlocked == NO AND imdiscoverable > distance",_sliderDistanceValue];
    }

    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:50];
    
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


#pragma mark - Protocols and Delegates
//---------------------------------------------------------

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.table reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    NetworkCell *networkCell = [tableView dequeueReusableCellWithIdentifier:@"NetworkCell" forIndexPath:indexPath];
     Users *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
//    networkCell.selectionStyle = select
    
    [self configureCell:networkCell withObject:user];
              //If no experiences visible, show noContent header
    if ([[self fetchedResultsController].fetchedObjects count] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"Friend"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
           [self.UIPrinciple addNoContent:self setText:NSLocalizedString(@"nobodyNearYou", nil) setImage:contentImage setColor:self.UIPrinciple.netyGray setSecondColor:self.UIPrinciple.defaultGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    if ([user.isFriend isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        networkCell.networkUserImage.layer.borderWidth = 5;
        networkCell.networkUserImage.layer.borderColor = self.UIPrinciple.netyTheme.CGColor;
    } else {
        networkCell.networkUserImage.layer.borderWidth = 0;
    }
    
    return networkCell;
}

- (void)configureCell:(NetworkCell*)cell withObject:(Users*)object {
    //Setting cell data
    cell.networkUserImage.image = [UIImage imageNamed:kDefaultUserLogoName];
    
    //If image is not netyThemeLogo, start downloading and caching the image
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
        
    } else if ([statusString isEqualToString:@""] &&
               [summaryString isEqualToString:@""]){
        
        cell.networkUserName.text = @"";
        
        NSMutableAttributedString *nameAttributed = [[NSMutableAttributedString alloc] initWithString:fullName];
        
        [nameAttributed addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"HelveticaNeue" size:14.0]
                      range:NSMakeRange(0, fullName.length)];
        
        cell.networkUserDescription.attributedText = nameAttributed;
        
    }
    
    //DESIGN
    //Setting font color of cells to black
    cell.networkUserJob.textColor = [UIColor blackColor];
    cell.networkUserName.textColor = [UIColor blackColor];
    cell.networkUserDescription.textColor = [UIColor blackColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    Profile *profilePage = [profileStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
    profilePage.selectedUser = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    profilePage.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:profilePage animated:YES];
    
}



//Hide keyboard when search button pressed
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

#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)sliderAction:(id)sender {
    
    self.sliderValue = self.slider.value;
    
    [self calculateSliderDistanceValue];
    
    navItem.title = [NSString stringWithFormat:NSLocalizedString(@"%@ nearMe", @"{distance} Near Me"), [self calculateDistanceToDescription]];

}


#pragma mark - View Disappear
//---------------------------------------------------------


-(void)viewWillDisappear:(BOOL)animated {
        
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void) calculateSliderDistanceValue {
    
    if (self.sliderValue >= 0 && self.sliderValue <= 0.1) {
        self.sliderDistanceValue = 20;
    } else if (self.sliderValue > 0.10 && self.sliderValue <= 0.20) {
        self.sliderDistanceValue = 50;
    } else if (self.sliderValue > 0.20 && self.sliderValue <= 0.30) {
        self.sliderDistanceValue = 100;
    } else if (self.sliderValue > 0.30 && self.sliderValue <= 0.40) {
        self.sliderDistanceValue = 300;
    } else if (self.sliderValue > 0.40 && self.sliderValue <= 0.50) {
        self.sliderDistanceValue = 500;
    }  else if (self.sliderValue > 0.50 && self.sliderValue <= 0.60) {
        self.sliderDistanceValue = 1000;
    }  else if (self.sliderValue > 0.60 && self.sliderValue <= 0.70) {
        self.sliderDistanceValue = 1000 * 5;
    }  else if (self.sliderValue > 0.70 && self.sliderValue <= 0.80) {
        self.sliderDistanceValue = 1000 * 10;
    } else if (self.sliderValue > 0.80) {
        self.sliderDistanceValue = 1000 * 15;
    }
    
    _fetchedResultsController = nil;
    _fetchedResultsController.delegate = nil;
    [self.table reloadData];
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithFloat:_slider.value] forKey:@"sliderNetwork"];
    
}

- (NSString *) calculateDistanceToDescription {
    
    if (self.sliderDistanceValue >= 1000) {
        return [NSString stringWithFormat:@"%i KM", (int) self.sliderDistanceValue / 1000];
    } else {
        return [NSString stringWithFormat:@"%i Meters", (int) self.sliderDistanceValue];
    }
    
}

//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
