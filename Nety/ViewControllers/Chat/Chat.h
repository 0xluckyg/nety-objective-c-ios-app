//
//  MyChats.h
//  Nety
//
//  Created by Scott Cho on 8/21/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewChats.h"
#import "MyChats.h"
#import "CAPSPageMenu.h"
#import "UIPrinciples.h"

@interface Chat : UIViewController <pushViewControllerProtocolFromNewChats, pushViewControllerProtocolFromMyChats>

@property (nonatomic) CAPSPageMenu *pageMenu;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@end
