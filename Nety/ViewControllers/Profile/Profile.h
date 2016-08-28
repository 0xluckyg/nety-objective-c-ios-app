//
//  Profile.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "Constants.h"
#import "Messages.h"
#import "Users.h"
#import "UIScrollView+APParallaxHeader.h"
#import "ChatButtonCell.h"
#import "ExperienceCell.h"
#import "MainInfoCell.h"
#import "InterestCell.h"
#import "UIPrinciples.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreData/CoreData.h>

@interface Profile : UIViewController <UITableViewDelegate, UITableViewDataSource, APParallaxViewDelegate, NSFetchedResultsControllerDelegate> {
    int numberOfComponents;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

//VARIABLES----------------------------------------

@property (strong,nonatomic) Users* selectedUser;
@property (strong,nonatomic) NSString* selectedUserID;

//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------



//IBOUTLETS----------------------------------------

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//IBACTIONS----------------------------------------


- (IBAction)chatNowButton:(id)sender;

//-------------------------------------------------


@end
