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
#import "Messages.h"

@import Firebase;

@protocol pushViewControllerProtocolFromMyChats <NSObject>

-(void) pushViewControllerThroughProtocolFromMyChats: (Messages *)messageVC;

@end

@interface MyChats : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate> {
    
    NSDictionary *userDataDictionary;
    bool userAddedAsFriend;
    
}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *oldChatArray;

@property (strong, nonatomic) NSMutableArray *oldChatRoomKeyArray;

@property (weak, nonatomic) id<pushViewControllerProtocolFromMyChats>delegateFromMyChats;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

@property (strong, nonatomic) FIRDatabaseQuery *chatRoomsRef;


//IBOUTLETS----------------------------------------


@property (weak, nonatomic) IBOutlet UITableView *tableView;


//IBACTIONS----------------------------------------



//-------------------------------------------------


@end
