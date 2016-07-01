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

@interface MyInfoEditTable : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    bool editButtonClicked;
}


@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UIButton *editButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NetworkData *experienceData;

- (IBAction)backButton:(id)sender;

- (IBAction)editButton:(id)sender;

- (IBAction)addButton:(id)sender;

@end
