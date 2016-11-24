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
@property (weak, nonatomic) IBOutlet UILabel *howOldAreYouLabel;
@property (weak, nonatomic) IBOutlet SignUpTextField *ageTextField;

@end

@implementation NameSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.ageTextField.delegate = self;
    self.stepNumber = 1;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:true];
    self.fields = @[self.nameTextField];
}


- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    if ([textField.titlePlaceholder isEqualToString:@"Name"]) {
        NSTextCheckingResult *isValidName = [Regex validateName:textField.text];
        
        if (isValidName) {
            self.userData.name = [textField.text capitalizedString];
        } else {
            self.whatIsYourNameLabel.text = @"Full name please";
        }
    }
    
    if ([textField.titlePlaceholder isEqualToString:@"Age"]) {
        NSTextCheckingResult *isValidName = [Regex validateName:textField.text];
        NSUInteger age = (NSUInteger)textField.text;
        BOOL isValidAge = age > 12 && age < 85;
        if (isValidAge) {
            self.userData.age = age;
            if (isValidName) {
                [textField resignFirstResponder];
                [self performSegueWithIdentifier:@"ToAccountSegue" sender:self];
            } else {
                self.whatIsYourNameLabel.text = @"Invalid: Full name please";
            }
        } else {
            self.howOldAreYouLabel.text = @"Not a valid age";
        }
    }
    return YES;
}

-(BOOL)allFieldsAreValidated {
    NSTextCheckingResult *isValidName = [Regex validateName:self.nameTextField.text];

    if (isValidName) {
        return YES;
    }
    return NO;
}

-(void)goToNextPage {
    NSLog(@"Go to next page");
}

@end
