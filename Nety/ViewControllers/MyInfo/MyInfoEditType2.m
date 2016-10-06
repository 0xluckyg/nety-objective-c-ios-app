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


-(BOOL)hidesBottomBarWhenPushed {
    return YES;
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
            editType2PlacementText = NSLocalizedString(@"statusEdit", nil);
        }
    } else {
        if (![MY_USER.summary isEqualToString:@""]) {
            editType2PlacementText = MY_USER.summary;
        } else {
            editType2PlacementText = NSLocalizedString(@"summaryEdit", nil);
        }
    }
    
    
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background of page
    self.view.backgroundColor = self.UIPrinciple.netyBlue;

    self.editType2Label.textColor = [UIColor whiteColor];
    
    //textfield
    self.editType2TextField.text = editType2PlacementText;
    self.editType2TextField.layer.cornerRadius = 8;
    self.editType2TextField.textColor = self.UIPrinciple.netyBlue;
    
    //save button
    [self.saveButtonOutlet setTintColor:[UIColor whiteColor]];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    if (self.statusOrSummary == 0) {
        self.editType2Label.text = NSLocalizedString(@"statusEditLabel", nil);
        self.navigationItem.title = NSLocalizedString(@"statusEditTitle", nil);
    } else {
        self.editType2Label.text = NSLocalizedString(@"summaryEditLabel", nil);
        self.navigationItem.title = NSLocalizedString(@"summaryEditTitle", nil);
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
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
            
            [MY_USER setValue:self.editType2TextField.text forKey:kStatus];
            
            [[[[firdatabase child:kUsers]
                            child:MY_USER.userID]
                            child:kStatus]
                            setValue:self.editType2TextField.text];
            
        } else {
            
            [MY_USER setValue:self.editType2TextField.text forKey:kSummary];
            
            [[[[firdatabase child:kUsers]
                            child:MY_USER.userID]
                            child:kSummary]
                            setValue:self.editType2TextField.text];
        
        }
    }
    
}


#pragma mark - Custom methods
//---------------------------------------------------------


-(void) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



























