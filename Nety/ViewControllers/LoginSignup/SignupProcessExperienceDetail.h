//
//  SignupProcessExperienceDetail.h
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@protocol experienceDataDelegate <NSObject>

-(void) sendExperienceData: (NSMutableArray *)experienceData;

@end


@interface SignupProcessExperienceDetail : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    UIDatePicker *datePicker;
    NSString *namePlacementText;
    NSString *dateToPlacementText;
    NSString *descriptionPlacementText;
    
    bool saved;
    bool changed;
}


@property (weak, nonatomic) IBOutlet UITextField *experienceNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *experienceNameLabel;



@property (weak, nonatomic) IBOutlet UITextField *dateFromTextField;

@property (weak, nonatomic) IBOutlet UITextField *dateToTextField;


@property (weak, nonatomic) IBOutlet UILabel *dateToLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



@property (weak, nonatomic) IBOutlet UITextView *experienceDescriptionTextField;

@property (weak, nonatomic) IBOutlet UILabel *experienceDescriptionLabel;



@property (weak, nonatomic) IBOutlet UIButton *noDateButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *presentButtonOutlet;

@property (weak, nonatomic) id<experienceDataDelegate>delegate;

@property (strong, nonatomic) NSMutableArray *experienceArray;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;



@property (nonatomic) bool add;
@property (nonatomic) NSUInteger arrayIndex;

- (IBAction)presentButton:(id)sender;

- (IBAction)noDateButton:(id)sender;

- (IBAction)backButton:(id)sender;

- (IBAction)saveButton:(id)sender;

@end
