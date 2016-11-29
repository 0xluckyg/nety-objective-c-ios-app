//
//  SignupProcess2.h
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "NoContent.h"
#import "SignupProcessExperienceDetail.h"

@interface SignupProcess2 : UIViewController <UITableViewDelegate, UITableViewDataSource, experienceDataDelegate> {
    bool editButtonClicked;
}


//VARIABLES----------------------------------------


@property (nonatomic) bool add;

@property (nonatomic) NSUInteger arrayIndex;

@property (strong, nonatomic) NSMutableArray *userInfo;

@property (strong, nonatomic) NSMutableArray *experienceArray;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UILabel *process2Title;

@property (weak, nonatomic) IBOutlet UIButton *editButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//IBACTIONS----------------------------------------


- (IBAction)backButton:(id)sender;

- (IBAction)editButton:(id)sender;

- (IBAction)addButton:(id)sender;

- (IBAction)laterButton:(id)sender;


//-------------------------------------------------


@end