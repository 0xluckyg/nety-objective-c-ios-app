//
//  SignupProcess3.h
//  Nety
//
//  Created by Scott Cho on 7/6/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import <Firebase/Firebase.h>

@interface SignupProcess3 : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIButton *addProfileImageOutlet;

@property (weak, nonatomic) IBOutlet UIButton *doneButtonOutlet;




@property (strong, nonatomic) FIRDatabase *firdatabase;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

- (IBAction)addProfileImage:(id)sender;

- (IBAction)doneButton:(id)sender;

- (IBAction)backButton:(id)sender;


@end
