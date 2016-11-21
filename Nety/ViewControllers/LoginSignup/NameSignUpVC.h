//
//  NameSignUpVC.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// This is the first sign up view controller. It only asks for name.

#import "BaseSignUpViewController.h"
#import "SignUpTextField.h"

@interface NameSignUpVC : BaseSignUpViewController
@property (weak, nonatomic) IBOutlet UILabel *whatIsYourNameLabel;
@property (weak, nonatomic) IBOutlet SignUpTextField *nameTextField;
// May or may not add after a design consultation
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
