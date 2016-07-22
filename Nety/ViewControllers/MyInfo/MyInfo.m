//
//  MyInfo.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfo.h"
#import "UIPrinciples.h"
#import "Constants.h"
#import "SingletonUserData.h"

@interface MyInfo ()

@end

@implementation MyInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSettings];
    [self initializeDesign];

}

- (void)initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    SingletonUserData *singletonUserData = [SingletonUserData sharedInstance];
    NSLog(@"%@", singletonUserData.userID);
    
    [[[self.firdatabase child:kUsers] child:singletonUserData.userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        
        NSLog(@"%@", snapshot);
        
        self.userData = snapshot.value;
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", [self.userData objectForKey:kFirstName], [self.userData objectForKey:kLastName], [self.userData objectForKey:kAge]];
        
        self.identityLabel.text = [self.userData objectForKey:kIdentity];
        
        if ([[self.userData objectForKey:kStatus] isEqualToString:@""]) {
            self.userStatusInfo.text = @"You haven't set a status yet!";
        } else {
            self.userStatusInfo.text = [self.userData objectForKey:kStatus];
        }
        
        self.userSummaryInfo.text = [self.userData objectForKey:kSummary];
        
        if ([self.userData objectForKey:kExperiences]) {
            
            NSLog(@"%lu", [[self.userData objectForKey:kExperiences] count]);
            
            self.experienceArray = [[NSMutableArray alloc] initWithArray:[[self.userData objectForKey:kExperiences] allValues]];
            
            NSLog(@"%lu", [self.experienceArray count]);
            
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
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        
    }];
    
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set background color
    [self.view setBackgroundColor:self.UIPrinciple.netyBlue];
    
    //Profile image setup
    self.userProfileImage.image = [UIImage imageNamed:@"girl2.jpg"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
