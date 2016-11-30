//
//  MyChats.m
//  Nety
//
//  Created by Scott Cho on 8/21/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Chat.h"

@interface Chat ()

@end

@implementation Chat

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDesign];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Array to keep track of controllers in page menu
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    // Create variables for all view controllers you want to put in the
    // page menu, initialize them, and add each to the controller array.
    // (Can be any UIViewController subclass)
    // Make sure the title property of all view controllers is set
    // Example:
    
    NewChats *newChatsController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewChats"];
    MyChats *myChatsController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyChats"];
    
    newChatsController.title = @"NEW CHATS";
    [controllerArray addObject:newChatsController];
    myChatsController.title = @"MY CHATS";
    [controllerArray addObject:myChatsController];
    
    
    // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
    // Example:
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: self.UIPrinciple.netyTheme,
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor:[UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionMenuItemFont: [self.UIPrinciple netyFontWithSize:13],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @((self.view.frame.size.width / 2) - (self.view.frame.size.width / 10)),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionScrollAnimationDurationOnMenuItemTap: @(300.0)
                                 };
    
    
    // Initialize page menu with controller array, frame, and optional parameters
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 20.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    // Lastly add page menu as subview of base view controller view
    // or use pageMenu controller in you view hierachy as desired
    [self.view addSubview:_pageMenu.view];
    
    [newChatsController setDelegateFromNewChats:self];
    [myChatsController setDelegateFromMyChats:self];
}


-(void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyTheme;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//Protocol to receive data
-(void)pushViewControllerThroughProtocolFromNewChats:(Messages *)messageVC {
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

-(void)pushViewControllerThroughProtocolFromMyChats:(Messages *)messageVC {
    [self.navigationController pushViewController:messageVC animated:YES];
}

@end
