//
//  MyNetworkCell.m
//  Nety
//
//  Created by Scott Cho on 6/26/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyNetworkCell.h"

@implementation MyNetworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self initializeDesign];
    
}

- (void)initializeDesign {
    self.myNetworkUserImage.layer.cornerRadius = self.myNetworkUserImage.frame.size.height /2;
    self.myNetworkUserImage.layer.masksToBounds = YES;
    self.myNetworkUserImage.layer.borderWidth = 0;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
