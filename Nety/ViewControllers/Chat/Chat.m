//
//  Chat.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Chat.h"
#import "ChatCell.h"
#import "NetworkData.h"
#import "SWTableViewCell.h"
#import "UIPrinciples.h"
#import "Messages.h"

@interface Chat ()

@end

@implementation Chat

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
    
    //Set searchbar color
    [self.topBar setBackgroundColor:self.UIPrinciple.netyBlue];
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
    
    //Set up option view color
    [self.oldNewView setBackgroundColor:self.UIPrinciple.netyBlue];
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
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    //Setting cell data
    NSDictionary *userDataDictionary = self.userData.userDataArray[row];
    chatCell.chatUserImage.image = [UIImage imageNamed:[userDataDictionary objectForKey:keyImage]];
    
    //Set name
    chatCell.chatUserName.text = [userDataDictionary objectForKey:keyName];
    //Set job
    chatCell.chatTime.text = [userDataDictionary objectForKey:keyJob];

    //Set description
    NSString *descriptionText = [userDataDictionary objectForKey:keyDescription];
    chatCell.chatDescription.text = descriptionText;
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [chatCell setSelectedBackgroundView:bgColorView];
    //Set highlighted color to white
    chatCell.chatUserName.highlightedTextColor = [UIColor whiteColor];
    chatCell.chatTime.highlightedTextColor = [UIColor whiteColor];
    chatCell.chatDescription.highlightedTextColor = [UIColor whiteColor];

    //SWTableViewCell configuration
    NSMutableArray *chatRightUtilityButtons = [[NSMutableArray alloc] init];
    
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 1) {

        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyBlue
                                                             title:@"Block"];
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyRed
                                                             title:@"Delete"];
    
    } else {

        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyGray
                                                        title:@"Block"];
        
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyBlue
                                                             title:@"Add"];
        [chatRightUtilityButtons sw_addUtilityButtonWithColor:
         self.UIPrinciple.netyRed
                                                             title:@"Delete"];

    }
    
    chatCell.rightUtilityButtons = chatRightUtilityButtons;
    chatCell.delegate = self;
    
    return chatCell;
}

- (IBAction)oldNewSegmentedAction:(id)sender {
    
    [self.tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MessagesSegue" sender:self];
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

//Actions when right swipe buttons are tapped
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (self.oldNewSegmentedControl.selectedSegmentIndex == 1) {
    switch (index) {
        case 0: {
            NSLog(@"0 on NEW pressed");
            break;
        }
        case 1: {
            NSLog(@"1 one NEW pressed");
            
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
        
    } else {
        switch (index) {
            case 0: {
                NSLog(@"0 on OLD pressed");
                break;
            }
            case 1: {
                NSLog(@"1 on OLD pressed");
                
                // Delete button is pressed
                //          NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
                //          [self.userData.userDataArray[cellIndexPath.row] removeObjectAtIndex:cellIndexPath.row] ;
                //          [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                
                break;
            }
            case 2: {
                NSLog(@"2 on OLD pressed");
            }
            
            default: {
                break;
            }
        }
    }
}

//Hide keyboard when search button pressed
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
