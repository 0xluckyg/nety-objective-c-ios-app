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

NSString *const keyExperienceName = @"experienceName";
NSString *const keyExperienceTime = @"experienceTime";
NSString *const keyExperienceDescription = @"experienceDescription";

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
        
        
        _userExperienceArray = [NSMutableArray arrayWithObjects:
                        @{keyExperienceName: @"Worked at Linked In",
                          keyExperienceTime: @"2015/4/15 to 2016/2/3",
                          keyExperienceDescription: @"Worked at Linked in to build relationships"},
                          
                        @{keyExperienceName: @"Worked at Facebook",
                          keyExperienceTime: @"2013/4/15 to 2016/5/3",
                          keyExperienceDescription: @"Built some good stuff and all that shit"},
                          
                        @{keyExperienceName: @"Worked at Goldman Sachs",
                          keyExperienceTime: @"2011/4/15 to 2012/5/25",
                          keyExperienceDescription: @"Finance and merger and all that"},
                          
                        @{keyExperienceName: @"Worked at Freelancer.com",
                          keyExperienceTime: @"2013/3/15 to 2014/1/13",
                          keyExperienceDescription: @"Freelancer.com sucks."},
                          
                        @{keyExperienceName: @"Worked at Nety",
                          keyExperienceTime: @"2016/7/15 to 2016/9/3",
                          keyExperienceDescription: @"Nety will be the next big thing in the world"}, nil];
        
    }
    return self;
}

@end
