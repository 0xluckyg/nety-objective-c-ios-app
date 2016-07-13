//
//  MyNetwork.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkData.h"
#import "SWTableViewCell.h"
#import "UIPrinciples.h"

@interface MyNetwork : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NetworkData *userData;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;

@end
