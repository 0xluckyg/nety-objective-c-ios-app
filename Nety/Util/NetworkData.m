//
//  NetworkData.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "NetworkData.h"

NSString *const keyName = @"Name";
NSString *const keyJob = @"Job";
NSString *const keyDescription = @"Description";
NSString *const keyImage = @"Image";

@implementation NetworkData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDataArray = [NSMutableArray arrayWithObjects:
                     @{keyName: @"Mark Zuckerberg",
                       keyJob: @"CEO at Facebook",
                       keyDescription: @"I want to meet people interested in entrepreneurship",
                       keyImage: @"duck.jpg"},
                     
                     @{keyName: @"Beth McNeil",
                       keyJob: @"Financial Analyst at JPMorgan",
                       keyDescription: @"I am an accountant",
                       keyImage: @"girl1.jpg"},
                     
                     @{keyName: @"Steve Jobs",
                       keyJob: @"CEO at Apple",
                       keyDescription: @"I'm friends with Wozniek",
                       keyImage: @"girl2.jpg"},
                     
                     @{keyName: @"Scott Cho",
                       keyJob: @"Student at NYU",
                       keyDescription: @"I'm the creator of this app",
                       keyImage: @"man.jpg"},
                     
                     @{keyName: @"Richard Henderson",
                       keyJob: @"CEO at Pied Pipper",
                       keyDescription: @"Pied Pipper for life",
                       keyImage: @"water.jpg"}, nil];
    }
    return self;
}

@end
