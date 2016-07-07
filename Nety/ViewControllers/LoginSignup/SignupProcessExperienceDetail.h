//
//  SignupProcessExperienceDetail.h
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface SignupProcessExperienceDetail : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    UIDatePicker *datePicker;
    NSString *namePlacementText;
    NSString *dateToPlacementText;
    NSString *descriptionPlacementText;
}


@property (weak, nonatomic) IBOutlet UITextField *experienceNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *experienceNameLabel;



@property (weak, nonatomic) IBOutlet UITextField *dateFromTextField;

@property (weak, nonatomic) IBOutlet UITextField *dateToTextField;


@property (weak, nonatomic) IBOutlet UILabel *dateToLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



@property (weak, nonatomic) IBOutlet UITextView *experienceDescriptionTextField;

@property (weak, nonatomic) IBOutlet UILabel *experienceDescriptionLabel;




@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *presentButtonOutlet;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

- (IBAction)presentButton:(id)sender;

- (IBAction)backButton:(id)sender;

- (IBAction)saveButton:(id)sender;

@end
