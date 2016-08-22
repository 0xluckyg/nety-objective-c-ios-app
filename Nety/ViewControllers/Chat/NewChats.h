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
#import "ChatCell.h"

@protocol pushViewControllerProtocolFromNewChats <NSObject>

-(void) pushViewControllerThroughProtocolFromNewChats: (Messages *)messageVC;

@end

@import Firebase;

@interface NewChats : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate> {
    
    NSDictionary *userDataDictionary;
    bool userAddedAsFriend;

}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *recentChatArray;

@property (strong, nonatomic) NSMutableArray *recentChatRoomKeyArray;

@property (weak, nonatomic) id<pushViewControllerProtocolFromNewChats>delegateFromNewChats;


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
