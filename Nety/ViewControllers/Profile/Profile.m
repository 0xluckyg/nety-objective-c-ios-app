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
}


#pragma mark - Initialization
//---------------------------------------------------------

- (void)initializeSettings {
    
//    self.imageCache = [[NSCache alloc] init];
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Info content
    NSString *status = _selectedUser.status;
    NSString *summary = _selectedUser.summary;
    NSArray *experiences = [MY_USER.experiences allObjects];
    NSString *name = [NSString stringWithFormat:@"%@ %@", _selectedUser.firstName, _selectedUser.lastName];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = name;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    NSString *photoUrl = _selectedUser.profileImageUrl;
    UIImageView *profileImageView = [[UIImageView alloc] init];
    
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        [profileImageView sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    } else {
        profileImageView.image = [UIImage imageNamed:kDefaultUserLogoName];
    }
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height / 2.5;
    
    [profileImageView setFrame:CGRectMake(0, 0, width, height)];
    [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.tableView addParallaxWithView:profileImageView andHeight:height];
    
    [self.tableView.parallaxView setDelegate:self];
    
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatButton *networkCell = [tableView dequeueReusableCellWithIdentifier:@"statusOrSummary" forIndexPath:indexPath];
    
    return networkCell;
}

#pragma mark - Buttons
//---------------------------------------------------------

- (IBAction)chatNowButton:(id)sender {
    
    
    UIStoryboard *messagesStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
    Messages *messagesVC = [messagesStoryboard instantiateViewControllerWithIdentifier:@"Messages"];
    
    messagesVC.selectedUserID = _selectedUser.userID;
    messagesVC.selectedUserProfileImageString = _selectedUser.profileImageUrl;
    messagesVC.selectedUserName = [NSString stringWithFormat:@"%@ %@", _selectedUser.firstName, _selectedUser.lastName];
    
    [self.navigationController pushViewController:messagesVC animated:YES];

}


#pragma mark - View Disappear
//---------------------------------------------------------

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Custom methods
//---------------------------------------------------------


-(void) backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.tabBarController.tabBar.hidden = NO;
    [self.UIPrinciple setTabBarVisible:![self.UIPrinciple tabBarIsVisible:self] animated:YES sender:self completion:^(BOOL finished) {
        NSLog(@"animation done");
        
    }];
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
