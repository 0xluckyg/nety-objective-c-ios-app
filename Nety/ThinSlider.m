//
//  ThinSlider.m
//  Nety
//
//  Created by Magfurul Abeer on 12/9/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "ThinSlider.h"
#import "UIPrinciples.h"

@implementation ThinSlider

-(CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect newBounds = [super trackRectForBounds:bounds];
    newBounds.size.height = [[[UIPrinciples alloc] init] thinSliderTrackHeight];
    return newBounds;
}

@end
