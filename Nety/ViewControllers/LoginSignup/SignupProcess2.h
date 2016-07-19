//
//  SignupProcess2.h
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "NetworkData.h"
#import "NoContent.h"
#import "SignupProcessExperienceDetail.h"

@interface SignupProcess2 : UIViewController <UITableViewDelegate, UITableViewDataSource, experienceDataDelegate> {
    bool editButtonClicked;
}

@property (weak, nonatomic) IBOutlet UIButton *editButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *userInfo;

@property (strong, nonatomic) NoContent *noContentController;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NSMutableArray *experienceArray;


@property (nonatomic) bool add;

@property (nonatomic) NSUInteger arrayIndex;

- (IBAction)backButton:(id)sender;

- (IBAction)editButton:(id)sender;

- (IBAction)addButton:(id)sender;

- (IBAction)laterButton:(id)sender;


@end
