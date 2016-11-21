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
    
    
}
- (IBAction)addButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddExperienceSegue" sender:self];
}

- (IBAction)editButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddExperienceSegue" sender:self];
}


- (IBAction)skipButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ToImageSegue" sender:self];
}

@end
