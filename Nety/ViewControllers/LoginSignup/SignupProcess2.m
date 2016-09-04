//
//  SignupProcess2.m
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcess2.h"
#import "MyInfoEditTableCell.h"
#import "AppDelegate.h"
#import "NoContent.h"
#import "SignupProcess3.h"

@interface SignupProcess2 ()

@end

@implementation SignupProcess2


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
        [self.UIPrinciple addNoContent:self setText:@"You haven't added an experience or interest yet" setImage:contentImage setColor:[UIColor whiteColor] setSecondColor:[UIColor whiteColor] noContentController:self.noContentController];
        
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    SignupProcessExperienceDetail *experienceDataVC = [[SignupProcessExperienceDetail alloc] init];
    [experienceDataVC setDelegate:self];
    
    [self.tableView reloadData];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    
    editButtonClicked = YES;
    
    self.experienceArray = [[NSMutableArray alloc] init];
    
    //Table editable
    [self.tableView setEditing:NO animated:NO];
    
    
    NSLog(@"%@, %@, %@, %@, %@, %@, %@", self.userInfo[0], self.userInfo[1], self.userInfo[2], self.userInfo[3] ,self.userInfo[4], self.userInfo[5], self.userInfo[6]);
    
}

- (void)initializeDesign {
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background blue
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.tableView.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Edit and add buttons
    [self.editButtonOutlet setTintColor:[UIColor whiteColor]];
    [self.addButtonOutlet setTintColor:[UIColor whiteColor]];
    
    //No separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
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
        if (![[rowData objectForKey:kExperienceStartDate] isEqualToString:@""]) {
            experienceDate = [NSString stringWithFormat:@"%@ to %@", [rowData objectForKey:kExperienceStartDate], [rowData objectForKey:kExperienceEndDate]];
        }
        
        experienceCell.experienceName.text = [rowData objectForKey: kExperienceName];
        experienceCell.experienceDate.text = experienceDate;
        experienceCell.experienceDescription.text = [rowData objectForKey: kExperienceDescription];
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
        
        [self.UIPrinciple addNoContent:self setText:@"You haven't added an experience or interest yet" setImage:contentImage setColor:[UIColor whiteColor] setSecondColor:[UIColor whiteColor] noContentController:self.noContentController];
        
        
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

- (IBAction)laterButton:(id)sender {
    
    [self performSegueWithIdentifier:@"signupProcess3Segue" sender:self];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void)viewWillDisappear:(BOOL)animated {
    [self.tableView reloadData];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"experienceDetailSegue"]) {
        
        SignupProcessExperienceDetail *experienceDataVC = [segue destinationViewController];
        
        //Indicate that experience is adding, not changing
        experienceDataVC.add = self.add;
        
        experienceDataVC.experienceArray = self.experienceArray;
        
        experienceDataVC.arrayIndex = self.arrayIndex;
        
    } else if ([segue.identifier isEqualToString:@"signupProcess3Segue"]) {
        
        SignupProcess3 *process3 = [segue destinationViewController];
        
        [self.userInfo addObject:self.experienceArray];
        
        process3.userInfo = self.userInfo;
        
    }
    
}


#pragma mark - Custom methods
//---------------------------------------------------------


//Protocol to receive data
-(void)sendExperienceData:(NSMutableArray *)experienceData {
    
    self.experienceArray = experienceData;
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



























