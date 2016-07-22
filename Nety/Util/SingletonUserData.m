//
//  SingletonUserData.m
//  Nety
//
//  Created by Scott Cho on 7/21/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SingletonUserData.h"

@implementation SingletonUserData

@synthesize userID = _userID;

+(SingletonUserData *) sharedInstance {
    static SingletonUserData *sharedInstance = nil;
    
    if (!sharedInstance) {
        
        sharedInstance = [[super allocWithZone:nil] init];
    }
    
    return sharedInstance;
    
}

+(id)allocWithZone:(NSZone *)zone {
    
    return [self sharedInstance];

}

-(id)init {
    self = [super init];
    
    if (self) {
        _userID = nil;
    }
    
    return self;
    
}


@end
