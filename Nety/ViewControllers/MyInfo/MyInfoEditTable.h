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

@interface MyInfoEditTable : UIViewController <UITableViewDelegate, UITableViewDataSource, experienceDataDelegate> {
    bool editButtonClicked;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NSMutableArray *experienceArray;

@property (strong, nonatomic) NoContent *noContentController;


@property (nonatomic) bool add;

@property (nonatomic) NSUInteger arrayIndex;


- (IBAction)backButton:(id)sender;

- (IBAction)editButton:(id)sender;

- (IBAction)addButton:(id)sender;

@end
