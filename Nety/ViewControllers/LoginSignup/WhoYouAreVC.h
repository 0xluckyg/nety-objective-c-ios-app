//
//  WhoYouAreVC.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/17/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// This sign up view controller gets the position and bio. Note, currently the bio cannot
// contain any line breaks as the line break functionality is replaced with a submit function.

#import "BaseSignUpViewController.h"
#import "SignUpTextField.h"
#import "SignUpTextView.h"

@interface WhoYouAreVC : BaseSignUpViewController

@property (weak, nonatomic) IBOutlet SignUpTextField *positionTextField;
@property (weak, nonatomic) IBOutlet SignUpTextView *bioTextView;
@property (weak, nonatomic) IBOutlet UILabel *whatDoYouDoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tellMeMoreAboutYouLabel;



@end
