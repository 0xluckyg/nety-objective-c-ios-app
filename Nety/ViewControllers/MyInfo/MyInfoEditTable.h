//
//  MyInfoEditTable.h
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "NetworkData.h"
#import "NoContent.h"
#import "MyInfoEditTable.h"
#import "MyInfoEditExperience.h"

@protocol experienceDataToMyInfoDelegate <NSObject>

-(void) experienceDataToMyInfo: (NSMutableArray *)experienceData;

@end


@interface MyInfoEditTable : UIViewController <UITableViewDelegate, UITableViewDataSource, experienceDataDelegate> {
    bool editButtonClicked;
}


//VARIABLES----------------------------------------


@property (weak, nonatomic) id<experienceDataToMyInfoDelegate>delegate;

@property (strong, nonatomic) NSMutableArray *experienceArray;

@property (nonatomic) bool add;

@property (nonatomic) NSUInteger arrayIndex;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UITableView *tableView;


//IBACTIONS----------------------------------------


- (IBAction)backButton:(id)sender;

- (IBAction)editButton:(id)sender;

- (IBAction)addButton:(id)sender;


//-------------------------------------------------


@end
