//
//  SignupProcess1.h
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface SignupProcess1 : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    NSString *summaryPlaceholder;
}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *userInfo;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UILabel *process1title;

@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (weak, nonatomic) IBOutlet UITextField *jobTextField;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UITextView *summaryTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;


//IBACTIONS----------------------------------------


- (IBAction)backButton:(id)sender;

- (IBAction)nextButton:(id)sender;

- (IBAction)laterButton:(id)sender;


//-------------------------------------------------


@end
