//
//  MyInfo.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "SignupProcess3.h"
#import "Constants.h"
#import "MyInfoEditTable.h"
#import "MyInfoEditType2.h"
#import "MyInfoEditType1.h"
#import "UIScrollView+APParallaxHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyInfoMainCell.h"
#import "MyInfoExperienceCell.h"
#import "MyInfoInterestCell.h"

@import Firebase;

@interface MyInfo : UIViewController <UITableViewDelegate, UITableViewDataSource, APParallaxViewDelegate> {
    int numberOfComponents;
}

//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableDictionary *userData;

@property (strong, nonatomic) NSMutableArray *experienceArray;

@property (strong, nonatomic) UIImageView *profileImageView;

//UTIL CLASSES----------------------------------------

@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//IBACTIONS----------------------------------------



//-------------------------------------------------


@end
