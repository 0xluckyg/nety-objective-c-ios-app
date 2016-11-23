//
//  NameSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "NameSignUpVC.h"
#import <QuartzCore/QuartzCore.h>
#import "SignUpTextField.h"
#import "Regex.h"

@interface NameSignUpVC ()

@end

@implementation NameSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.stepNumber = 1;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:true];

    self.fields = @[self.nameTextField];
}


- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    
    if ([textField.titlePlaceholder isEqualToString:@"Name"]) {
        NSTextCheckingResult *isValidName = [Regex validateName:textField.text];
        
        if (isValidName) {
            [textField resignFirstResponder];
            self.userData.name = [textField.text capitalizedString];
            [self performSegueWithIdentifier:@"ToAccountSegue" sender:self];
        } else {
            self.whatIsYourNameLabel.text = @"Full name please";
        }
    }
    return YES;
}


@end
