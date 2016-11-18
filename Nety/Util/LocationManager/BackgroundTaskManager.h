//
//  BackgroundTaskManager.h
//  Nety
//
//  Created by Scott Cho on 11/18/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundTaskManager : NSObject

+(instancetype)sharedBackgroundTaskManager;

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;
-(void)endAllBackgroundTasks;

@end
