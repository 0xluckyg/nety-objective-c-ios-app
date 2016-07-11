//
//  Profile.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface Profile : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIView *basicInfoView;

@property (weak, nonatomic) IBOutlet UILabel *statusInfo;

@property (weak, nonatomic) IBOutlet UILabel *summaryInfo;

@property (weak, nonatomic) IBOutlet UILabel *experienceInfo;

@property (weak, nonatomic) IBOutlet UIButton *chatNowButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *bottomChatNowButtonOutlet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewTopConstraint;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

- (IBAction)backButton:(id)sender;

- (IBAction)chatNowButton:(id)sender;



@end
