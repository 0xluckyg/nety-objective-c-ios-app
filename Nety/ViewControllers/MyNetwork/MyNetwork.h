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
#import "UIPrinciples.h"
#import "MyNetworkCell.h"
#import "Profile.h"
#import "N_CoreDataTableViewController.h"

@import Firebase;

@interface MyNetwork : N_CoreDataTableViewController <UISearchBarDelegate, SWTableViewCellDelegate> 


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *userArray;

@property (strong, nonatomic) NSMutableArray *userKeyArray;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
