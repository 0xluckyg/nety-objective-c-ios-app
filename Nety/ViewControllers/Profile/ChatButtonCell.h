//
//  ChatButtonCell.h
//  Nety
//
//  Created by Scott Cho on 8/24/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"

@interface ChatButtonCell : UITableViewCell

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet;

@end
