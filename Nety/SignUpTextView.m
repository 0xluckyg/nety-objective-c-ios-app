//
//  SignUpTextView.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "SignUpTextView.h"

@implementation SignUpTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.placeholderTextColor = [UIColor colorWithWhite:0.8 alpha:1 ];;
//        self.clipsToBounds = NO;
        self.contentInset = UIEdgeInsetsMake(0, 10, 10, 10);
        self.textContainerInset = UIEdgeInsetsMake(0, 10, 10, 10);
        [self addBorder];
    }
    return self;
}

- (void)addBorder {
    self.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
    self.layer.borderWidth = 0.5;
}

@end
