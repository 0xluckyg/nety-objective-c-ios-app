//
//  SignupProcessExperienceDetail.m
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcessExperienceDetail.h"

@interface SignupProcessExperienceDetail ()

@end

@implementation SignupProcessExperienceDetail


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initizlieSettings];
//    [self initializeDesign];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initizlieSettings {
    
    saved = false;
    changed = false;
    
    //This is for name section
    self.experienceNameTextField.tag = 0;
    
    //Set keyboard as datepicker when date section is tapped
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.dateFromTextField setInputView:datePicker];
    [self.dateToTextField setInputView:datePicker];
    
    //Set tags for date sections to identify which one's which
    self.dateFromTextField.tag = 1;
    self.dateToTextField.tag = 2;
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//Clear description box if the text is default
- (BOOL)textViewShouldBeginEditing:(UITextField *)textView {
    if ([textView.text isEqual: descriptionPlacementText]) {
        textView.attributedText = nil;
    } else if ([textView.text isEqual: dateToPlacementText]) {
        textView.attributedText = nil;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    changed = true;
    
    if ([textField.text isEqual: namePlacementText]) {
        textField.attributedText = nil;
    }
    return YES;
}

//When text field (Not text view) ends editing
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    //For date section
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    
    if (textField.tag == 1) {
        self.dateFromTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
    } else if (textField.tag == 2) {
        self.dateToTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
    }
}

//Move screen up when Keyboard appears for Description only
-(void)textViewDidBeginEditing:(UITextView *)textView {
    changed = true;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

//Move screen down when Keyboard appears for Description only
-(void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)noDateButton:(id)sender {
    //Reset date
    self.dateFromTextField.text = @"";
    self.dateToTextField.text = @"";
}

//Set date to present
- (IBAction)presentButton:(id)sender {
    self.dateToTextField.text = dateToPlacementText;
}

//Going back to experience table view
- (IBAction)backButton:(id)sender {
    
    if (saved == false && changed == true) {
        
        
        UIAlertAction *cont = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [self.UIPrinciple twoButtonAlert:cont rightButton:okay controller:@"Not saved" message:@"You haven't saved your interest or experience. Continue anyway?" viewController:self];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//Saving and going back to experience table view
- (IBAction)saveButton:(id)sender {
    
    saved = true;
    
    NSString *experienceDescription = [[NSString alloc] init];
    
    if (self.experienceDescriptionTextField.text == descriptionPlacementText) {
        experienceDescription = @"";
        
    } else {
        experienceDescription = self.experienceDescriptionTextField.text;
    }
    
    NSDictionary *experienceDict = @{
                                     kExperienceName: self.experienceNameTextField.text,
                                     kExperienceStartDate: self.dateFromTextField.text,
                                     kExperienceEndDate: self.dateToTextField.text,
                                     kExperienceDescription: experienceDescription
                                     };
    
    //If adding, then put it in the array.
    if (self.add == true && changed == true) {
        
        [self.experienceArray addObject:experienceDict];
        [self sendExperienceData];
        
        //If editing, then simply change object
    } else {
        
        [self.experienceArray replaceObjectAtIndex:self.arrayIndex withObject:experienceDict];
        [self sendExperienceData];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------


- (void)sendExperienceData {
    
    [self.delegate sendExperienceData:self.experienceArray];
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



























