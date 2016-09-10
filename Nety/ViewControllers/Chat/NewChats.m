//
//  Chat.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "NewChats.h"

@interface NewChats ()

@end

@implementation NewChats

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSettings];
    [self initializeDesign];
    [self initializeUsers];
}

- (void)viewWillAppear:(BOOL)animated {
    //If no experiences visible, show noContent header
    if ([[self fetchedResultsController].fetchedObjects count] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"SpeechBubble"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self customAddNoContent:self setText:NSLocalizedString(@"newChatNoContent", nil) setImage:contentImage setColor:self.UIPrinciple.netyGray setSecondColor:self.UIPrinciple.defaultGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    
}

#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    self.noContentController = [[NoContent alloc] init];
}

- (void)initializeDesign {
    
    //No separator
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // UIPrinciples class from Util folder
    self.UIPrinciple = [[UIPrinciples alloc] init];
}


- (void)initializeUsers {

}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatRooms" inManagedObjectContext:MY_API.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"type == NO"];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updateTime" ascending:YES];
    
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


#pragma mark - Protocols and Delegates
//---------------------------------------------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Configure cell
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    //Setting cell data as recent chats
    ChatRooms* chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
   
    [self configureCell:chatCell withObject:chat];
    
    //If no experiences visible, show noContent header
    if ([[self fetchedResultsController].fetchedObjects count] == 0) {
        
        UIImage *contentImage = [[UIImage imageNamed:@"SpeechBubble"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (![self.noContentController isDescendantOfView:self.view]) {
            [self customAddNoContent:self setText:NSLocalizedString(@"newChatNoContent", nil) setImage:contentImage setColor:self.UIPrinciple.netyGray setSecondColor:self.UIPrinciple.defaultGray noContentController:self.noContentController];
        }
    } else {
        [self.UIPrinciple removeNoContent:self.noContentController];
    }
    
    return chatCell;
}

- (void)configureCell:(ChatCell*)cell withObject:(ChatRooms*)object
{
    //Set images
    cell.chatUserImage.image = [UIImage imageNamed: kDefaultUserLogoName];
    NSString *photoUrl = object.profileImageUrl;
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        //[self loadAndCacheImage:chatCell photoUrl:profileImageUrl cache:self.imageCache];
        [cell.chatUserImage sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    }
    
    //Set name
    cell.chatUserName.text = object.fullName;
    
    //Set notification
    if ([object.unread integerValue] == 0) {
        cell.chatNotificationView.backgroundColor = [UIColor clearColor];
        cell.chatNotificationLabel.text = @"";
    } else {
        cell.chatNotificationView.backgroundColor = self.UIPrinciple.netyBlue;
        cell.chatNotificationLabel.text = [NSString stringWithFormat:@"%lu", [object.unread integerValue]];
    }
    
    //Set description
    NSString *descriptionText = object.recentMessage;
    cell.chatDescription.text = descriptionText;
    
    //Set date
    double timeSince1970Double = [object.updateTime doubleValue] * -1;
    NSDate *messageDate = [self convertDoubleToDate:timeSince1970Double];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    NSString *dateFormat = [dateFormatter stringFromDate:messageDate];
    cell.chatTime.text = dateFormat;
    
    //SWTableViewCell configuration
    NSMutableArray *chatRightUtilityButtons = [[NSMutableArray alloc] init];
    
    
    [chatRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyGray
                                                    title:NSLocalizedString(@"block", nil)];
    
    [chatRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyBlue
                                                    title:NSLocalizedString(@"add", nil)];
    [chatRightUtilityButtons sw_addUtilityButtonWithColor:
     self.UIPrinciple.netyRed
                                                    title:NSLocalizedString(@"leave", nil)];
    
    
    cell.rightUtilityButtons = chatRightUtilityButtons;
    cell.delegate = self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *messagesStoryboard = [UIStoryboard storyboardWithName:@"Messages" bundle:nil];
    Messages *messagesVC = [messagesStoryboard instantiateViewControllerWithIdentifier:@"Messages"];
    
    ChatRooms* chat = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    messagesVC.chatroomID = chat.chatRoomID;
    messagesVC.selectedUserID = chat.members.userID;
    messagesVC.selectedUserProfileImageString =chat.profileImageUrl;
    messagesVC.selectedUserName = chat.fullName;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegateFromNewChats pushViewControllerThroughProtocolFromNewChats:messagesVC];
    
    
}

//Close cell when other is cell is opened
-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell { return YES; }

//Actions when right swipe buttons are tapped
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    ChatRooms* chat = [[self fetchedResultsController] objectAtIndexPath:[self.table indexPathForCell:cell]];
    FIRDatabaseReference *firdatabase = [[FIRDatabase database] reference] ;
    
    NSString *userID = MY_USER.userID;
    NSString *roomID = chat.chatRoomID;
    NSString *selectedUserID = chat.members.userID;
    //NEW
    switch (index) {
        case 0: {
            
            UIAlertAction *cont = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //BLOCK
                
                //Remove
                FIRDatabaseReference *selectedUserChatRoomsRef = [[[firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                [[selectedUserChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
                //Adding to UserDetails
                FIRDatabaseReference *userDetailsRef = [[[firdatabase child:kUserDetails] child:userID] child:kBlockedUsers];
                [userDetailsRef setValue:@{selectedUserID:@0}];
                
            }];
            
            UIAlertAction *okay = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [self.UIPrinciple twoButtonAlert:cont rightButton:okay controller:NSLocalizedString(@"myNetBlockTitle", nil) message:NSLocalizedString(@"myNetBlockDescription", nil) viewController:self];
            
            break;
        }
        case 1: {
            
            //ADD
            
            FIRDatabaseReference *userChatRoomRef = [[[firdatabase child:kUserChats] child:userID] child:kChats];
            
//            NSMutableDictionary *chatRoomItem = [recentChatArray objectAtIndex:cellIndexPath.row];
//            [chatRoomItem setValue:@1 forKey:kType];
//            
            [[[userChatRoomRef child:roomID] child:kType]setValue:@1];
            
            
//            NSLog(@"%@", chatRoomItem);
            
            //Adding to UserDetails
            
            FIRDatabaseReference *userDetailsRef = [[[firdatabase child:kUserDetails] child:userID] child:kAddedUsers];
            [userDetailsRef setValue:@{selectedUserID:@0}];
            
            break;
        }
        case 2: {
            
            UIAlertAction *cont = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //DELETE

                FIRDatabaseReference *selectedUserChatRoomsRef = [[[firdatabase child:kUserChats] child:selectedUserID] child:kChats];
                [[selectedUserChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *userChatRoomsRef = [[[firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] ;
                [[userChatRoomsRef child:roomID] removeValue];
                
                FIRDatabaseReference *roomRef = [firdatabase child:kChats];
                [[roomRef child:roomID] removeValue];
                
            }];
            
            UIAlertAction *okay = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [self.UIPrinciple twoButtonAlert:cont rightButton:okay controller:NSLocalizedString(@"chatsDeleteTitle", nil) message:NSLocalizedString(@"myNetDeleteDescription", nil) viewController:self];
            
            break;
            
        }
        default: {
            break;
        }
    }
}

//Hide keyboard when search button pressed
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)oldNewSegmentedAction:(id)sender {
    
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


//Swiped cell will reset
- (void)viewWillDisappear:(BOOL)animated {
    //    [self.chatRoomsRef removeAllObservers];
    
}


#pragma mark - Custom methods
//---------------------------------------------------------

- (NSDate *)convertDoubleToDate: (double)timeIntervalDouble {
    NSNumber *timeIntervalInNumber = [NSNumber numberWithInt:timeIntervalDouble];
    NSTimeInterval timeInterval = [timeIntervalInNumber doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return date;
}


-(void)customAddNoContent: (UIViewController *)viewController setText:(NSString*)text setImage:(UIImage *)contentImage setColor:(UIColor *)color setSecondColor:(UIColor *)secondColor noContentController:(NoContent *)noContentController {
    
    float width = viewController.view.frame.size.width;
    float height = noContentController.view.frame.size.height;
    float xValue = 0;
    float yValue = (viewController.view.frame.size.height - 144)/2 - height/2;
    
    noContentController.view.frame = CGRectMake(xValue, yValue, width, height);
    
    [noContentController.view setBackgroundColor:[UIColor clearColor]];
    
    [noContentController.label setTextColor:[UIColor whiteColor]];
    
    noContentController.label.text = text;
    noContentController.label.textColor = secondColor;
    
    noContentController.image.image = contentImage;
    [noContentController.image setTintColor:color];
    
    [viewController.view addSubview:noContentController.view];
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
