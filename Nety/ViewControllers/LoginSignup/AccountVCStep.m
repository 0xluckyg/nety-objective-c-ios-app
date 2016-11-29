//
//  AccountVCStep.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"
#import "Regex.h"

@implementation AccountVCStep

- (instancetype)initWithViewController: (AccountSignUpVC *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (BOOL)emailIsValid {
    NSTextCheckingResult *isValidEmail = [Regex validateEmail:self.viewController.emailTextField.text];
    if (isValidEmail) {
        if ([self emailIsUnique]) {
            return YES;
        }
        self.viewController.whatIsYourEmailLabel.text = @"E-mail is already registered!";
    } else {
        self.viewController.whatIsYourEmailLabel.text = @"Email has an error";
    }
    return NO;
}

- (BOOL)emailIsUnique {
    
    NSString *userID = [[self.viewController.emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    self.firdatabase = [[FIRDatabase database] reference];

    
    [[self.firdatabase child:kUsers] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot hasChild:userID]) {
            NSLog(@"ALREADY EXISTS");
        } else {
            NSLog(@"IS NEW");
        }
    }];
    return NO;
}

- (BOOL)emailConfirmationIsValid {
    NSString *email = [self.viewController.emailTextField.text lowercaseString];
    NSString *emailConfirmation = [self.viewController.emailConfirmationTextField.text lowercaseString];
    if ([email isEqualToString:emailConfirmation] ) {
        return YES;
    }
    
    self.viewController.whatIsYourEmailLabel.text = @"Confirmation does not match";
    return NO;
}

- (BOOL)passwordIsValid {
    NSString *password = self.viewController.passwordTextField.text;
    NSTextCheckingResult *isValidPassword = [Regex validatePassword:password];
    if (isValidPassword) {
        return YES;
    }
    
    if (password.length < 6) {
        self.viewController.createAPasswordLabel.text = @"Password must be at least 6 chars";
    }
    if (password.length > 15) {
        self.viewController.createAPasswordLabel.text = @"Password must be at most 15 chars";
    }
    if (password.length > 15) {
        self.viewController.createAPasswordLabel.text = @"Password can only have letters and numbers";
    }
    
    return NO;
}

- (BOOL)passwordConfirmationIsValid {
    if ([self.viewController.passwordTextField.text isEqualToString:self.viewController.passwordConfirmationTextField.text]) {
        return YES;
    }
    
    self.viewController.createAPasswordLabel.text = @"Confirmation does not match";
    return NO;
}

@end
