//
//  BlockedFriends.h
//  Nety
//
//  Created by Scott Cho on 12/4/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPrinciples.h"
#import "N_CoreDataTableViewController.h"
#import "BlockedFriendsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BlockedFriends : N_CoreDataTableViewController <UISearchBarDelegate, SWTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong,nonatomic) UIPrinciples *UIPrinciple;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
