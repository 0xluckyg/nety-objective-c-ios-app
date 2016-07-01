//
//  UIPrinciples.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "UIPrinciples.h"

@implementation UIPrinciples

- (instancetype)init
{
    self = [super init];
    if (self) {
        _netyBlue = [UIColor colorWithRed:73.0f/255.0f green:101.0f/255.0f blue:146.0f/255.0f alpha:1.0f];
        _netyRed = [UIColor colorWithRed:220.0f/255.0f green:68.0f/255.0f blue:55.0f/255.0f alpha:1.0f];
        _netyGray = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        _netyTransparent = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
    }
    return self;
}

@end
