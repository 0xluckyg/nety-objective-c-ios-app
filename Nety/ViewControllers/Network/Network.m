//
//  Network.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Network.h"
#import "UIPrinciples.h"
#import "NetworkCell.h"
#import "NetworkData.h"

@interface Network ()

@end

@implementation Network

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSettings];
    [self initializeDesign];
}

//Clicked cell will reset
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
    
    //Set searchbar
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBarView setBackgroundColor:self.UIPrinciple.netyBlue];
    
    //Set navbar color
    self.topBar.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Set statusbar color
    [self.UIPrinciple addTopbarColor:self];
    
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
    NetworkCell *networkCell = [tableView dequeueReusableCellWithIdentifier:@"NetworkCell" forIndexPath:indexPath];
    int row = (int)[indexPath row];
    
    //Setting cell data
    NSDictionary *userDataDictionary = self.userData.userDataArray[row];
    networkCell.networkUserImage.image = [UIImage imageNamed:[userDataDictionary objectForKey:keyImage]];
    
    //Set name
    networkCell.networkUserName.text = [userDataDictionary objectForKey:keyName];
    //Set job
    networkCell.networkUserJob.text = [userDataDictionary objectForKey:keyJob];
    //Set description
    NSString *descriptionText = [userDataDictionary objectForKey:keyDescription];
    networkCell.networkUserDescription.text = descriptionText;
    
    //DESIGN
    //Setting font color of cells to black
    networkCell.networkUserJob.textColor = [UIColor blackColor];
    networkCell.networkUserName.textColor = [UIColor blackColor];
    networkCell.networkUserDescription.textColor = [UIColor blackColor];
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [networkCell setSelectedBackgroundView:bgColorView];
    //Set highlighted color to white
    networkCell.networkUserJob.highlightedTextColor = [UIColor whiteColor];
    networkCell.networkUserName.highlightedTextColor = [UIColor whiteColor];
    networkCell.networkUserDescription.highlightedTextColor = [UIColor whiteColor];
    
    
    return networkCell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"ShowProfileSegue" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

//Hide keyboard when search button pressed
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

@end
