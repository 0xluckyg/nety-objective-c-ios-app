//
//  MyInfoEditTable.m
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditTable.h"


@interface MyInfoEditTable ()

@end

@implementation MyInfoEditTable


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //If no experiences visible, show noContent header
    if ([self.experienceArray count] == 0) {
        
        self.experienceArray = [[NSMutableArray alloc] init];
        
        self.noContentController = [[NoContent alloc] init];
        
        UIImage *contentImage = [[UIImage imageNamed:@"LightBulb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self.UIPrinciple addNoContent:self setText:@"You haven't added an experience or interest yet" setImage:contentImage setColor:self.UIPrinciple.netyGray noContentController:self.noContentController];
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    MyInfoEditExperience *experienceDataVC = [[MyInfoEditExperience alloc] init];
    [experienceDataVC setDelegate:self];
    
    [self.tableView reloadData];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    
    editButtonClicked = YES;
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    [self.tableView setEditing:NO animated:NO];
}

- (void)initializeDesign {
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background blue
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.tableView.backgroundColor = self.UIPrinciple.netyBlue;
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.experienceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Initialize cell
    MyInfoEditTableCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoEditTableCell"];
    
    
    if ([self.experienceArray count] != 0) {
        
        //Set cell data
        NSDictionary *rowData = [self.experienceArray objectAtIndex:indexPath.row];
        //Change format of date
        NSString *experienceDate = @"";
        if (![[rowData objectForKey:@"startDate"] isEqualToString:@""]) {
            experienceDate = [NSString stringWithFormat:@"%@ to %@", [rowData objectForKey:@"startDate"], [rowData objectForKey:@"endDate"]];
        }
        
        experienceCell.experienceName.text = [rowData objectForKey: @"name"];
        experienceCell.experienceDate.text = experienceDate;
        experienceCell.experienceDescription.text = [rowData objectForKey: @"description"];
    }
    
    //Set cell style
    experienceCell.backgroundColor = self.UIPrinciple.netyBlue;
    experienceCell.experienceName.textColor = [UIColor whiteColor];
    experienceCell.experienceDate.textColor = [UIColor whiteColor];
    experienceCell.experienceDescription.textColor = [UIColor whiteColor];
    
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
    self.add = false;
    self.arrayIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"experienceDetailSegue" sender:self];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.experienceArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.experienceArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if ([self.experienceArray count] == 0) {
        
        //If deleted and array is 0
        self.noContentController = [[NoContent alloc] init];
        
        UIImage *contentImage = [UIImage imageNamed:@"LightBulb"];
        
        [self.UIPrinciple addNoContent:self setText:@"You haven't added an experience or interest yet" setImage:contentImage setColor:self.UIPrinciple.netyGray noContentController:self.noContentController];
    }
    
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButton:(id)sender {
    
    if (editButtonClicked == YES) {
        [self.tableView setEditing:YES animated:YES];
        editButtonClicked = NO;
    } else {
        [self.tableView setEditing:NO animated:NO];
        editButtonClicked = YES;
    }
    
}

- (IBAction)addButton:(id)sender {
    //Indicate that user is going to add an experience instead of editing
    self.add = true;
    
    [self performSegueWithIdentifier:@"experienceDetailSegue" sender:self];
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void)viewWillDisappear:(BOOL)animated {
    
    [self.tableView reloadData];
    
    
    //Save locally
    
    //Save to database
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.experienceArray count]; i ++) {
        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
        [experiences setObject:[self.experienceArray objectAtIndex:i] forKey:experienceKey];
    }
    
    [[[[self.firdatabase child:kUsers] child:MY_USER.userID] child:kExperiences] setValue:experiences];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"experienceDetailSegue"]) {
        
        MyInfoEditTable *experienceDataVC = [segue destinationViewController];
        
        //Indicate that experience is adding, not changing
        experienceDataVC.add = self.add;
        
        experienceDataVC.experienceArray = self.experienceArray;
        
        experienceDataVC.arrayIndex = self.arrayIndex;
        
    }
}


#pragma mark - Custom methods
//---------------------------------------------------------


//To receive data
-(void)sendExperienceData:(NSMutableArray *)experienceData {
    
    self.experienceArray = experienceData;
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



























