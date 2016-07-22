//
//  Login.m
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Login.h"
#import "AppDelegate.h"
#import "SingletonUserData.h"
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface Login ()

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
}


- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.holdingView.backgroundColor = self.UIPrinciple.netyBlue;
    
    [self.loginButtonOutlet.layer setBorderWidth:1.0];
    [self.loginButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginButtonOutlet.layer setCornerRadius:self.loginButtonOutlet.frame.size.height/2];
    
    self.loginWithLinkedinOutlet.backgroundColor = self.UIPrinciple.linkedInBlue;
    [self.loginWithLinkedinOutlet.layer setCornerRadius:self.loginWithLinkedinOutlet.frame.size.height/2];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Log in the user after checking pw/id
- (IBAction)loginButton:(id)sender {
    
    if (self.email.text.length < 10) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid email" message:@"Your email is too short!" viewController:self];
        
    } else if (self.password.text.length > 15 || self.password.text.length < 6) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid password" message:@"Your password has to be between 6 to 15 characters" viewController:self];
        
    } else {
        
        [[FIRAuth auth] signInWithEmail:self.email.text
                               password:self.password.text
                             completion:^(FIRUser *user, NSError *error) {
                                 
                                 if (error) {
                                     [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Problem signing in" message:error.localizedDescription viewController:self];
                                 } else {
                                     
                                     NSString *userID = [[self.email.text stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                     
                                     SingletonUserData *singletonUserData = [SingletonUserData sharedInstance];
                                     singletonUserData.userID = userID;
                                     
                                     [self changeRoot];
                                 }
                                 
                             }];
    }
}

- (void)changeRoot {
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [UIView
     transitionWithView:self.view.window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         [appDelegate.window setRootViewController:appDelegate.tabBarRootController];
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}

- (IBAction)loginWithLinkedinButton:(id)sender {
    
    //Just set root controller to tabbar
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarRootController];
    
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
