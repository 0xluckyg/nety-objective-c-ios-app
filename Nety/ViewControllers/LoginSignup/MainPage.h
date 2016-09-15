//
//  MainPage.h
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>
#import "Constants.h"
#import "AppDelegate.h"


@interface MainPage : UIViewController {
    NSInteger loginOrSignup;
}

//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------





//IBACTIONS----------------------------------------





//-------------------------------------------------



//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------




//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *holdingView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *signupButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *loginWithFacebookOutlet;

@property (weak, nonatomic) IBOutlet UIButton *loginWithLinkedinOutlet;


//IBACTIONS----------------------------------------


- (IBAction)loginButton:(id)sender;

- (IBAction)signupButton:(id)sender;

- (IBAction)loginWithFacebookButton:(id)sender;


//-------------------------------------------------


@end
