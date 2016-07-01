//
//  MyInfoEditTable.m
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditTable.h"
#import "MyInfoEditTableCell.h"

@interface MyInfoEditTable ()

@end

@implementation MyInfoEditTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)initializeSettings {
    
    editButtonClicked = YES;
    
    self.experienceData = [[NetworkData alloc] init];
    
    [self.tableView setEditing:NO animated:NO];
}

- (void)initializeDesign {
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Edit and add buttons
    [self.editButtonOutlet setTintColor:self.UIPrinciple.netyBlue];
    [self.addButtonOutlet setTintColor:self.UIPrinciple.netyBlue];
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Topbar and navbar colors to blue
    self.topBar.backgroundColor = self.UIPrinciple.netyBlue;
    self.navBar.backgroundColor = self.UIPrinciple.netyBlue;
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.experienceData.userExperienceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Initialize cell
    MyInfoEditTableCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoEditTableCell"];
    
    //Set cell data
    NSDictionary *rowData = [self.experienceData.userExperienceArray objectAtIndex:indexPath.row];
    experienceCell.experienceName.text = [rowData objectForKey: keyExperienceName];
    experienceCell.experienceDate.text = [rowData objectForKey: keyExperienceTime];
    experienceCell.experienceDescription.text = [rowData objectForKey: keyExperienceDescription];
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [experienceCell setSelectedBackgroundView:bgColorView];
    //Set highlighted color to white
    experienceCell.experienceName.highlightedTextColor = [UIColor whiteColor];
    experienceCell.experienceDate.highlightedTextColor = [UIColor whiteColor];
    experienceCell.experienceDescription.highlightedTextColor = [UIColor whiteColor];
    
    
    return experienceCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Move to editing cell
    [self performSegueWithIdentifier:@"experienceDetailSegue" sender:self];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)editButton:(id)sender {
    
    if (editButtonClicked == YES) {
        [self.tableView setEditing:YES animated:YES];
        [self.editButtonOutlet setTitle:@"Done" forState:UIControlStateNormal];
        editButtonClicked = NO;
    } else {
        [self.tableView setEditing:NO animated:NO];
        [self.editButtonOutlet setTitle:@"Edit" forState:UIControlStateNormal];
        editButtonClicked = YES;
    }
    
}

- (IBAction)addButton:(id)sender {
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleNone;
//}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.experienceData.userExperienceArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end



























