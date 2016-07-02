//
//  MyInfoEditType1.h
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface MyInfoEditType1 : UIViewController <UITextFieldDelegate> {
    NSString *editType1NamePlacementText;
    NSString *editType1JobPlacementText;
}

@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UILabel *editType1NameLabel;

@property (weak, nonatomic) IBOutlet UITextField *editType1NameTextField;

@property (weak, nonatomic) IBOutlet UILabel *editType1JobLabel;

@property (weak, nonatomic) IBOutlet UITextField *editType1JobTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

- (IBAction)backButton:(id)sender;

- (IBAction)saveButton:(id)sender;


@end
