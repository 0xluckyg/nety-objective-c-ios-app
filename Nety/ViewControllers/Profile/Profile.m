//
//  Profile.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Profile.h"
#import "UIPrinciples.h"

@interface Profile ()

@end

@implementation Profile


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
    
    NSLog(@"%@", self.selectedUserInfoDictionary);
    NSLog(@"%@", self.selectedUserID);
    
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Profile image setup
    self.profileImage.image = self.selectedUserProfileImage;
    
    //Color for the small view
    self.basicInfoView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    
    //Color for the big view
    self.infoView.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Chat now buttons styling
    [self.chatNowButtonOutlet setTitle:@"CHAT NOW" forState:UIControlStateNormal];
    self.chatNowButtonOutlet.backgroundColor = [UIColor whiteColor];
    self.chatNowButtonOutlet.tintColor = self.UIPrinciple.netyBlue;
    
    //Info content
    
    NSString *status = [self.selectedUserInfoDictionary objectForKey:kStatus];
    NSString *summary = [self.selectedUserInfoDictionary objectForKey:kSummary];
    NSArray *experiences = [[self.selectedUserInfoDictionary objectForKey:kExperiences] allValues];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [self.selectedUserInfoDictionary objectForKey:kFirstName], [self.selectedUserInfoDictionary objectForKey:kLastName]];
    
    self.nameInfo.text = name;
    self.identityInfo.text = [self.selectedUserInfoDictionary objectForKey:kIdentity];
    
    if ([status isEqualToString:@""]) {
        self.statusInfo.text = @"No status";
    } else {
        self.statusInfo.text = status;
    }
    
    if ([summary isEqualToString:@""]) {
        self.summaryInfo.text = @"No summary";
    } else {
        self.summaryInfo.text = summary;
    }
    
    if (experiences) {
        NSString *experienceString = @"";
        
        for (int i = 0; i < [experiences count]; i ++) {
            
            NSString *experienceStringAdd = [NSString stringWithFormat:@"%@\r%@ ~ %@\r\r%@\r\r\r",
                                             [[experiences objectAtIndex:i] objectForKey:kExperienceName],
                                             [[experiences objectAtIndex:i] objectForKey:kExperienceStartDate],
                                             [[experiences objectAtIndex:i] objectForKey:kExperienceEndDate],
                                             [[experiences objectAtIndex:i] objectForKey:kExperienceDescription]
                                             ];
            
            experienceString = [experienceString stringByAppendingString:experienceStringAdd];
        }
        
        self.experienceInfo.text = experienceString;
        
    } else {
        
        self.experienceInfo.text = @"No experiences";
        
    }
    
    self.infoViewTopConstraint.constant = self.view.frame.size.height / 2.3;
    
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------





#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chatNowButton:(id)sender {
    

    
    [self performSegueWithIdentifier:@"MessagesSegue" sender:self];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------






//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
