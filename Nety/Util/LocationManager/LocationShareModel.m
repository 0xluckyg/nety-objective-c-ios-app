//
//  LocationShareModel.m
//  Nety
//
//  Created by Scott Cho on 11/18/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "LocationShareModel.h"

@implementation LocationShareModel

//Class method to make sure the share model is synch across the app
+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
