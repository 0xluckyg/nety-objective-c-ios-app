//
//  LocationShareModel.h
//  Nety
//
//  Created by Scott Cho on 11/18/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationShareModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;
@property (nonatomic) BackgroundTaskManager * bgTask;
@property (nonatomic) NSMutableArray *myLocationArray;
@property (nonatomic) CLLocation *center;

+(id)sharedModel;

@end
