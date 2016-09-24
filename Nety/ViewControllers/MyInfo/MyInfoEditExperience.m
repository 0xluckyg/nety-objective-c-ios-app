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


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initizlieSetting];
    [self initializeDesign];
}

-(void)viewWillAppear:(BOOL)animated {
    saved = false;
    changed = false;
}

#pragma mark - Initialization
//---------------------------------------------------------


- (void)initizlieSetting {
    
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
    
    //View color
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Name section
    self.experienceNameLabel.textColor = [UIColor whiteColor];
    self.experienceNameTextField.textColor = self.UIPrinciple.netyBlue;
    
    //Date section
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateToLabel.textColor = [UIColor whiteColor];
    self.dateFromTextField.textColor = self.UIPrinciple.netyBlue;
    self.dateToTextField.textColor = self.UIPrinciple.netyBlue;
    
    //Description section
    self.experienceDescriptionLabel.textColor = [UIColor whiteColor];
    self.experienceDescriptionTextField.layer.cornerRadius = 8;
    self.experienceDescriptionTextField.textColor = self.UIPrinciple.netyBlue;
    
    if (self.add == true) {
        
        //name
        self.experienceNameTextField.text = namePlacementText;
        //description
        self.experienceDescriptionTextField.text = descriptionPlacementText;
        
    } else {
        
        NSDictionary *experienceDict = [self.experienceArray objectAtIndex:self.arrayIndex];
        
        //name
        self.experienceNameTextField.text = [experienceDict objectForKey:kExperienceName];
        //date
        self.dateFromTextField.text = [experienceDict objectForKey:kExperienceStartDate];
        self.dateToTextField.text = [experienceDict objectForKey:kExperienceEndDate];
        //description
        self.experienceDescriptionTextField.text = [experienceDict objectForKey:kExperienceDescription];
        
    }
    
    //Nodate button
    [self.noDateButtonOutlet setTintColor:[UIColor whiteColor]];
    
    //Present button
    [self.presentButtonOutlet setTintColor:[UIColor whiteColor]];
    
    //Save button
    [self.saveButtonOutlet setTintColor:[UIColor whiteColor]];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = NSLocalizedString(@"myInfoEditExperience", nil);
    
    self.experienceNameLabel.text = NSLocalizedString(@"experienceNameLabel", nil);
    self.dateLabel.text = NSLocalizedString(@"dateLabel", nil);
    self.dateToLabel.text = NSLocalizedString(@"dateToLabel", nil);
    self.experienceDescriptionLabel.text =NSLocalizedString(@"experienceDescriptionLabel", nil);
    [self.saveButtonOutlet setTitle:NSLocalizedString(@"saveButton", nil) forState:UIControlStateNormal];
    
    namePlacementText = NSLocalizedString(@"experienceNamePlaceholder", nil);
    dateToPlacementText = NSLocalizedString(@"present", nil);
    descriptionPlacementText = NSLocalizedString(@"experienceDescriptionPlaceholder", nil);
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
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


-(void) backButtonPressed {
    
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


- (void)sendExperienceData {
    
    [self.delegate sendExperienceData:self.experienceArray];
    
    NSLog(@"experienceDelegate %@", self.experienceArray);
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



























