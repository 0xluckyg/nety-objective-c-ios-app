//
//  MyNetworkCell.h
//  Nety
//
//  Created by Scott Cho on 6/26/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface MyNetworkCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myNetworkUserImage;

@property (weak, nonatomic) IBOutlet UILabel *myNetworkUserName;
@property (weak, nonatomic) IBOutlet UILabel *myNetworkUserJob;
@property (weak, nonatomic) IBOutlet UILabel *myNetworkUserDescription;

@end
