//
//  Settings.h
//  Nety
//
//  Created by Scott Cho on 7/11/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <linkedin-sdk/LISDK.h>
#import "N_CoreDataTableViewController.h"
#import "ChangePassword.h"

@import Firebase;
@import FBSDKShareKit;

@interface Settings : UITableViewController


//VARIABLES----------------------------------------


@property (nonatomic) NSInteger userSecurityValue;

@property (nonatomic) float sliderValue;

@property (nonatomic) float sliderDistanceValue;


//UTIL CLASSES----------------------------------------


@property (strong,nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------



@property (weak, nonatomic) IBOutlet UISlider *locationRangeSlider;

@property (weak, nonatomic) IBOutlet UILabel *locationRangeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *discoverabilitySwitch;

@property (weak, nonatomic) IBOutlet UISwitch *chatRequestSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *chatSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;

@property (weak, nonatomic) IBOutlet UIImageView *linkedInImage;


@property (weak, nonatomic) IBOutlet UILabel *discoverableOutlet;

@property (weak, nonatomic) IBOutlet UILabel *chatRequestOutlet;

@property (weak, nonatomic) IBOutlet UILabel *chatOutlet;

@property (weak, nonatomic) IBOutlet UILabel *chatNotificationsOutlet;

@property (weak, nonatomic) IBOutlet UILabel *shareOnFacebookOutlet;

@property (weak, nonatomic) IBOutlet UILabel *shareOnLinkedInOutlet;

@property (weak, nonatomic) IBOutlet UILabel *logOutButtonOutlet;

@property (weak, nonatomic) IBOutlet UILabel *changePasswordOutlet;



//IBACTIONS----------------------------------------


- (IBAction)locationRangeSliderAction:(id)sender;

- (IBAction)notificationSwitchAction:(id)sender;

- (IBAction)discoverabilitySwitchAction:(id)sender;

- (IBAction)chatRequestSwitchAction:(id)sender;

- (IBAction)chatSwitchAction:(id)sender;


//-------------------------------------------------


@end
