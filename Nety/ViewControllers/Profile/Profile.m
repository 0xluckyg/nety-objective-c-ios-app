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
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = name;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Report" style:UIBarButtonItemStylePlain target:self action:@selector(reportUser)];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:                                    [self.UIPrinciple netyFontWithSize:18]
       }
     forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
            [cell.buttonOutlet setTitle:NSLocalizedString(@"chatRequest", nil) forState:UIControlStateNormal];
        } else {
            [cell setBackgroundColor:self.UIPrinciple.netyBlue];
            [cell.buttonOutlet setTitle:NSLocalizedString(@"chatNow", nil) forState:UIControlStateNormal];
            cell.buttonOutlet.tintColor = [UIColor whiteColor];
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
                cell.mainInfoLabel.text = NSLocalizedString(@"noDescription", nil);
            } else {
                cell.mainInfoLabel.text = identity;
            }
        } else if (indexPath.row == two) {
            cell.mainInfoImage.image = [[UIImage imageNamed:@"Status"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            if ([status isEqualToString:@""]) {
                cell.mainInfoLabel.text = NSLocalizedString(@"noStatus", nil);
            } else {
                cell.mainInfoLabel.text = status;
            }
        } else if (indexPath.row == three){
            cell.mainInfoImage.image = [[UIImage imageNamed:@"Summary"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            if ([summary isEqualToString:@""]) {
                cell.mainInfoLabel.text = NSLocalizedString(@"noSummary", nil);
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
            
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 2, cellWidth, 0.3)];/// change size as you need.
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
            cell.mainInfoLabel.text = NSLocalizedString(@"noExperience", nil);
        } else {
            cell.mainInfoLabel.text = NSLocalizedString(@"experiences", nil);
        }
        
        return cell;
        
    } else {
        
        ExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExperienceCell" forIndexPath:indexPath];
        
        NSArray *experiences = [self.selectedUser.experiences allObjects];
        
        experiences = [experiences sortedArrayUsingComparator:^NSComparisonResult(Experiences *a, Experiences *b) {
            
            if ([a.endDate isEqualToString:@"Present"]) {
                return -1;
            } else if ([b.endDate isEqualToString:@"Present"]) {
                return 1;
            } else {
                NSArray *aArray = [a.endDate componentsSeparatedByString:@"/"];
                NSArray *bArray = [b.endDate componentsSeparatedByString:@"/"];
                
                NSComparisonResult yearCompare = [[aArray lastObject] compare:[bArray lastObject]];
                if (yearCompare == 0) {
                    NSComparisonResult monthCompare = [[aArray objectAtIndex:0] compare:[bArray objectAtIndex:0]];
                    if (monthCompare == 0) {
                        NSComparisonResult dayCompare = [[aArray objectAtIndex:1] compare:[bArray objectAtIndex:1]];
                        return -dayCompare;
                    } else {
                        return -monthCompare;
                    }
                } else {
                    return -yearCompare;
                }
            }

        }];
        
        Experiences* expir = [experiences objectAtIndex:indexPath.row-8];
        
        cell.experienceName.textColor = self.UIPrinciple.netyBlue;
        cell.experienceDate.textColor = self.UIPrinciple.netyBlue;
        cell.experienceDescription.textColor = self.UIPrinciple.netyBlue;
        
        cell.experienceName.text = expir.name;
        cell.experienceDate.text = [NSString stringWithFormat:@"%@ - %@",expir.startDate, expir.endDate];
        cell.experienceDescription.text = expir.descript;
        
        float cellHeight = cell.contentView.frame.size.height;
        float cellWidth = cell.contentView.frame.size.width;
        
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(40, cellHeight - 2, cellWidth, 0.5)];/// change size as you need.
        separatorLineView.backgroundColor = self.UIPrinciple.netyBlue;
        [cell.contentView addSubview:separatorLineView];
        
        return cell;
        
    }
}

#pragma mark - Buttons
//---------------------------------------------------------

- (IBAction)chatNowButton:(id)sender {
    
    if ([self.selectedUser.security isEqual:@(2)]) {
    
        NSString *chatRequestText = [NSString stringWithFormat:@"%@ sent a chat request", self.senderDisplayName];
        NSString *chatRequestTextFromMyUser = NSLocalizedString(@"chatRequestSent", nil);
        
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

-(void) reportUser {
    
    FIRDatabaseReference *reportRef = [[[self.firdatabase child:kReports] child:self.selectedUser.userID] child:self.senderId];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Report"
                                          message:@"Please report why"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Ex. inappropriate photo";
     }];
    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:@"CANCEL"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                               }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *reportText = alertController.textFields.firstObject;
                                   UIAlertAction *okAction = alertController.actions.lastObject;
                                   okAction.enabled = reportText.text.length > 5;
                                   [reportRef setValue:reportText.text];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *reportText = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = reportText.text.length > 10;
    }
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    [_tableView reloadData];
}
@end
