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
#import "UserInformation.h"

@import Firebase;

@interface Chat : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate> {
    
    NSDictionary *userDataDictionary;
    bool deleteOnUserSide;

}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *recentChatArray;

@property (strong, nonatomic) NSMutableArray *oldChatArray;

@property (strong, nonatomic) NSMutableArray *recentChatRoomKeyArray;

@property (strong, nonatomic) NSMutableArray *oldChatRoomKeyArray;

@property (strong, nonatomic) NSCache *imageCache;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;


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
