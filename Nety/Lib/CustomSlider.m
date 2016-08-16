//
//  CustomSlider.m
//  Nety
//
//  Created by Scott Cho on 8/16/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"CustomSlider" owner:self options:nil] objectAtIndex:0];
        
        
        
    }
    return self;
}

@end
