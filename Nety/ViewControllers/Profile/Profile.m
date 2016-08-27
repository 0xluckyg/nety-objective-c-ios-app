//
//  Profile.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Profile.h"
#import "Experiences.h"

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
    
    if (![self.selectedUser.security isEqualToString:@"3"]) {
        numberOfComponents = 8 + (int)[[self.selectedUser.experiences allObjects] count];
    } else {
        numberOfComponents = 7 + (int)[[self.selectedUser.experiences allObjects] count];
    }
    
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", _selectedUser.firstName, _selectedUser.lastName];
    
    NSLog(@"%@", self.selectedUser);
    
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
    float height = self.view.frame.size.height / 2.2;
    
    [profileImageView setFrame:CGRectMake(0, 0, width, height)];
    [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.tableView addParallaxWithView:profileImageView andHeight:height];
    [self.tableView.parallaxView setDelegate:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:NO];
    
    //Configure tableview height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return numberOfComponents;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int normalNumberOfCells = 8 + (int)[[self.selectedUser.experiences allObjects] count];
    int indexCount = numberOfComponents - normalNumberOfCells;
    
    if (indexPath.row == indexCount + 1 || indexPath.row == indexCount + 5 || indexPath.row == indexCount + 6) {
        return 10;
    } else {
        return UITableViewAutomaticDimension;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int normalNumberOfCells = 8 + (int)[[self.selectedUser.experiences allObjects] count];
    int indexCount = numberOfComponents - normalNumberOfCells;
    
    NSString *status = self.selectedUser.status;
    NSString *summary = self.selectedUser.summary;
    NSString *identity = self.selectedUser.identity;
    NSArray *experiences = [self.selectedUser.experiences allObjects];
    
    if (indexPath.row == indexCount) {
        ChatButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatButtonCell" forIndexPath:indexPath];
        
        [cell.buttonOutlet setTitle:@"Chat Now!" forState:UIControlStateNormal];
        
        return cell;
    } else if (indexPath.row == indexCount + 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpaceCell" forIndexPath:indexPath];
        
        return cell;
        
    } else if (indexPath.row >= indexCount + 2 && indexPath.row <= indexCount + 4) {
        
        MainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainInfoCell" forIndexPath:indexPath];
        
        cell.mainInfoLabel.textColor = self.UIPrinciple.netyBlue;
        
        [cell.mainInfoImage setTintColor:self.UIPrinciple.netyBlue];
        
        int one = indexCount + 2;
        int two = indexCount + 3;
        int three = indexCount + 4;
        
        if (indexPath.row == one) {
            cell.mainInfoImage.image = [[UIImage imageNamed:@"Identity"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            if ([identity isEqualToString:@""]) {
                cell.mainInfoLabel.text = @"No description";
            } else {
                cell.mainInfoLabel.text = identity;
            }
        } else if (indexPath.row == two) {
            cell.mainInfoImage.image = [[UIImage imageNamed:@"Status"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            if ([status isEqualToString:@""]) {
                cell.mainInfoLabel.text = @"No status";
            } else {
                cell.mainInfoLabel.text = status;
            }
        } else if (indexPath.row == three){
            cell.mainInfoImage.image = [[UIImage imageNamed:@"Summary"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            if ([summary isEqualToString:@""]) {
                cell.mainInfoLabel.text = @"No summary";
            } else {
                cell.mainInfoLabel.text = summary;
            }
        }

        return cell;
        
    } else if (indexPath.row >= indexCount + 5 && indexPath.row <= indexCount + 6) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpaceCell" forIndexPath:indexPath];
        
        if (indexPath.row == 5) {
            
            float cellHeight = cell.contentView.frame.size.height;
            float cellWidth = cell.contentView.frame.size.width;
            
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 1, cellWidth, 1)];/// change size as you need.
            separatorLineView.backgroundColor = self.UIPrinciple.netyBlue;
            [cell.contentView addSubview:separatorLineView];
            
        }
        
        return cell;
        
    } else if (indexPath.row == indexCount + 7) {
        
        MainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainInfoCell" forIndexPath:indexPath];
        
        cell.mainInfoImage.image = [[UIImage imageNamed:@"LightBulbSmall"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [cell.mainInfoImage setTintColor:self.UIPrinciple.netyBlue];
        
        cell.mainInfoLabel.textColor = self.UIPrinciple.netyBlue;
        
        if ([experiences count] == 0) {
            cell.mainInfoLabel.text = @"No experiences";
        } else {
            cell.mainInfoLabel.text = @"Experiences";
        }
        
        return cell;
        
    } else {
        
        ExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExperienceCell" forIndexPath:indexPath];
        Experiences* expir = [[self.selectedUser.experiences allObjects] objectAtIndex:indexPath.row-7];
        
        NSLog(@"Ex: %@",expir);
        
        cell.experienceName.textColor = self.UIPrinciple.netyBlue;
        cell.experienceDate.textColor = self.UIPrinciple.netyBlue;
        cell.experienceDescription.textColor = self.UIPrinciple.netyBlue;
        
        cell.experienceName.text = expir.name;
        cell.experienceDate.text = expir.endDate;
        
        cell.experienceDescription.text = expir.descript;
        return cell;
        
    }
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
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
