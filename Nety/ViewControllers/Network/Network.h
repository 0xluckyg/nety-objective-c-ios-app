//
//  Network.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkData.h"
#import "UIPrinciples.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "NetworkCell.h"
#import "Profile.h"
#import "NetworkData.h"
#import "MBProgressHUD.h"

@import Firebase;

@interface Network : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    bool goingToProfileView;
}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *usersArray;

@property (strong, nonatomic) NSMutableArray *userIDArray;

@property (strong, nonatomic) NSCache *imageCache;

@property (nonatomic) float sliderValue;

@property (nonatomic) float sliderDistanceValue;

//UTIL CLASSES----------------------------------------

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *sliderView;

@property (weak, nonatomic) IBOutlet UISlider *slider;


//IBACTIONS----------------------------------------


- (IBAction)sliderAction:(id)sender;


//-------------------------------------------------


@end
