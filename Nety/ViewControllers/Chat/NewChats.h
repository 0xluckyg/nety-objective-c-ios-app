//
//  Chat.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "UIPrinciples.h"
#import "Messages.h"
#import "ChatCell.h"
#import "NoContent.h"
#import "N_CoreDataTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatRooms.h"

@protocol pushViewControllerProtocolFromNewChats <NSObject>

-(void) pushViewControllerThroughProtocolFromNewChats: (Messages *)messageVC;

@end

@import Firebase;

@interface NewChats : N_CoreDataTableViewController <SWTableViewCellDelegate, UISearchBarDelegate>



//VARIABLES----------------------------------------

@property (weak, nonatomic) id<pushViewControllerProtocolFromNewChats>delegateFromNewChats;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------


//IBOUTLETS----------------------------------------

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


//IBACTIONS----------------------------------------



//-------------------------------------------------


@end
