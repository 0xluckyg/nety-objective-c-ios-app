//
//  MyNetwork.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyNetwork.h"
#import "UIPrinciples.h"
#import "MyNetworkCell.h"
#import "NetworkData.h"

@interface MyNetwork ()

@end

@implementation MyNetwork

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSettings];
    [self initializeDesign];
}

//Swiped cell will reset
- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)initializeSettings {
    self.userData = [[NetworkData alloc] init];
}

- (void)initializeDesign {
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set navbar color
    self.topBar.backgroundColor = self.UIPrinciple.netyBlue;
    [[UINavigationBar appearance] setBarTintColor:self.UIPrinciple.netyBlue];
    
    //Set searchbar
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.userData.userDataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Configure cell
    MyNetworkCell *myNetworkCell = [tableView dequeueReusableCellWithIdentifier:@"MyNetworkCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    //Setting cell data
    NSDictionary *userDataDictionary = self.userData.userDataArray[row];
    myNetworkCell.myNetworkUserImage.image = [UIImage imageNamed:[userDataDictionary objectForKey:keyImage]];
    
    //Set name
    myNetworkCell.myNetworkUserName.text = [userDataDictionary objectForKey:keyName];
    //Set job
    myNetworkCell.myNetworkUserJob.text = [userDataDictionary objectForKey:keyJob];
    //Cutting Description if too long
    NSString *descriptionText = [userDataDictionary objectForKey:keyDescription];
    if ([descriptionText length] > 35) {
        descriptionText = [descriptionText substringWithRange:NSMakeRange(0,35)];
        descriptionText = [descriptionText stringByAppendingString:@" ..."];
    }
    //Set description
    myNetworkCell.myNetworkUserDescription.text = descriptionText;
    
    //DESIGN
    //Setting font color of cells to black
    myNetworkCell.myNetworkUserJob.textColor = [UIColor blackColor];
    myNetworkCell.myNetworkUserName.textColor = [UIColor blackColor];
    myNetworkCell.myNetworkUserDescription.textColor = [UIColor blackColor];
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [myNetworkCell setSelectedBackgroundView:bgColorView];
        
    //SWTableViewCell configuration
    NSMutableArray *myNetworkRightUtilityButtons = [[NSMutableArray alloc] init];
    
    [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyBlue
                                                         title:@"Block"];
    [myNetworkRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyRed
                                                         title:@"Delete"];
    
    myNetworkCell.rightUtilityButtons = myNetworkRightUtilityButtons;
    myNetworkCell.delegate = self;
    
    return myNetworkCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNetworkCell *myNetworkCell = [tableView cellForRowAtIndexPath:indexPath];
    myNetworkCell.myNetworkUserJob.textColor = [UIColor whiteColor];
    myNetworkCell.myNetworkUserName.textColor = [UIColor whiteColor];
    myNetworkCell.myNetworkUserDescription.textColor = [UIColor whiteColor];
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            NSLog(@"0 pressed");
            break;
        }
        case 1: {
            NSLog(@"1 pressed");

            // Delete button is pressed
//          NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//          [self.userData.userDataArray[cellIndexPath.row] removeObjectAtIndex:cellIndexPath.row] ;
//          [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            break;

        }
        default: {
            break;
        }
    }
}

@end
