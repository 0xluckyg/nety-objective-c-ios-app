//
//  MyInfoEditType2.m
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditType2.h"

@interface MyInfoEditType2 ()

@end

@implementation MyInfoEditType2


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initializeSettings];
    [self initializeDesign];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    changed = false;
    
    //initialize textfield description placeholder
    if (self.statusOrSummary == 0) {
        if (![MY_USER.status isEqualToString:@""]) {
            editType2PlacementText = MY_USER.status;
        } else {
            editType2PlacementText = @"Write a status for everyone to see!";
        }
    } else {
        if (![MY_USER.summary isEqualToString:@""]) {
            editType2PlacementText = MY_USER.summary;
        } else {
            editType2PlacementText = @"Write a summary about yourself!";
        }
    }
    
    
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background of page
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Label
    if (self.statusOrSummary == 0) {
        self.editType2Label.text = @"Status";
        self.topLabel.text = @"Set Status";
    } else {
        self.editType2Label.text = @"Summary";
        self.topLabel.text = @"Set Summary";
    }
    self.editType2Label.textColor = [UIColor whiteColor];
    
    //textfield
    self.editType2TextField.text = editType2PlacementText;
    self.editType2TextField.layer.cornerRadius = 8;
    self.editType2TextField.textColor = self.UIPrinciple.netyBlue;
    
    //save button
    [self.saveButtonOutlet setTintColor:[UIColor whiteColor]];
    
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//When begins editing, set textfield to none
- (BOOL)textViewShouldBeginEditing:(UITextField *)textView {
    textView.attributedText = nil;
    return YES;
}

//Move screen up a bit when Keyboard appears for Description only
-(void)textViewDidBeginEditing:(UITextView *)textView {
    changed = true;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -50., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    self.editType2TextField.text = @"";
    
}

//Move screen down a bit when Keyboard appears for Description only
-(void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +50., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


//Back button to go back to my info
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//save and go back to my info
- (IBAction)saveButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View Disappear
//---------------------------------------------------------


-(void)viewWillDisappear:(BOOL)animated {
    
    if (changed == true) {
        
        FIRDatabaseReference *firdatabase = [[FIRDatabase database] reference];
        
        if (self.statusOrSummary == 0) {
        
            [[[[firdatabase child:kUsers]
                            child:MY_USER.userID]
                            child:kStatus]
                            setValue:self.editType2TextField.text];
            
        } else {
            [[[[firdatabase child:kUsers]
                            child:MY_USER.userID]
                            child:kSummary]
                            setValue:self.editType2TextField.text];
        
        }
    }
    
}


#pragma mark - Custom methods
//---------------------------------------------------------






//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



























