//
//  Settings.m
//  Nety
//
//  Created by Scott Cho on 7/11/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Settings.h"

@interface Settings ()<FBSDKSharingDelegate>

@end

@implementation Settings


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeSettings];
    [self initializeDesign];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"sliderNetwork"] == nil) {
        self.sliderValue = 0.3;
        self.locationRangeSlider.value = self.sliderValue;
    } else {
        self.sliderValue = [[userDef objectForKey:@"sliderNetwork"] floatValue];
        self.locationRangeSlider.value = self.sliderValue;
    }
    [self calculateSliderDistanceValue];
    NSString *distanceString = [self calculateDistanceToDescription];
    self.locationRangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ discoverable", @"{distance} discoverable"), distanceString];
  
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //DELETED DISCOVERABILITY SETTING
    //    [[[[[[FIRDatabase database] reference] child:kUsers] child:MY_USER.userID] child:kIAmDiscoverable] setValue:[NSString stringWithFormat:@"%f",self.sliderValue]];
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
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if ([userDef objectForKey:@"sliderNetwork"] == nil) {
        self.sliderValue = 0.3;
        self.locationRangeSlider.value = self.sliderValue;
    } else {
        self.sliderValue = [[userDef objectForKey:@"sliderNetwork"] floatValue];
        self.locationRangeSlider.value = self.sliderValue;
    }
    [self calculateSliderDistanceValue];
    NSString *distanceString = [self calculateDistanceToDescription];
    
    self.locationRangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ discoverable", @"{distance} discoverable"), distanceString];

}

-(void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style the navigation bar
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = NSLocalizedString(@"settings", nil);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
    [self.navigationController.navigationBar setBarTintColor:self.UIPrinciple.netyTheme];
    [self.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyTheme];
    
    self.facebookImage.image = [[UIImage imageNamed:@"Facebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.facebookImage.tintColor = self.UIPrinciple.facebookBlue;
    self.linkedInImage.image = [[UIImage imageNamed:@"LinkedIn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.linkedInImage.tintColor = self.UIPrinciple.linkedInBlue;
    
    self.locationRangeSlider.tintColor = self.UIPrinciple.netyTheme;
    [self.notificationSwitch setOnTintColor:self.UIPrinciple.netyTheme];
    [self.discoverabilitySwitch setOnTintColor:self.UIPrinciple.netyTheme];
    [self.chatRequestSwitch setOnTintColor:self.UIPrinciple.netyTheme];
    [self.chatSwitch setOnTintColor:self.UIPrinciple.netyTheme];

    //Set slider
//    self.locationRangeSlider.value = 1;
//    self.sliderValue = self.locationRangeSlider.value;
    [self calculateSliderDistanceValue];
    NSString *distanceString = [self calculateDistanceToDescription];
    
    self.locationRangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ discoverable", @"{distance} discoverable"), distanceString];
    self.chatRequestOutlet.text = NSLocalizedString(@"settingsChatRequest", nil);
    self.chatOutlet.text = NSLocalizedString(@"settingsChat", nil);
    self.chatNotificationsOutlet.text = NSLocalizedString(@"chatNotifications", nil);
    self.shareOnFacebookOutlet.text = NSLocalizedString(@"shareOnFacebook", nil);
    self.shareOnLinkedInOutlet.text = NSLocalizedString(@"shareOnLinkedIn", nil);
    self.logOutButtonOutlet.text = NSLocalizedString(@"logOut", nil);
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Set buttons for alert control
    UIAlertAction *yes = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [self changeRoot];
            [MY_API logOut];
        }
        
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            [self.UIPrinciple twoButtonAlert:yes rightButton:no controller:NSLocalizedString(@"logOut", nil) message:NSLocalizedString(@"logOutDescription", nil) viewController:self];
            
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0://Share on Facebook
            {
                //Share Photo
                FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
                photo.image = [UIImage imageNamed:@"Logo"];
                photo.userGenerated = YES;
                FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
                content.photos = @[photo];
                //OR
                //Share Photo
                FBSDKShareLinkContent *contentURL = [[FBSDKShareLinkContent alloc] init];
                contentURL.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
                
                FBSDKShareDialog* shareDialog = [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
                
                [shareDialog show];
                
            }
                break;
            case 1:
            {
                NSString *url = @"https://api.linkedin.com/v1/people/~/shares";
                
                NSString *payload = @"{\"comment\":\"Check out developer.linkedin.com! http://linkd.in/1FC2PyG\",\"visibility\":{ \"code\":\"anyone\" }}";
                
                if ([LISDKSessionManager hasValidSession]) {
                    [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
                                                         success:^(LISDKAPIResponse *response) {
                                                             // do something with response
                                                         }
                                                           error:^(LISDKAPIError *apiError) {
                                                               // do something with error
                                                               NSLog(@"Error: %@",apiError.localizedDescription);
                                                           }];
                }
                else
                {
                    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION,LISDK_W_SHARE_PERMISSION, nil]
                                                         state:@"some state"
                                        showGoToAppStoreDialog:YES
                                                  successBlock:^(NSString *returnState) {
                                                      
                                                      [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
                                                                                           success:^(LISDKAPIResponse *response) {
                                                                                               // do something with response
                                                                                           }
                                                                                             error:^(LISDKAPIError *apiError) {
                                                                                                 // do something with error
                                                                                                 NSLog(@"Error: %@",apiError.localizedDescription);
                                                                                             }];
                                                      
                                                  }
                                                    errorBlock:^(NSError *error) {
                                                        NSLog(@"%s %@","error called! ", [error description]);
                                                        
                                                    }
                     ];
                }
            }
                break;
                
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}
#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)locationRangeSliderAction:(id)sender {
    
    self.sliderValue = self.locationRangeSlider.value;
    [self calculateSliderDistanceValue];
    NSString *distanceString = [self calculateDistanceToDescription];
    
    self.locationRangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ discoverable", @"{distance} discoverable"), distanceString];
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

//DELETED FOR VERSION 1 
//- (IBAction)chatRequestSwitchAction:(id)sender {
//    NSString *userID = MY_USER.userID;
//
//    if (self.chatRequestSwitch.isOn == true) {
//        [self.discoverabilitySwitch setOn:YES animated:YES];
//        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@1];
//    } else {
//        [self.chatSwitch setOn:NO animated:YES];
//        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@2];
//    }
//}

- (IBAction)chatSwitchAction:(id)sender {
    NSString *userID = MY_USER.userID;
    
    if (self.chatSwitch.isOn == true) {
        [self.chatRequestSwitch setOn:YES animated:YES];
        [self.discoverabilitySwitch setOn:YES animated:YES];
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@0];
    } else {
        [[[[self.firdatabase child:kUsers] child:userID] child:kSecurity] setValue:@2];
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
     completion:^(BOOL finished) {
         appDelegate.tabBarRootController=nil;
     }];
    
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
        self.sliderDistanceValue = 5280 * 7;
    } else if (self.sliderValue > 0.80) {
        self.sliderDistanceValue = 5280 * 10;
    }
      
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithFloat:_locationRangeSlider.value] forKey:@"sliderNetwork"];
    
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
