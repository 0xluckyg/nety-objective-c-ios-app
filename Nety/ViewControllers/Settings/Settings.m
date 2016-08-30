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
    
    [self initializeSettings];
    [self initializeDesign];
}


#pragma mark - Initialization
//---------------------------------------------------------

-(void)initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];
    [self listenForSecurityStatus];
    
    switch (self.userSecurityValue) {
        case (0):
            [self.discoverabilitySwitch setOn:YES];
            [self.chatRequestSwitch setOn:YES];
            [self.chatSwitch setOn:YES];
            break;
        case (1):
            [self.discoverabilitySwitch setOn:YES];
            [self.chatRequestSwitch setOn:YES];
            [self.chatSwitch setOn:NO];
            break;
        case (2):
            [self.discoverabilitySwitch setOn:YES];
            [self.chatRequestSwitch setOn:NO];
            [self.chatSwitch setOn:NO];
            break;
        case (3):
            [self.discoverabilitySwitch setOn:NO];
            [self.chatRequestSwitch setOn:NO];
            [self.chatSwitch setOn:NO];
            break;
    }
    
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
    [self.discoverabilitySwitch setOnTintColor:self.UIPrinciple.netyBlue];
    [self.chatRequestSwitch setOnTintColor:self.UIPrinciple.netyBlue];
    [self.chatSwitch setOnTintColor:self.UIPrinciple.netyBlue];

    //Set slider
    self.sliderValue = self.locationRangeSlider.value;
    [self calculateSliderDistanceValue];
    NSString *distanceString = [self calculateDistanceToDescription];
    
    self.locationRangeLabel.text = [NSString stringWithFormat:@"I am discoverable within %@", distanceString];}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Set buttons for alert control
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [self changeRoot];
            [MY_API logOut];
        }
        
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            [self.UIPrinciple twoButtonAlert:yes rightButton:no controller:@"Log out" message:@"Are you sure to log out?" viewController:self];
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)locationRangeSliderAction:(id)sender {
    
    self.sliderValue = self.locationRangeSlider.value;
    [self calculateSliderDistanceValue];
    NSString *distanceString = [self calculateDistanceToDescription];
    
    self.locationRangeLabel.text = [NSString stringWithFormat:@"I am discoverable within %@", distanceString];
}

- (IBAction)notificationSwitchAction:(id)sender {
    
}

//Security:
//0: Discoverable, chat requestable, chattable
//1: Discoverable, chat requestable
//2: Discoverable
//3: Not discoverable

- (IBAction)discoverabilitySwitchAction:(id)sender {
    NSString *userID = MY_USER.userID;
    
    if (self.discoverabilitySwitch.isOn == true) {
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@2];
    } else {
        [self.chatRequestSwitch setOn:NO animated:YES];
        [self.chatSwitch setOn:NO animated:YES];
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@3];
    }
}

- (IBAction)chatRequestSwitchAction:(id)sender {
    NSString *userID = MY_USER.userID;

    if (self.chatRequestSwitch.isOn == true) {
        [self.discoverabilitySwitch setOn:YES animated:YES];
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@1];
    } else {
        [self.chatSwitch setOn:NO animated:YES];
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@2];
    }
}

- (IBAction)chatSwitchAction:(id)sender {
    NSString *userID = MY_USER.userID;
    
    if (self.chatSwitch.isOn == true) {
        [self.chatRequestSwitch setOn:YES animated:YES];
        [self.discoverabilitySwitch setOn:YES animated:YES];
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@0];
    } else {
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@1];
    }
}


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------

-(void)changeRoot {
    
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
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

- (void)listenForSecurityStatus {

    [[[[self.firdatabase child:kUsers] child:MY_USER.userID] child:kSecurity] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if (snapshot != nil) {
            self.userSecurityValue = (NSInteger)snapshot.value;
        } else {
            self.userSecurityValue = 0;
        }
    }];
    
}

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
