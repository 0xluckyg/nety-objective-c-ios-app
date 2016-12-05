//
//  BlockedFriendsCell.h
//  Nety
//
//  Created by Scott Cho on 12/4/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface BlockedFriendsCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *blockedUserImage;

@property (weak, nonatomic) IBOutlet UILabel *blockedUserName;
@property (weak, nonatomic) IBOutlet UILabel *blockedUserJob;

@end
