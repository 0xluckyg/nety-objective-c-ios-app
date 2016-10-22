//
//  MyInfoEditExperience.h
//  Nety
//
//  Created by Scott Cho on 6/29/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "Experiences.h"


@protocol experienceDataDelegate <NSObject>

-(void) sendExperienceData: (NSMutableArray *)experienceData;

@end

@interface MyInfoEditExperience : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    UIDatePicker *datePicker;
    NSString *namePlacementText;
    NSString *dateToPlacementText;
    NSString *descriptionPlacementText;
    
    bool saved;
    bool changed;
}


//VARIABLES----------------------------------------


@property (nonatomic) bool add;

@property (nonatomic) NSUInteger arrayIndex;

@property (weak, nonatomic) id<experienceDataDelegate>delegate;

@property (strong, nonatomic) NSMutableArray *experienceArray;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


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





//IBACTIONS----------------------------------------


- (IBAction)presentButton:(id)sender;

- (IBAction)noDateButton:(id)sender;

- (IBAction)saveButton:(id)sender;


//-------------------------------------------------


@end
