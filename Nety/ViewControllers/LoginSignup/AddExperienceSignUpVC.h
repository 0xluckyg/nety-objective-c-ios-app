//
//  AddExperienceSignUpVC.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// Modal VC that allows user to add data to experience vc

#import "BaseSignUpViewController.h"

@protocol AddExperienceVCDelegate <NSObject>
- (void)addExperienceVCDismissedWithExperience: (NSDictionary *)experience;
@end

@interface AddExperienceSignUpVC : BaseSignUpViewController

@property (weak, nonatomic) id<AddExperienceVCDelegate>delegate;


@end
