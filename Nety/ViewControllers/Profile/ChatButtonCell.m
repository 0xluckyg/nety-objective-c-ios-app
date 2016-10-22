//
//  ChatButtonCell.m
//  Nety
//
//  Created by Scott Cho on 8/24/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "ChatButtonCell.h"

@implementation ChatButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.buttonOutlet.tintColor = self.UIPrinciple.netyBlue;
    
    float cellHeight = self.contentView.frame.size.height;
    float cellWidth = self.contentView.frame.size.width;
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 2, cellWidth, 1)];/// change size as you need.
    separatorLineView.backgroundColor = self.UIPrinciple.netyBlue;
    [self.contentView addSubview:separatorLineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
