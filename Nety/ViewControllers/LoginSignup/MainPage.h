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

@interface MainPage : UIViewController {
    NSInteger loginOrSignup;
}

//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------





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


//IBACTIONS----------------------------------------


- (IBAction)loginButton:(id)sender;

- (IBAction)signupButton:(id)sender;


//-------------------------------------------------


@end
