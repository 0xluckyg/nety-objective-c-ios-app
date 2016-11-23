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
@property (strong, nonatomic) UIDatePicker *datePicker;
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
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.startTextField setInputView:self.datePicker];
    [self.endTextField setInputView:self.datePicker];
    
//    self.dateFromTextField.tag = 1;
//    self.dateToTextField.tag = 2;
    
    self.fields = @[self.positionTextField, self.startTextField, self.endTextField, self.detailsTextView];

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
