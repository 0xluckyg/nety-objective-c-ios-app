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
#import "NoContent.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWTableViewCell.h"


@interface BlockedFriends : N_CoreDataTableViewController <UISearchBarDelegate, SWTableViewCellDelegate>

@property (strong,nonatomic) UIPrinciples *UIPrinciple;

@property (strong, nonatomic) NoContent *noContentController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
