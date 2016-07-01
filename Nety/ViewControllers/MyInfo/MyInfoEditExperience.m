//
//  MyInfoEditExperience.m
//  Nety
//
//  Created by Scott Cho on 6/29/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditExperience.h"

@interface MyInfoEditExperience ()

@end

@implementation MyInfoEditExperience

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeDesign];
    [self initizlieSetting];
}

- (void)initizlieSetting {
    
    namePlacementText = @"Where did you work at, or what did you do?";
    dateToPlacementText = @"Present";
    descriptionPlacementText = @"How was the experience?";
    
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

- (void)initializeDesign {
    //UIPrinciple allocation
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Topbar and navbar colors
    self.topBar.backgroundColor = self.UIPrinciple.netyBlue;
    self.navBar.backgroundColor = self.UIPrinciple.netyBlue;
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
    //View color
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Name section
    self.experienceNameLabel.textColor = [UIColor whiteColor];
    self.experienceNameTextField.textColor = self.UIPrinciple.netyBlue;
    self.experienceNameTextField.text = namePlacementText;
    
    //Date section
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateToLabel.textColor = [UIColor whiteColor];
    self.dateFromTextField.textColor = self.UIPrinciple.netyBlue;
    self.dateToTextField.textColor = self.UIPrinciple.netyBlue;
    self.dateToTextField.text = dateToPlacementText;
    
    //Description section
    self.experienceDescriptionLabel.textColor = [UIColor whiteColor];
    self.experienceDescriptionTextField.layer.cornerRadius = 8;
    self.experienceDescriptionTextField.text = descriptionPlacementText;
    self.experienceDescriptionTextField.textColor = self.UIPrinciple.netyBlue;
    
    //Save button
    [self.saveButtonOutlet setTintColor:[UIColor whiteColor]];
    
    
}

//Clear description box if the text is default
- (BOOL)textViewShouldBeginEditing:(UITextField *)textView
{
    if ([textView.text isEqual: descriptionPlacementText]) {
        textView.attributedText = nil;
    } else if ([textView.text isEqual: dateToPlacementText]) {
        textView.attributedText = nil;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

//Move screen down when Keyboard appears for Description only
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//Going back to experience table view
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//Saving and going back to experience table view
- (IBAction)saveButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



























