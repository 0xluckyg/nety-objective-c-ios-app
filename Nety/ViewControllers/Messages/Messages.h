//
//  Messages.h
//  Nety
//
//  Created by Scott Cho on 7/7/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import "UIPrinciples.h"
#import "Constants.h"
#import "MBProgressHUD.h"

#import <SDWebImage/UIImageView+WebCache.h>
//
@import Firebase;

@interface Messages : JSQMessagesViewController {
    NSInteger readcount;
    NSInteger otherUserStatus;
}


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSString *selectedUserID;

@property (strong, nonatomic) NSString *selectedUserProfileImageString;

@property (strong, nonatomic) NSString *selectedUserName;

@property (strong, nonatomic) UIImage *selectedUserProfileImage;

@property (strong, nonatomic) NSString *chatroomID;

@property (strong, nonatomic) UIImage *chatImage;

//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;

@property (strong, nonatomic) JSQMessagesAvatarImage *incomingBubbleAvatarImage;


//IBOUTLETS----------------------------------------





//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
