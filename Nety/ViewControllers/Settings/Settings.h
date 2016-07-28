//
//  Settings.h
//  Nety
//
//  Created by Scott Cho on 7/11/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@import Firebase;

@interface Settings : UITableViewController


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong,nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *locationRangeSlider;

@property (weak, nonatomic) IBOutlet UILabel *locationRangeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;

@property (weak, nonatomic) IBOutlet UIImageView *linkedInImage;


//IBACTIONS----------------------------------------


- (IBAction)locationRangeSliderAction:(id)sender;

- (IBAction)notificationSwitchAction:(id)sender;


//-------------------------------------------------


@end
