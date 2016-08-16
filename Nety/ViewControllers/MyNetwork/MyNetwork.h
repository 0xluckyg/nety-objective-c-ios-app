//
//  MyNetwork.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkData.h"
#import "SWTableViewCell.h"
#import "UIPrinciples.h"
#import "Constants.h"
#import "UserInformation.h"
#import "UIPrinciples.h"
#import "MyNetworkCell.h"
#import "Profile.h"

@import Firebase;

@interface MyNetwork : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate> {

    NSDictionary *userDataDictionary;
    
}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *userArray;

@property (strong, nonatomic) NSMutableArray *userKeyArray;

@property (strong, nonatomic) NSCache *imageCache;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

@property (strong, nonatomic) FIRDatabaseQuery *userDetailRef;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
