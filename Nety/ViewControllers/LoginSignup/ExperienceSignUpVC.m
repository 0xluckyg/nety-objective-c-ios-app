//
//  ExperienceSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "ExperienceSignUpVC.h"

@interface ExperienceSignUpVC ()
@property (weak, nonatomic) IBOutlet UILabel *letsAddExperienceLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExperienceSignUpVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 4;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.imageView.image = [UIImage imageNamed:@"MainPicture2"];
    
    self.editButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)addButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddExperienceSegue" sender:nil];
}

- (IBAction)editButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddExperienceSegue" sender:false];
}


- (IBAction)skipButtonTapped:(UIButton *)sender {
    self.userData.experiences = [[NSMutableArray alloc] init];
    [self performSegueWithIdentifier:@"ToImageSegue" sender:self];
}

- (IBAction)nextButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ToImageSegue" sender:self];
}


- (void)addExperienceVCDismissedWithExperience: (NSDictionary *)experience {
    [self.userData.experiences addObject:experience];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddExperienceSegue"]) {
        AddExperienceSignUpVC *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"ToImageSegue"]) {
        BaseSignUpViewController *vc = segue.destinationViewController;
        vc.userData = self.userData;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userData.experiences.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *experience = self.userData.experiences[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = experience[kExperienceName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", experience[kExperienceStartDate], experience[kExperienceEndDate]];
    cell.detailTextLabel.text = [cell.detailTextLabel.text isEqualToString:@"-"] ? @"" : cell.detailTextLabel.text;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}



@end

