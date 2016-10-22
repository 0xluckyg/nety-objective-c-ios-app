//
//  ChatCell.h
//  Nety
//
//  Created by Scott Cho on 6/26/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ChatCell : SWTableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *chatUserImage;

@property (weak, nonatomic) IBOutlet UILabel *chatUserName;
@property (weak, nonatomic) IBOutlet UILabel *chatTime;
@property (weak, nonatomic) IBOutlet UILabel *chatDescription;

@property (weak, nonatomic) IBOutlet UIView *chatNotificationView;

@property (weak, nonatomic) IBOutlet UILabel *chatNotificationLabel;


@end
