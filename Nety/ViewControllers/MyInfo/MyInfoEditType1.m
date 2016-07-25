//
//  MyInfoEditType1.m
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditType1.h"

@interface MyInfoEditType1 ()

@end

@implementation MyInfoEditType1


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    editType1NamePlacementText = [UserInformation getName];
    editType1JobPlacementText = [UserInformation getIdentity];
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background of page
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Name Label
    
    self.editType1NameLabel.text = @"Name";
    self.editType1NameLabel.textColor = [UIColor whiteColor];
    
    //Name textfield
    self.editType1NameTextField.text = editType1NamePlacementText;
    self.editType1NameTextField.textColor = self.UIPrinciple.netyBlue;
    
    //Job Label
    self.editType1JobLabel.text = @"I am";
    self.editType1JobLabel.textColor = [UIColor whiteColor];
    
    //Job textfield
    self.editType1JobTextField.text = editType1JobPlacementText;
    self.editType1JobTextField.textColor = self.UIPrinciple.netyBlue;
    
    //save button
    [self.saveButtonOutlet setTintColor:[UIColor whiteColor]];
    
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//Move screen up a bit when Keyboard appears for Description only
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -50., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

//Move screen down a bit when Keyboard appears for Description only
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +50., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


#pragma mark - Buttons
//---------------------------------------------------------


//Go back
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//Save and go back
- (IBAction)saveButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void)viewWillDisappear:(BOOL)animated {
    
}


#pragma mark - Custom methods
//---------------------------------------------------------






//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



























