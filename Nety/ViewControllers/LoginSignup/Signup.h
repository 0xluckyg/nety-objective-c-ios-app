//
//  Signup.h
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@import Firebase;

@interface Signup : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UIView *holdingView;

@property (weak, nonatomic) IBOutlet UIButton *signupButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *signupWithLinkedinButtonOutlet;

@property (strong, nonatomic) NSMutableArray *userInfo;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

- (IBAction)signupButton:(id)sender;

- (IBAction)signupWithLinkedinButton:(id)sender;

- (IBAction)backButton:(id)sender;



@end
