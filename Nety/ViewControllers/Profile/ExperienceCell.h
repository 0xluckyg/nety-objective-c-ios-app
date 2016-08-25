//
//  ExperienceCell.h
//  Nety
//
//  Created by Scott Cho on 8/24/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *experienceName;

@property (weak, nonatomic) IBOutlet UILabel *experienceDate;

@property (weak, nonatomic) IBOutlet UILabel *experienceDescription;



@end
