//
//  SignupProcess1.m
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcess1.h"
#import "SignupProcess2.h"

@interface SignupProcess1 ()

@end

@implementation SignupProcess1


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
    
    NSLog(@"%@, %@, %@, %@, %@", self.userInfo[0], self.userInfo[1], self.userInfo[2], self.userInfo[3] ,self.userInfo[4]);
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set placeholder for the big box
    summaryPlaceholder = @"Please decribe yourself!";
    
    //Background of page
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Label
    self.jobLabel.textColor = [UIColor whiteColor];
    self.summaryLabel.textColor = [UIColor whiteColor];
    
    //textfield
    self.summaryTextField.text = summaryPlaceholder;
    self.summaryTextField.textColor = self.UIPrinciple.netyBlue;
    self.summaryTextField.layer.cornerRadius = 8;
    self.jobTextField.textColor = self.UIPrinciple.netyBlue;
    self.jobTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What do you do?" attributes:@{NSForegroundColorAttributeName: self.UIPrinciple.netyBlue}];

    
    //save button
    [self.nextButtonOutlet setTintColor:[UIColor whiteColor]];
    
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//When begins editing, set textfield to none
- (BOOL)textViewShouldBeginEditing:(UITextField *)textView
{
    textView.attributedText = nil;
    textView.textColor = self.UIPrinciple.netyBlue;
    return YES;
}

//Move screen up a bit when Keyboard appears for Description only
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -100., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

//Move screen down a bit when Keyboard appears for Description only
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +100., self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



#pragma mark - Buttons
//---------------------------------------------------------


//Back button to go back to my info
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//save and go back to my info
- (IBAction)nextButton:(id)sender {
    [self performSegueWithIdentifier:@"signupProcess2Segue" sender:self];
}

//Moves on without saving
- (IBAction)laterButton:(id)sender {
    [self performSegueWithIdentifier:@"signupProcess2Segue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"signupProcess2Segue"])
    {
        NSString *summary = [[NSString alloc] init];
        
        if ([self.summaryTextField.text isEqualToString:summaryPlaceholder]) {
            summary = @"";
        } else {
            summary = self.summaryTextField.text;
        }
        
        [self.userInfo insertObject:self.jobTextField.text atIndex:5];
        [self.userInfo insertObject:summary atIndex:6];
        
        [self.jobTextField endEditing:YES];
        [self.summaryTextField endEditing:YES];
        
        // Get reference to the destination view controller
        SignupProcess2 *process2 = [segue destinationViewController];
        
        process2.userInfo = self.userInfo;
        
    }
    
}


#pragma mark - Custom methods
//---------------------------------------------------------






//---------------------------------------------------------


@end



























