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

@interface Network : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *usersArray;

@property (strong, nonatomic) NSMutableArray *userIDArray;

@property (strong, nonatomic) NSCache *imageCache;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NetworkData *userData;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
