//
//  MyInfoEditType1.h
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface MyInfoEditType1 : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

- (IBAction)backButton:(id)sender;

@end
