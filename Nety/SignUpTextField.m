//
//  SignUpTextField.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "SignUpTextField.h"

IB_DESIGNABLE
@implementation SignUpTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIColor *placeholderColor = [UIColor colorWithWhite:0.8 alpha:1 ];
        self.attributedPlaceholder = [[NSAttributedString alloc]
                                      initWithString:self.placeholder
                                      attributes:@{
                                                   NSForegroundColorAttributeName: placeholderColor}];
        
        self.clipsToBounds = NO;
        [self addBorder];
    }
    return self;
}

- (void)addBorder {
    self.border = [[UIView alloc] init];
    self.border.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.border];
    
    self.border.translatesAutoresizingMaskIntoConstraints = NO;
    [self.border.topAnchor constraintEqualToAnchor:self.bottomAnchor constant:4].active = true;
    [self.border.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = true;
    [self.border.heightAnchor constraintEqualToConstant:0.5].active = true;
    [self.border.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
}

-(void)setText:(NSString *)text {
    [super setText:text];
    self.floatingLabel.text = self.titlePlaceholder;
}


@end
