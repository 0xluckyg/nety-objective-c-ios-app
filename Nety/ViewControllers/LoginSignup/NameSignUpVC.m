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

-(void)viewDidAppear:(BOOL)animated {
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
        } else {
            self.whatIsYourNameLabel.text = @"Full name please";
        }
    }
    
    if ([textField.titlePlaceholder isEqualToString:@"Age"]) {
        
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

- (IBAction)nextButtonTapped:(UIButton *)sender {
    NSTextCheckingResult *isValidName = [Regex validateName:self.nameTextField.text];
    NSUInteger age = [self.ageTextField.text integerValue];
    NSLog(@"%li", age);
    BOOL isValidAge = age > 12 && age < 85;
    if (isValidAge) {
        self.userData.age = age;
        if (isValidName) {
            [self performSegueWithIdentifier:@"ToAccountSegue" sender:self];
        } else {
            self.whatIsYourNameLabel.text = @"Invalid: Full name please";
        }
    } else {
        self.howOldAreYouLabel.text = @"Not a valid age";
    }
}

@end
