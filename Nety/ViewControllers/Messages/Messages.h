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

@interface Messages : JSQMessagesViewController


//VARIABLES----------------------------------------


@property (strong, nonatomic) NSMutableArray *messages;


//UTIL CLASSES----------------------------------------


@property (strong, nonatomic) UIPrinciples *UIPrinciple;


//LIB CLASSES----------------------------------------


@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;

@property (strong, nonatomic) JSQMessagesAvatarImage *incomingBubbleAvatarImage;


//IBOUTLETS----------------------------------------





//IBACTIONS----------------------------------------





//-------------------------------------------------


@end
