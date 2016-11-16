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
#import "N_CoreDataTableViewController.h"
#import "ChatCell.h"
#import "ChatRooms.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import Firebase;

@protocol pushViewControllerProtocolFromMyChats <NSObject>

-(void) pushViewControllerThroughProtocolFromMyChats: (Messages *)messageVC;

@end

@interface MyChats : N_CoreDataTableViewController <UISearchBarDelegate, SWTableViewCellDelegate>


//VARIABLES----------------------------------------

@property (weak, nonatomic) id<pushViewControllerProtocolFromMyChats>delegateFromMyChats;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;


//LIB CLASSES----------------------------------------



//IBOUTLETS----------------------------------------

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//IBACTIONS----------------------------------------



//-------------------------------------------------


@end
