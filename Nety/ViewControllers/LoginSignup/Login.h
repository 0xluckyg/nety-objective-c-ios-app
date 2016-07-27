//
//  Login.h
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "UserInformation.h"
#import "AppDelegate.h"
#import "Constants.h"

@import Firebase;

@interface Login : UIViewController


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *holdingView;

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *loginWithLinkedinOutlet;


//IBACTIONS----------------------------------------

- (IBAction)backButton:(id)sender;

- (IBAction)loginButton:(id)sender;

- (IBAction)loginWithLinkedinButton:(id)sender;


//-------------------------------------------------

@end
