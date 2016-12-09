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
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation NameSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.ageTextField.delegate = self;
    self.stepNumber = 1;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:true];
    self.fields = @[self.nameTextField, self.ageTextField];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.userData.name) {
        self.nameTextField.text = self.userData.name;
    }
    
    if (self.userData.age > 0) {
        self.ageTextField.text = [NSString stringWithFormat:@"%lu" ,self.userData.age];
    }
}


- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    if ([textField.titlePlaceholder isEqualToString:@"Name"]) {
        NSTextCheckingResult *isValidName = [Regex validateName:textField.text];
        
        if (isValidName) {
            self.userData.name = [textField.text capitalizedString];
            [self.ageTextField becomeFirstResponder];
        } else {
            self.whatIsYourNameLabel.text = @"Full name please";
        }
    }
    
    if ([textField.titlePlaceholder isEqualToString:@"Age"]) {
        [self goToNextPage];
    }
    return YES;
}

-(BOOL)allFieldsAreValidated: (BOOL)display {
    return [self nameIsValid:display] && [self ageIsValid:display];
}


-(void)goToNextPage {
    self.userData.name = self.nameTextField.text;
    self.userData.age = [self.ageTextField.text integerValue];
    [self performSegueWithIdentifier:@"ToAccountSegue" sender:self];
}

- (IBAction)nextButtonTapped:(UIButton *)sender {
    if ([self allFieldsAreValidated:YES]) {
        [self goToNextPage];
    }
}

-(void)viewWasTapped {
    [super viewWasTapped];
    if ([self allFieldsAreValidated: NO]) {
        [self goToNextPage];
    } else if ([self nameIsValid:NO]) {
        [self.ageTextField becomeFirstResponder];
    } else {
        [self.nameTextField becomeFirstResponder];
    }
}

-(BOOL)nameIsValid: (BOOL)display {
    NSTextCheckingResult *isValidName = [Regex validateName:self.nameTextField.text];
    
    if (isValidName) {
        return YES;
    }
    if (display) { self.whatIsYourNameLabel.text = @"Full name please"; }
    return NO;
}

-(BOOL)ageIsValid: (BOOL)display {
    NSLog(@"age is valid %@", self.ageTextField.text);
    if (![Regex validateAge:self.ageTextField.text]) {
        NSLog(@"failed regex");
        if (display) { self.howOldAreYouLabel.text = @"Only numbers please!"; }
        return NO;
    }
    
    NSUInteger age = [self.ageTextField.text integerValue];
    
    if (age < 15) {
        NSLog(@"Failed age low");
        if (display) { self.howOldAreYouLabel.text = @"Must be at least 15 years old"; }
        return NO;
    }
    if (age > 85) {
        NSLog(@"Failed age high");
        if (display) { self.howOldAreYouLabel.text = @"Must be younger than 85"; }
        return NO;
    }
    
    NSLog(@"Age pasesd");
    return YES;
}

@end
