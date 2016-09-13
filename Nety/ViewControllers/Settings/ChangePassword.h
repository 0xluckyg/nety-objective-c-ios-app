//
//  ChangePassword.h
//  Nety
//
//  Created by Scott Cho on 9/12/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@import Firebase;

@interface ChangePassword : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *passwordOld;

@property (weak, nonatomic) IBOutlet UITextField *passwordNew;

@property (weak, nonatomic) IBOutlet UITextField *passwordNewRepeat;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

@end
