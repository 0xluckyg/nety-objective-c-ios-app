//
//  NetworkCell.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "NetworkCell.h"

@implementation NetworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeDesign];
}

- (void)initializeDesign {
    self.networkUserImage.layer.cornerRadius = self.networkUserImage.frame.size.height /2;
    self.networkUserImage.layer.masksToBounds = YES;
    self.networkUserImage.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
