//
//  SignupProcess1.m
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcess1.h"

@interface SignupProcess1 ()

@end

@implementation SignupProcess1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
}

- (void)initializeSettings {


}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background of page
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //navbar design
    self.topBar.backgroundColor = self.UIPrinciple.netyBlue;
    [[UINavigationBar appearance] setBarTintColor:self.UIPrinciple.netyBlue];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
    //Label
    self.jobLabel.textColor = [UIColor whiteColor];
    self.summaryLabel.textColor = [UIColor whiteColor];
    
    //textfield
    self.summaryTextField.text = @"ex. I'm an energetic developer at Nety who loves Chipotle and enjoys playing piano during free times";
    self.summaryTextField.textColor = self.UIPrinciple.defaultGray;
    self.summaryTextField.layer.cornerRadius = 8;
    
    //save button
    [self.nextButtonOutlet setTintColor:[UIColor whiteColor]];
    
    
}

//When begins editing, set textfield to none
- (BOOL)textViewShouldBeginEditing:(UITextField *)textView
{
    textView.attributedText = nil;
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
@end



























