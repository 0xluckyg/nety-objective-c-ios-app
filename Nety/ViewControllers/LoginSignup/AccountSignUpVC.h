//
//  AccountSignUpVC.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// This is the second sign up view controller that asks for e-mail and password (as well as confirmations)

#import "BaseSignUpViewController.h"
#import "SignUpTextField.h"

@interface AccountSignUpVC : BaseSignUpViewController
@property (weak, nonatomic) IBOutlet UILabel *whatIsYourEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *createAPasswordLabel;
@property (weak, nonatomic) IBOutlet SignUpTextField *emailTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *emailConfirmationTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *passwordConfirmationTextField;

@end
