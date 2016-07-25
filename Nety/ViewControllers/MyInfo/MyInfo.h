//
//  MyInfo.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "SignupProcess3.h"
#import "Constants.h"
#import "UserInformation.h"
#import "MyInfoEditTable.h"

@import Firebase;

@interface MyInfo : UIViewController


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableDictionary *userData;

@property (strong, nonatomic) NSMutableArray *experienceArray;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UserInformation *userInformation;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;

@property (weak, nonatomic) IBOutlet UIView *userBasicInfoView;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;

@property (weak, nonatomic) IBOutlet UILabel *userStatusInfo;

@property (weak, nonatomic) IBOutlet UILabel *userSummaryInfo;

@property (weak, nonatomic) IBOutlet UILabel *userExperienceInfo;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *identityLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoViewTopConstraint;


//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
