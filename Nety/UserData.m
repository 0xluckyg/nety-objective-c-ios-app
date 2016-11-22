//
//  UserData.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "UserData.h"

@implementation UserData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.experiences = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
