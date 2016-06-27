//
//  NetworkCell.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *networkUserImage;

@property (weak, nonatomic) IBOutlet UILabel *networkUserName;
@property (weak, nonatomic) IBOutlet UILabel *networkUserJob;
@property (weak, nonatomic) IBOutlet UILabel *networkUserDescription;

@end
