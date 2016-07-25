//
//  MyInfoEditType2.h
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface MyInfoEditType2 : UIViewController <UITextViewDelegate> {
    NSString *editType2PlacementText;
}


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UILabel *editType2Label;

@property (weak, nonatomic) IBOutlet UITextView *editType2TextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;


//IBACTIONS----------------------------------------


- (IBAction)backButton:(id)sender;

- (IBAction)saveButton:(id)sender;


//-------------------------------------------------


@end
