//
//  Profile.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "Constants.h"
#import "Messages.h"
#import "Users.h"
#import "UIScrollView+APParallaxHeader.h"
#import "ChatButton.h"

@interface Profile : UIViewController <UITableViewDelegate, UITableViewDataSource, APParallaxViewDelegate>


//VARIABLES----------------------------------------

@property (strong,nonatomic) Users* selectedUser;

//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------



//IBOUTLETS----------------------------------------

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *basicInfoView;

@property (weak, nonatomic) IBOutlet UILabel *identityInfo;

@property (weak, nonatomic) IBOutlet UILabel *statusInfo;

@property (weak, nonatomic) IBOutlet UILabel *summaryInfo;

@property (weak, nonatomic) IBOutlet UILabel *experienceInfo;

@property (weak, nonatomic) IBOutlet UIButton *chatNowButtonOutlet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewTopConstraint;


//IBACTIONS----------------------------------------


- (IBAction)chatNowButton:(id)sender;

//-------------------------------------------------


@end
