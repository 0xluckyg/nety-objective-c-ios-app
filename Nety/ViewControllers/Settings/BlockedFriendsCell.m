//
//  BlockedFriendsCell.m
//  Nety
//
//  Created by Scott Cho on 12/4/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "BlockedFriendsCell.h"

@implementation BlockedFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initializeDesign];
    
}

- (void)initializeDesign {
    self.blockedUserImage.layer.cornerRadius = self.blockedUserImage.frame.size.height /2;
    self.blockedUserImage.layer.masksToBounds = YES;
    self.blockedUserImage.layer.borderWidth = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
