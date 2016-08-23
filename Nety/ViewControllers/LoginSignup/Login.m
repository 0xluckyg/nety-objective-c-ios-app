//
//  Login.m
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Login.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface Login ()

@end

@implementation Login


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if DEBUG
    [_password setText:@"ptest3"];
    [_email setText:@"test3@gmail.com"];
#endif
    
    [self initializeSettings];
    [self initializeDesign];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    self.firdatabase = [[FIRDatabase database] reference];
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
    
    self.email.textColor = self.UIPrinciple.netyBlue;
    self.password.textColor = self.UIPrinciple.netyBlue;
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


//Log in the user after checking pw/id
- (IBAction)loginButton:(id)sender {
    
    if (self.email.text.length < 10) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid email" message:@"Your email is too short!" viewController:self];
        
    } else if (self.password.text.length > 15 || self.password.text.length < 6) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid password" message:@"Your password has to be between 6 to 15 characters" viewController:self];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud.label setText:@"Logging in"];;
        [hud.bezelView setColor:[self.UIPrinciple.netyBlue colorWithAlphaComponent:0.3f]];
        [hud showAnimated:YES];
        
        [MY_API loginToAcc:self.email.text pass:self.password.text DoneBlock:^(NSDictionary *dict, NSError *error) {
            if (error)
            {
                [hud hideAnimated:YES];
                
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Problem signing in" message:error.localizedDescription viewController:self];
            }
            else
            {
                [self changeRoot];
                
                [hud hideAnimated:YES];

            }
        }];
    }
}

- (IBAction)loginWithLinkedinButton:(id)sender {
    
    //Just set root controller to tabbar
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarRootController];
    
}

//Go back to main screen
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark - Custom methods
//---------------------------------------------------------


- (void)changeRoot {
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
