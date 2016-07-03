//
//  Signup.m
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Signup.h"

@interface Signup ()

@end

@implementation Signup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.holdingView.backgroundColor = self.UIPrinciple.netyBlue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupButton:(id)sender {
    
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.age.text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    
    if (self.email.text.length < 10) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Please enter a valid email"
                                    message:@"Your email is too short!"
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (self.password.text.length > 15 || self.password.text.length < 6) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Please enter a valid password"
                                    message:@"Your password has to be between 6 to 15 characters"
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (!valid || self.age.text.integerValue < 5 || self.age.text.integerValue > 100) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Please enter a valid age"
                                    message:@"That's not your age, is it?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (self.name.text.length < 2 || self.name.text.length > 25) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Please enter a valid name"
                                    message:@"What's your real name?"
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self performSegueWithIdentifier:@"signupProcess1Segue" sender:self];
    }

}

- (IBAction)signupWithLinkedinButton:(id)sender {
    
}

//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//Go back to main screen
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
