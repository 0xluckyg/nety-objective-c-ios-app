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

@import Firebase;

@interface MyNetwork : N_CoreDataTableViewController <UISearchBarDelegate, SWTableViewCellDelegate> 


//VARIABLES----------------------------------------





//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
