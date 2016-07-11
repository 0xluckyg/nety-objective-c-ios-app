//
//  Settings.h
//  Nety
//
//  Created by Scott Cho on 7/11/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface Settings : UITableViewController

@property (strong,nonatomic) UIPrinciples *UIPrinciple;

@property (weak, nonatomic) IBOutlet UIView *locationRangeSlider;

@property (weak, nonatomic) IBOutlet UILabel *locationRangeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;

@property (weak, nonatomic) IBOutlet UIImageView *linkedInImage;


- (IBAction)locationRangeSliderAction:(id)sender;

- (IBAction)notificationSwitchAction:(id)sender;



@end
