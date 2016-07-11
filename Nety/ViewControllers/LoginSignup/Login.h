//
//  Login.h
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface Login : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIView *holdingView;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *loginWithLinkedinOutlet;


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

- (IBAction)loginButton:(id)sender;

- (IBAction)loginWithLinkedinButton:(id)sender;

- (IBAction)backButton:(id)sender;


@end
