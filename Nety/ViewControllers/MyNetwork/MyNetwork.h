//
//  MyNetwork.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "UIPrinciples.h"
#import "Constants.h"
#import "UIPrinciples.h"
#import "MyNetworkCell.h"
#import "Profile.h"
#import "N_CoreDataTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@import Firebase;

@interface MyNetwork : N_CoreDataTableViewController <UISearchBarDelegate, SWTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
