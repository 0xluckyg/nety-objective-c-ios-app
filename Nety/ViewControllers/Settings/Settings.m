//
//  Settings.m
//  Nety
//
//  Created by Scott Cho on 7/11/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Settings.h"
#import "AppDelegate.h"

@interface Settings ()

@end

@implementation Settings


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDesign];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Initialization
//---------------------------------------------------------


-(void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style the navigation bar
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = @"Settings";
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
    [self.navigationController.navigationBar setBarTintColor:self.UIPrinciple.netyBlue];
    [self.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    
    self.facebookImage.image = [[UIImage imageNamed:@"Facebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.facebookImage.tintColor = self.UIPrinciple.facebookBlue;
    self.linkedInImage.image = [[UIImage imageNamed:@"LinkedIn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.linkedInImage.tintColor = self.UIPrinciple.linkedInBlue;
    
    self.locationRangeSlider.tintColor = self.UIPrinciple.netyBlue;
    [self.notificationSwitch setOnTintColor:self.UIPrinciple.netyBlue];
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Set buttons for alert control
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [self changeRoot];
        }
        
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            [self.UIPrinciple twoButtonAlert:yes rightButton:no controller:@"Log out" message:@"Are you sure to log out?" viewController:self];
            
        } else {
            
            [self.UIPrinciple twoButtonAlert:yes rightButton:no controller:@"Delete account" message:@"Are you sure to delete your account? All the friends you've made will miss you." viewController:self];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)locationRangeSliderAction:(id)sender {
}

- (IBAction)notificationSwitchAction:(id)sender {
}


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------


-(void)changeRoot {
    
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //Set login storyboard
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
    UIViewController *myNetworkViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"MainPageNav"];
    //With transition
    [UIView
     transitionWithView:self.view.window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         [appDelegate.window setRootViewController:myNetworkViewController];
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
