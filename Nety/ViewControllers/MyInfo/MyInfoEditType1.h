//
//  MyInfoEditType1.h
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "Constants.h"

@import Firebase;

@interface MyInfoEditType1 : UIViewController <UITextFieldDelegate> {
    NSString *editType1NamePlacementText;
    NSString *editType1JobPlacementText;
    bool changed;
}


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UILabel *editType1NameLabel;

@property (weak, nonatomic) IBOutlet UITextField *editType1NameTextField;

@property (weak, nonatomic) IBOutlet UILabel *editType1JobLabel;

@property (weak, nonatomic) IBOutlet UITextField *editType1JobTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;


//IBACTIONS----------------------------------------


- (IBAction)saveButton:(id)sender;


//-------------------------------------------------


@end
