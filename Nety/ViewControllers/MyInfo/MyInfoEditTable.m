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

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
//    if (self.fromMyInfo) {
//        
//        for (int i = 0; i < experiencesCount; i ++) {
//            
//            Experiences* expir = [[MY_USER.experiences allObjects] objectAtIndex:i];
//            
//            NSDictionary *expirDictionary = @{kExperienceName:expir.name,
//                                              kExperienceStartDate: expir.startDate,
//                                              kExperienceEndDate: expir.endDate,
//                                              kExperienceDescription: expir.descript};
//            
//            [self.experienceArray addObject:expirDictionary];
//            
//            NSLog(@"created, %lu", (long)experiencesCount);
//            
//        }
//    }
    
    
    MyInfoEditExperience *experienceDataVC = [[MyInfoEditExperience alloc] init];
    [experienceDataVC setDelegate:self];
    
}

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
//    
//    self.experienceArray = [[NSMutableArray alloc] init];
    
    self.noContentController = [[NoContent alloc] init];
    
    editButtonClicked = YES;
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    [self.table setEditing:NO animated:NO];
}

- (void)initializeDesign {
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Background blue
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.table.backgroundColor = self.UIPrinciple.netyBlue;
    
    //No separator
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.experienceArray count];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Initialize cell
    MyInfoEditTableCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoEditTableCell"];
    
    [self configureCell:experienceCell withObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
    
    return experienceCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Move to editing cell
//    self.add = false;
//    self.arrayIndex = indexPath.row;
    
    MyInfoEditExperience *experienceDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditExperience"];
    
//    experienceDataVC.experienceArray = self.experienceArray;
//    experienceDataVC.add = self.add;
//    experienceDataVC.arrayIndex = indexPath.row;
    
    [self.navigationController pushViewController:experienceDataVC animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    [self.experienceArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.experienceArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if ([_fetchedResultsController fetchedObjects].count == 0) {
        
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
        [self.table setEditing:YES animated:YES];
        editButtonClicked = NO;
    } else {
        [self.table setEditing:NO animated:NO];
        editButtonClicked = YES;
    }
    
}

- (IBAction)addButton:(id)sender {
    //Indicate that user is going to add an experience instead of editing
//    self.add = true;
    
    MyInfoEditExperience *experienceDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditExperience"];
    
//    experienceDataVC.experienceArray = self.experienceArray;
//    experienceDataVC.add = self.add;
    
    [self.navigationController pushViewController:experienceDataVC animated:YES];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [self.tableView reloadData];
//    
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"experienceDetailSegue"]) {
        
        MyInfoEditTable *experienceDataVC = [segue destinationViewController];
        
        //Indicate that experience is adding, not changing
//        experienceDataVC.add = self.add;
//        
//        experienceDataVC.experienceArray = self.experienceArray;
//        
//        experienceDataVC.arrayIndex = self.arrayIndex;
        
    }
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void) backButtonPressed {
    
    //Save to database
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    
    //Delete
//    NSMutableSet *mutableSet = [NSMutableSet setWithSet:MY_USER.experiences];
//    [mutableSet removeAllObjects];
//    MY_USER.experiences = mutableSet;
//    NSArray *allExperiences = [MY_USER.experiences allObjects];
//    for (id object in allExperiences) {
//        [MY_USER.managedObjectContext deleteObject:object];
//    }
//    [MY_USER.managedObjectContext save:nil];
//    
//    for (int i = 0; i < [self.experienceArray count]; i ++) {
//        
//        NSDictionary *experienceDict = [self.experienceArray objectAtIndex:i];
//        
//        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
//        [experiences setObject:experienceDict forKey:experienceKey];
//        
//        Experiences* expir = [NSEntityDescription insertNewObjectForEntityForName:@"Experiences" inManagedObjectContext:MY_USER.managedObjectContext];
//        for (NSString* keyExp in experienceDict) {
//            if ([keyExp isEqualToString:@"description"])
//            {
//                [expir setValue:[experienceDict objectForKey:keyExp] forKey:@"descript"];
//            }
//            else
//            {
//                [expir setValue:[experienceDict objectForKey:keyExp] forKey:keyExp];
//            }
//        }
//        
//    }
    
//    NSLog(@"count %lu",[[MY_USER.experiences allObjects] count]);
    
    [[[[self.firdatabase child:kUsers] child:_user.userID] child:kExperiences] setValue:experiences];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//To receive data
-(void)sendExperienceData:(NSMutableArray *)experienceData {
    
//    self.experienceArray = experienceData;
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CoreData
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiences" inManagedObjectContext:MY_API.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"user == %@",_user];
    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MY_API.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)configureCell:(MyInfoEditTableCell*)cell withObject:(Experiences*)object
{
    //Change format of date
    NSString *experienceDate = @"";
    NSString *startDate = object.startDate;
    NSString *endDate = object.endDate;
    NSString *name = object.name;
    NSString *description = object.descript;
    
    if (![startDate isEqualToString:@""]) {
        experienceDate = [NSString stringWithFormat:@"%@ to %@", startDate, endDate];
    }
    
    cell.experienceName.text = name;
    cell.experienceDate.text = experienceDate;
    cell.experienceDescription.text = description;
    
    //Set cell style
    cell.backgroundColor = self.UIPrinciple.netyBlue;
    cell.experienceName.textColor = [UIColor whiteColor];
    cell.experienceDate.textColor = [UIColor whiteColor];
    cell.experienceDescription.textColor = [UIColor whiteColor];
    
    //Set selection color to blue
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.UIPrinciple.netyBlue;
    [cell setSelectedBackgroundView:bgColorView];
    
    //Set highlighted color to white
    cell.experienceName.highlightedTextColor = [UIColor whiteColor];
    cell.experienceDate.highlightedTextColor = [UIColor whiteColor];
    cell.experienceDescription.highlightedTextColor = [UIColor whiteColor];
}
#pragma mark - 

@end



























