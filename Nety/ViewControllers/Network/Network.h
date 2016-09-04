//
//  Network.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "NetworkCell.h"
#import "Profile.h"
#import "MBProgressHUD.h"
#import "NoContent.h"

#import "N_CoreDataTableViewController.h"

@interface Network : N_CoreDataTableViewController <UISearchBarDelegate>


//VARIABLES----------------------------------------


//@property (strong, nonatomic) NSMutableArray *usersArray;

@property (strong, nonatomic) NSMutableArray *userIDArray;

@property (nonatomic) float sliderValue;

@property (nonatomic) float sliderDistanceValue;

//UTIL CLASSES----------------------------------------

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------


//@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UIView *sliderView;


//IBACTIONS----------------------------------------


- (IBAction)sliderAction:(id)sender;



//-------------------------------------------------


@end
