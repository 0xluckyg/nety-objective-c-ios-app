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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDesign];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Set buttons for alert control
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
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
        
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Log out"
                                        message:@"Are you sure to log out?"
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:yes];
            [alert addAction:no];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Delete account"
                                        message:@"Are you sure to delete your account? All the friends you've made will miss you."
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:yes];
            [alert addAction:no];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationRangeSliderAction:(id)sender {
}

- (IBAction)notificationSwitchAction:(id)sender {
}
@end
