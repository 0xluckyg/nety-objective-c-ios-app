//
//  NoContent.m
//  Nety
//
//  Created by Scott Cho on 7/17/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "NoContent.h"

@implementation NoContent

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"NoContent" owner:self options:nil] objectAtIndex:0];
        
        
        
    }
    return self;
}


@end
