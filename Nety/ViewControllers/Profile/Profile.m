//
//  Profile.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Profile.h"
#import "UIPrinciples.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Profile ()

@end

@implementation Profile


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"view load");
    
    [self initializeSettings];
    [self initializeDesign];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


#pragma mark - Initialization
//---------------------------------------------------------

- (void)initializeSettings {
    
//    self.imageCache = [[NSCache alloc] init];
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    NSString *photoUrl = _selectedUser.profileImageUrl;
    
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        //[self loadAndCacheImage: profileImageUrl cache:self.imageCache];
        [_profileImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    } else {
        self.profileImage.image = [UIImage imageNamed:kDefaultUserLogoName];
    }
    
    self.profileImage.layer.masksToBounds = YES;
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    
    //self.profileImage.image = [UIImage imageNamed:kDefaultUserLogoName];
    
    //Color for the small view
    self.basicInfoView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    
    //Color for the big view
    self.infoView.backgroundColor = self.UIPrinciple.netyBlue;
    
    //Chat now buttons styling
    [self.chatNowButtonOutlet setTitle:@"CHAT NOW" forState:UIControlStateNormal];
    self.chatNowButtonOutlet.backgroundColor = [UIColor whiteColor];
    self.chatNowButtonOutlet.tintColor = self.UIPrinciple.netyBlue;
    
    //Info content
    
    NSString *status = _selectedUser.status;
    NSString *summary = _selectedUser.summary;
    NSArray *experiences = [MY_USER.experiences allObjects];
    NSString *name = [NSString stringWithFormat:@"%@ %@", _selectedUser.firstName, _selectedUser.lastName];
    
    self.nameInfo.text = name;
    self.identityInfo.text = _selectedUser.identity;
    
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
    [self.navigationController popViewControllerAnimated:YES];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.tabBarController.tabBar.hidden = NO;
    [self.UIPrinciple setTabBarVisible:![self.UIPrinciple tabBarIsVisible:self] animated:YES sender:self completion:^(BOOL finished) {
        NSLog(@"animation done");

    }];
}

- (IBAction)chatNowButton:(id)sender {
    
    
    UIStoryboard *messagesStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
    Messages *messagesVC = [messagesStoryboard instantiateViewControllerWithIdentifier:@"Messages"];
    
    messagesVC.selectedUserID = _selectedUser.userID;
    messagesVC.selectedUserProfileImageString = _selectedUser.profileImageUrl;
    messagesVC.selectedUserName = [NSString stringWithFormat:@"%@ %@", _selectedUser.firstName, _selectedUser.lastName];
    
    [self.navigationController pushViewController:messagesVC animated:YES];

}

- (IBAction)swipeDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - View Disappear
//---------------------------------------------------------

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - Custom methods
//---------------------------------------------------------

//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
