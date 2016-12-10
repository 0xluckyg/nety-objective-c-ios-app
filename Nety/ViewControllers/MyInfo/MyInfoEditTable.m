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
    
    MyInfoEditExperience *experienceDataVC = [[MyInfoEditExperience alloc] init];
    [experienceDataVC setDelegate:self];
    
    [self.tableView reloadData];
}

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
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
    self.view.backgroundColor = self.UIPrinciple.netyTheme;
    self.tableView.backgroundColor = self.UIPrinciple.netyTheme;
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = NSLocalizedString(@"myInfoEditTableTitle", nil);
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
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
        NSMutableDictionary *rowData = [NSMutableDictionary dictionary];

        rowData = [self.experienceArray objectAtIndex:indexPath.row];
        
        //Change format of date
        NSString *experienceDate = @"";
        if (![[rowData objectForKey:kExperienceStartDate] isEqualToString:@""]) {
            experienceDate = [NSString stringWithFormat:@"%@ to %@", [rowData objectForKey:kExperienceStartDate], [rowData objectForKey:kExperienceEndDate]];
        }
        
        experienceCell.experienceName.text = [rowData objectForKey: kExperienceName];
        experienceCell.experienceDate.text = experienceDate;
        experienceCell.experienceDescription.text = [rowData objectForKey: kExperienceDescription];
    }
    
    //Set cell style
    experienceCell.backgroundColor = self.UIPrinciple.netyTheme;
    experienceCell.experienceName.textColor = [UIColor whiteColor];
    experienceCell.experienceDate.textColor = [UIColor whiteColor];
    experienceCell.experienceDescription.textColor = [UIColor whiteColor];
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyTheme;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.experienceArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)editButton:(id)sender {
    
    if (editButtonClicked == YES) {
        [self.tableView setEditing:YES animated:YES];
        editButtonClicked = NO;
    } else {
        [self.tableView setEditing:NO animated:YES];
        editButtonClicked = YES;
    }
    
}

- (IBAction)addButton:(id)sender {
    //Indicate that user is going to add an experience instead of editing
    self.add = true;
    
    if ([self.experienceArray count] >= 10) {
        
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"experienceLimitTextTitle", nil) message:NSLocalizedString(@"experienceLimitTextDescription", nil) viewController:self];
        
    } else {
        [self performSegueWithIdentifier:@"experienceDetailSegue" sender:self];
    }
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void)viewWillDisappear:(BOOL)animated {
    
    [self.tableView reloadData];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"experienceDetailSegue"]) {
        
        MyInfoEditTable *experienceDataVC = [segue destinationViewController];
        
        //Indicate that experience is adding, not changing
        experienceDataVC.add = self.add;
        
        experienceDataVC.experienceArray = self.experienceArray;
      
        NSLog(@"exp %@", self.experienceArray);
       
        experienceDataVC.arrayIndex = self.arrayIndex;
     
        NSLog(@"eA %lu", self.arrayIndex);
        
    }
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.experienceArray count]; i ++) {
        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
        [experiences setObject:[self.experienceArray objectAtIndex:i] forKey:experienceKey];
    }
    
    [[[[self.firdatabase child:kUsers] child:MY_USER.userID] child:kExperiences] setValue:experiences];
    
}

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



























