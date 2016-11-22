//
//  AddExperienceSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "AddExperienceSignUpVC.h"
#import "SignUpTextView.h"
#import "SignUpTextField.h"
#import "Regex.h"

@interface AddExperienceSignUpVC ()
@property (weak, nonatomic) IBOutlet UILabel *whatDidYouDoLabel;
@property (weak, nonatomic) IBOutlet UILabel *whenDidYouDoItLabel;
@property (weak, nonatomic) IBOutlet UILabel *tellMeMoreLabel;
@property (weak, nonatomic) IBOutlet SignUpTextField *positionTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *startTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *endTextField;
@property (weak, nonatomic) IBOutlet SignUpTextView *detailsTextView;

@end

@implementation AddExperienceSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 4;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.imageView.image = [UIImage imageNamed:@"MainPicture2"];
    
    self.positionTextField.delegate = self;
    self.startTextField.delegate = self;
    self.endTextField.delegate = self;
    self.detailsTextView.delegate = self;
    
    // Hides keyboard when view is tapped
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
    [self.view addGestureRecognizer:tapGesture];
}

- (IBAction)skipButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    
    if ([textField.titlePlaceholder isEqualToString:@"Position"]) {
        // Add validations here
        if (true) {
            self.whatDidYouDoLabel.text = @"Nice!";
            [self.startTextField becomeFirstResponder];
        }
    }
    
    return YES;
}

- (void)viewWasTapped {
    NSArray *fields = @[self.positionTextField, self.startTextField, self.endTextField, self.detailsTextView];
    for (UIView *field in fields) {
        [field resignFirstResponder];
    }
}


- (IBAction)addButtonTapped:(UIButton *)sender {
    NSDictionary *experienceDict = @{
                                     kExperienceName: self.positionTextField.text,
                                     kExperienceStartDate: self.startTextField.text,
                                     kExperienceEndDate: self.endTextField.text,
                                     kExperienceDescription: self.detailsTextView.text
                                     };
    [self.delegate addExperienceVCDismissedWithExperience:experienceDict];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
