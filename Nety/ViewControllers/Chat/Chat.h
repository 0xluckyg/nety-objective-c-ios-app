//
//  Chat.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkData.h"
#import "SWTableViewCell.h"
#import "UIPrinciples.h"

@interface Chat : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate>


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

//Temporary
@property (strong, nonatomic) NetworkData *userData;


//LIB CLASSES----------------------------------------





//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *oldNewSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *oldNewView;


//IBACTIONS----------------------------------------


- (IBAction)oldNewSegmentedAction:(id)sender;


//-------------------------------------------------


@end
