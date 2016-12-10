//
//  MyInfoEditTable.h
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "MyInfoEditTable.h"
#import "MyInfoEditExperience.h"
#import "MyInfoEditTableCell.h"
#import "MyInfoEditExperience.h"
#import "Constants.h"


@import Firebase;

@interface MyInfoEditTable : UIViewController <UITableViewDelegate, UITableViewDataSource, experienceDataDelegate> {
    bool editButtonClicked;
}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *experienceArray;

@property (nonatomic) bool add;

@property (nonatomic) NSUInteger arrayIndex;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UITableView *tableView;


//IBACTIONS----------------------------------------


- (IBAction)editButton:(id)sender;

- (IBAction)addButton:(id)sender;


//-------------------------------------------------


@end
