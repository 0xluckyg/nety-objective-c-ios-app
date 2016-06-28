//
//  MyInfo.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface MyInfo : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;

@property (weak, nonatomic) IBOutlet UIView *userBasicInfoView;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;

@property (weak, nonatomic) IBOutlet UILabel *userStatusInfo;

@property (weak, nonatomic) IBOutlet UILabel *userSummaryInfo;

@property (weak, nonatomic) IBOutlet UILabel *userExperienceInfo;


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@end
