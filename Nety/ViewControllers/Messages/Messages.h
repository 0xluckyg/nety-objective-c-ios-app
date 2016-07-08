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

@interface Messages : JSQMessagesViewController

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;

@property (strong, nonatomic) JSQMessagesAvatarImage *incomingBubbleAvatarImage;

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@end
