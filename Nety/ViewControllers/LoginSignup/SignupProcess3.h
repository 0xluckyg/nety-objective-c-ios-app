//
//  SignupProcess3.h
//  Nety
//
//  Created by Scott Cho on 7/6/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "AppDelegate.h"
#import "Constants.h"

@import Firebase;

@interface SignupProcess3 : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *addProfileImageOutlet;

@property (weak, nonatomic) IBOutlet UIButton *doneButtonOutlet;

@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NSMutableArray *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *process3Title;


- (IBAction)addProfileImage:(id)sender;

- (IBAction)doneButton:(id)sender;

- (IBAction)backButton:(id)sender;


@end
