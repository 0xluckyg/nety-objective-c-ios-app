//
//  MyInfo.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfo.h"

@interface MyInfo ()

@end

@implementation MyInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
    
    NSLog(@"%@: got user name on change",[UserInformation getName]);
    NSLog(@"%lu: got user age on change",[UserInformation getAge]);
    NSLog(@"%@: got user status on change",[UserInformation getStatus]);
    NSLog(@"%@: got user summary on change",[UserInformation getSummary]);
    NSLog(@"%@: got user identity on change",[UserInformation getIdentity]);
    NSLog(@"%@: got user identity on change",[UserInformation getExperiences]);
    NSLog(@"%@: got user identity on change",[UserInformation getProfileImage]);
}

- (void)viewWillAppear:(BOOL)animated {
    [self initializeSettings];
}

- (void)initializeSettings {
    
//    self.firdatabase = [[FIRDatabase database] reference];
    
    self.nameLabel.text = [UserInformation getName];
    
    self.identityLabel.text = [UserInformation getIdentity];
    
    if ([[UserInformation getIdentity] isEqualToString:@""]) {
        self.identityLabel.text = @"You haven't described who you are!";
    } else {
        self.identityLabel.text = [UserInformation getIdentity];
    }
    
    if ([[UserInformation getStatus] isEqualToString:@""]) {
        self.userStatusInfo.text = @"You haven't set a status yet!";
    } else {
        self.userStatusInfo.text = [UserInformation getStatus];
    }
    
    if ([[UserInformation getSummary] isEqualToString:@""]) {
        self.userSummaryInfo.text = @"You haven't set a summary yet!";
    } else {
        self.userSummaryInfo.text = [UserInformation getSummary];
    }
    
    self.experienceArray = [UserInformation getExperiences];
    
    NSLog(@"%lu", [self.experienceArray count]);
    
    if ([self.experienceArray count] > 0) {
        
        NSString *experienceString = @"";
        
        for (int i = 0; i < [self.experienceArray count]; i ++) {
            
            NSString *experienceStringAdd = [NSString stringWithFormat:@"%@\r%@ ~ %@\r\r%@\r\r\r",
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceName],
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceStartDate],
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceEndDate],
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceDescription]
                                             ];
            
            NSLog(@"%@", experienceStringAdd);
            
            experienceString = [experienceString stringByAppendingString:experienceStringAdd];
        }
        
        self.userExperienceInfo.text = experienceString;
        
    } else {
        self.userExperienceInfo.text = @"You didn't add any experience or interest yet";
    }
    
    self.userProfileImage.image = [UserInformation getProfileImage];
    
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set background color
    [self.view setBackgroundColor:self.UIPrinciple.netyBlue];
    
    //Profile image setup
    self.userProfileImage.image = [UserInformation getProfileImage];
    
    //Color for the small view
    self.userBasicInfoView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    
    //Color for the big view
    self.userInfoView.backgroundColor = self.UIPrinciple.netyBlue;
    
    self.userInfoViewTopConstraint.constant = self.view.frame.size.height / 2.3;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"myInfoEditTableSegue"]) {
        MyInfoEditTable *editTableVC = [segue destinationViewController];
        
        editTableVC.experienceArray = self.experienceArray;
        
    }
}

@end
