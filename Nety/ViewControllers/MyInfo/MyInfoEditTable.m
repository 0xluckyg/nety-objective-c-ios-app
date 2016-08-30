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
    NSInteger experiencesCount = [[MY_USER.experiences allObjects] count];
    
    if (experiencesCount == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"LightBulb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self.UIPrinciple addNoContent:self setText:@"You haven't added an experience or interest yet" setImage:contentImage setColor:[UIColor whiteColor] setSecondColor:[UIColor whiteColor] noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
        
    }
    
    if (self.fromMyInfo) {
        
        for (int i = 0; i < experiencesCount; i ++) {
            
            Experiences* expir = [[MY_USER.experiences allObjects] objectAtIndex:i];
            
            NSDictionary *expirDictionary = @{kExperienceName:expir.name,
                                              kExperienceStartDate: expir.startDate,
                                              kExperienceEndDate: expir.endDate,
                                              kExperienceDescription: expir.descript};
            
            [self.experienceArray addObject:expirDictionary];
            
            NSLog(@"created, %lu", experiencesCount);
            
        }
    }
    
    
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
    
    self.experienceArray = [[NSMutableArray alloc] init];
    
    self.noContentController = [[NoContent alloc] init];
    
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
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = @"Add an experience";
    
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
    
    NSDictionary* expir = [self.experienceArray objectAtIndex:indexPath.row];
    
    //Initialize cell
    MyInfoEditTableCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoEditTableCell"];
    
    
    if ([self.experienceArray count] != 0) {
        
        //Change format of date
        NSString *experienceDate = @"";
        NSString *startDate = [expir objectForKey:kExperienceStartDate];
        NSString *endDate = [expir objectForKey:kExperienceEndDate];
        NSString *name = [expir objectForKey:kExperienceName];
        NSString *description = [expir objectForKey:kExperienceDescription];
        if (![startDate isEqualToString:@""]) {
            experienceDate = [NSString stringWithFormat:@"%@ to %@", startDate, endDate];
        }
        
        experienceCell.experienceName.text = name;
        experienceCell.experienceDate.text = experienceDate;
        experienceCell.experienceDescription.text = description;
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
    
    MyInfoEditExperience *experienceDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditExperience"];
    
    experienceDataVC.experienceArray = self.experienceArray;
    experienceDataVC.add = self.add;
    experienceDataVC.arrayIndex = indexPath.row;
    
    [self.navigationController pushViewController:experienceDataVC animated:YES];
    
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
    
    if ([[MY_USER.experiences allObjects] count] == 0) {
        
        //If deleted and array is 0
        self.noContentController = [[NoContent alloc] init];
        
        UIImage *contentImage = [UIImage imageNamed:@"LightBulb"];
        
        [self.UIPrinciple addNoContent:self setText:@"You haven't added an experience or interest yet" setImage:contentImage setColor:self.UIPrinciple.netyGray setSecondColor:self.UIPrinciple.defaultGray noContentController:self.noContentController];
    }
    
}


#pragma mark - Buttons
//---------------------------------------------------------


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
    
    MyInfoEditExperience *experienceDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditExperience"];
    
    experienceDataVC.experienceArray = self.experienceArray;
    experienceDataVC.add = self.add;
    
    [self.navigationController pushViewController:experienceDataVC animated:YES];
    
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
        
        experienceDataVC.arrayIndex = self.arrayIndex;
        
    }
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void) backButtonPressed {
    
    //Save to database
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    
    //Delete
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:MY_USER.experiences];
    [mutableSet removeAllObjects];
    MY_USER.experiences = mutableSet;
    NSArray *allExperiences = [MY_USER.experiences allObjects];
    for (id object in allExperiences) {
        [MY_USER.managedObjectContext deleteObject:object];
    }
    [MY_USER.managedObjectContext save:nil];
    
    for (int i = 0; i < [self.experienceArray count]; i ++) {
        
        NSDictionary *experienceDict = [self.experienceArray objectAtIndex:i];
        
        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
        [experiences setObject:experienceDict forKey:experienceKey];
        
        Experiences* expir = [NSEntityDescription insertNewObjectForEntityForName:@"Experiences" inManagedObjectContext:MY_USER.managedObjectContext];
        for (NSString* keyExp in experienceDict) {
            if ([keyExp isEqualToString:@"description"])
            {
                [expir setValue:[experienceDict objectForKey:keyExp] forKey:@"descript"];
            }
            else
            {
                [expir setValue:[experienceDict objectForKey:keyExp] forKey:keyExp];
            }
        }
        
    }
    
//    NSLog(@"count %lu",[[MY_USER.experiences allObjects] count]);
    
    [[[[self.firdatabase child:kUsers] child:MY_USER.userID] child:kExperiences] setValue:experiences];
    
    [self.navigationController popViewControllerAnimated:YES];
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



























