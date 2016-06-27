//
//  ChatCell.m
//  Nety
//
//  Created by Scott Cho on 6/26/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "ChatCell.h"
#import "UIPrinciples.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self initializeDesign];
    
}

- (void)initializeDesign {
    self.chatUserImage.layer.cornerRadius = self.chatUserImage.frame.size.height /2;
    self.chatUserImage.layer.masksToBounds = YES;
    self.chatUserImage.layer.borderWidth = 0;
    
    self.chatNotificationView.layer.masksToBounds = YES;
    self.chatNotificationView.layer.cornerRadius = self.chatNotificationView.frame.size.height /2;
    self.chatNotificationView.layer.borderWidth = 0;
    
    UIPrinciples *UIPrinciple = [[UIPrinciples alloc] init];
    [self.chatNotificationView setBackgroundColor:UIPrinciple.netyBlue];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end