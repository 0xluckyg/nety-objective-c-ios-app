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
    
    self.firdatabase = [[FIRDatabase database] reference];
    self.senderId = MY_USER.userID;
    self.senderDisplayName = [NSString stringWithFormat:@"%@ %@",MY_USER.firstName, MY_USER.lastName];
    
    if (![self.selectedUser.security isEqual:@(3)]) {
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
        
        if ([self.selectedUser.security isEqual:@(2)]) {
            [cell.buttonOutlet setTitle:@"Send a chat request!" forState:UIControlStateNormal];
        } else {
            [cell.buttonOutlet setTitle:@"Chat now!" forState:UIControlStateNormal];
        }
        
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
        Experiences* expir = [[self.selectedUser.experiences allObjects] objectAtIndex:indexPath.row-8];
        
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
    
    if ([self.selectedUser.security isEqual:@(2)]) {
    
        NSString *chatRequestText = [NSString stringWithFormat:@"%@ sent a chat request", self.senderDisplayName];
        NSString *chatRequestTextFromMyUser = @"You sent a chat request";
        
        NSMutableDictionary *chatRoomInformation = [self makeChatRoomID];
        
        NSNumber *secondsSince1970 = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970] * -1];
        
        //Room setup
        [[[self.firdatabase child:kChatRooms] child:self.chatroomID] setValue:chatRoomInformation];
        
        //Add information to both the user and selected user
        FIRDatabaseReference *userChatRoomRef = [[[[[self firdatabase] child:kUserChats] child:self.senderId] child:kChats] child:self.chatroomID];
        [[[userChatRoomRef child:kMembers] child:@"member1"] setValue:self.selectedUserID];
        [[userChatRoomRef child:kRecentMessage] setValue:chatRequestText];
        [[userChatRoomRef child:kType] setValue:@0];
        [[userChatRoomRef child:kUnread] setValue:@1];
        [userChatRoomRef updateChildValues:@{kUpdateTime:secondsSince1970}];
        
        FIRDatabaseReference *selectedUserChatRoomRef = [[[[[self firdatabase] child:kUserChats] child:self.selectedUserID] child:kChats] child:self.chatroomID];
        [[[selectedUserChatRoomRef child:kMembers] child:@"member1"] setValue:self.senderId];
        [[selectedUserChatRoomRef child:kRecentMessage] setValue:chatRequestTextFromMyUser];
        [[selectedUserChatRoomRef child:kType] setValue:@0];
        [[selectedUserChatRoomRef child:kUnread] setValue:@0];
        [selectedUserChatRoomRef updateChildValues:@{kUpdateTime:secondsSince1970}];
        
        NSDictionary *messageData = @{ kSenderId: self.senderId,
                                       kSenderDisplayName: self.senderDisplayName,
                                       kDate: secondsSince1970,
                                       kText: chatRequestText};
        
        FIRDatabaseReference *messageRef = [[[self.firdatabase child:kChatRooms] child:self.chatroomID] child:kMessages ];
        [[messageRef childByAutoId] setValue:messageData];
        
    } else {
        
        UIStoryboard *messagesStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
        Messages *messagesVC = [messagesStoryboard instantiateViewControllerWithIdentifier:@"Messages"];
        
        messagesVC.selectedUserID = _selectedUser.userID;
        messagesVC.selectedUserProfileImageString = _selectedUser.profileImageUrl;
        messagesVC.selectedUserName = [NSString stringWithFormat:@"%@ %@", _selectedUser.firstName, _selectedUser.lastName];
        
        [self.navigationController pushViewController:messagesVC animated:YES];
    }

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

- (NSMutableDictionary *)makeChatRoomID {
    
    //Making a room
    NSComparisonResult result = [self.senderId compare:self.selectedUserID];
    NSMutableDictionary *chatRoomInformation;
    NSNumber *secondsSince1970 = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970] * -1];
    
    if (result == NSOrderedAscending) {
        
        self.chatroomID = [NSString stringWithFormat:@"%@%@", self.senderId, self.selectedUserID];
        
        chatRoomInformation = [[NSMutableDictionary alloc] initWithDictionary: @{kCreated: secondsSince1970,
                                                                                 kMembers: @{
                                                                                         @"member1": self.senderId,
                                                                                         @"member2": self.selectedUserID}}];
        
        
    } else {
        
        self.chatroomID = [NSString stringWithFormat:@"%@%@", self.selectedUserID, self.senderId];
        chatRoomInformation = [[NSMutableDictionary alloc] initWithDictionary: @{kCreated: secondsSince1970,
                                                                                 kMembers: @{
                                                                                         @"member1": self.selectedUserID,
                                                                                         @"member2": self.senderId}}];
        
    }
    
    return chatRoomInformation;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:MY_API.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userID == %@",_selectedUserID];
    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userID" ascending:YES];
    
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

@end
