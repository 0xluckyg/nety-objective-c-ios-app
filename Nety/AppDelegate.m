//
//  AppDelegate.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AppDelegate.h"
#import "UIPrinciples.h"
#import <linkedin-sdk/LISDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import FirebaseDatabase;

@interface AppDelegate ()

//@property (strong,nonatomic) GeoFire *geoFire;

@end

@implementation AppDelegate


#pragma mark - View Load
//---------------------------------------------------------


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MY_API;
    
    userIsSigningIn = false;
    
//    FIRDatabaseReference *geofireRef = [[FIRDatabase database] reference];
//    
//    _geoFire = [[GeoFire alloc] initWithFirebaseRef:geofireRef];
    
    
    //[self loginLinkedIn];
    //Check if user is signed in, and move on
    [self initializeSettings];
    [self initializeLoginView];    
    [self initializeDesign];
    [self initializeTabBar];
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


#pragma mark - Initialization
//---------------------------------------------------------


-(void)initializeLoginView {
    
        [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                        FIRUser *_Nullable user) {
            
            NSLog(@"user %@", user.email);
            if (user != nil) {
                
                if (userIsSigningIn == false) {
                
                    // User is signed in.
                    NSLog(@"App Delegate detected user signedin");
                    [self fetchUserInformation:user];
                    
                    if (MY_USER == nil || MY_USER.userID == nil) {
                        
                        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
                        UIViewController *mainViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"MainPageNav"];
                        
                        //Set root view controller to login page
                        [self.window setRootViewController:mainViewController];
                        
                    } else {
                        
                        //Set root view controller to main app
                        [self.window setRootViewController:self.tabBarRootController];
                        
                    }
                    
                }
                
            } else  {
                
                    NSLog(@"App Delegate detected user not signed in");
                    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
                    UIViewController *mainViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"MainPageNav"];
                
                    //Set root view controller to login page
                    [self.window setRootViewController:mainViewController];
            }
        }];
    
    
    
}

-(void)initializeDesign {
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBarTintColor:self.UIPrinciple.netyBlue];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: [self.UIPrinciple netyFontWithSize:15], NSFontAttributeName, self.UIPrinciple.netyBlue, NSForegroundColorAttributeName, nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateNormal];

}

-(void)initializeSettings {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    
    //Notification setup
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

-(void)initializeTabBar {
    //Create a tabBar instance
    self.tabBarRootController = [[UITabBarController alloc] init];
    
    //Create storyboard instances
    UIStoryboard *networkStoryboard = [UIStoryboard storyboardWithName:@"Network" bundle:nil];
    UIStoryboard *myNetworkStoryboard = [UIStoryboard storyboardWithName:@"MyNetwork" bundle:nil];
    UIStoryboard *chatStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UIStoryboard *myInfoStoryboard = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    
    //Create view controller instances inside each storyboard
    UIViewController *networkViewController = [networkStoryboard instantiateViewControllerWithIdentifier:@"Network"];
    UIViewController *myNetworkViewController = [myNetworkStoryboard instantiateViewControllerWithIdentifier:@"MyNetwork"];
    UIViewController *chatViewController = [chatStoryboard instantiateViewControllerWithIdentifier:@"Chat"];
    UIViewController *myInfoViewController = [myInfoStoryboard instantiateViewControllerWithIdentifier:@"MyInfo"];
    UIViewController *settingsViewController = [settingsStoryboard instantiateViewControllerWithIdentifier:@"Settings"];
    
    //Set title and image of each tabBar item
    [networkViewController.tabBarItem setImage:[UIImage imageNamed:@"NetworkEmpty"]];
    [networkViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Network"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [networkViewController.tabBarItem setTitle:@"Net"];
    
    [myNetworkViewController.tabBarItem setImage:[UIImage imageNamed:@"MyNetworkEmpty"]];
    [myNetworkViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"MyNetwork"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [myNetworkViewController.tabBarItem setTitle:@"My Net"];
    
    [chatViewController.tabBarItem setImage:[UIImage imageNamed:@"ChatEmpty"]];
    [chatViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [chatViewController.tabBarItem setTitle:@"Chat"];
    
    [myInfoViewController.tabBarItem setImage:[UIImage imageNamed:@"ProfileEmpty"]];
    [myInfoViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [myInfoViewController.tabBarItem setTitle:@"Me"];
    
    [settingsViewController.tabBarItem setImage:[UIImage imageNamed:@"SettingsEmpty"]];
    [settingsViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [settingsViewController.tabBarItem setTitle:@"Settings"];
    
    //Set tabBar style

    [[UITabBar appearance] setTintColor:self.UIPrinciple.netyBlue];

    
    //Connect tabBar and view controllers together
    NSArray* controllers = [NSArray arrayWithObjects:networkViewController,
                            myNetworkViewController,
                            chatViewController,
                            myInfoViewController,
                            settingsViewController, nil];
    
    self.tabBarRootController.viewControllers = controllers;
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------



#pragma mark - View Disappear
//---------------------------------------------------------


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MY_API saveContext];
}


#pragma mark - Custom methods
//---------------------------------------------------------


- (void) loginLinkedIn
{
//    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
//                                         state:@"some state"
//                        showGoToAppStoreDialog:YES
//                                  successBlock:^(NSString *returnState) {
//                                      
//                                      NSLog(@"%s","success called!");
//                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
//                                      NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
//                                      NSMutableString *text = [[NSMutableString alloc] initWithString:[session.accessToken description]];
//                                      [text appendString:[NSString stringWithFormat:@",state=\"%@\"",returnState]];
//                                      NSLog(@"Response label text %@",text);
//
//                                      
//                                  }
//                                    errorBlock:^(NSError *error) {
//                                        NSLog(@"%s %@","error called! ", [error description]);
//
//                                    }
//     ];
    NSLog(@"%s","sync pressed3");
}
-(NSString*)returnLatLongString {
    
    NSString *str = [NSString stringWithFormat: @"lat=%@&long=%@", self.stringLatitude, self.stringLongitude];
    
    return str;
}

- (void)fetchUserInformation: (FIRUser *)user {
    
    FIRDatabaseReference *firdatabase = [[FIRDatabase database] reference];
    
    NSString *userEmail = user.email;
    NSString *userID = [[userEmail stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [[[firdatabase child:kUsers] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        
        NSLog(@"this is user's dictionary %@", snapshot.value);
        
        if ([snapshot exists]) {
            NSDictionary *usersDictionary = snapshot.value;
            NSString *userID = snapshot.key;
            
            [MY_API addNewUser:usersDictionary UserID:userID FlagMy:YES];
            
            NSLog(@"%@", kUserChats);
            NSLog(@"%@", MY_USER.userID);
            NSLog(@"%@", kChats);
            [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                NSDictionary *chatDictionary = snapshot.value;
                numberOfUnreadChats += [[chatDictionary objectForKey:kUnread] integerValue];
                
            } withCancelBlock:nil];
            
            if (numberOfUnreadChats == 0) {
                [self.tabBarRootController.tabBar.items objectAtIndex:2].badgeValue = nil;
            } else {
                [[self.tabBarRootController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%i", numberOfUnreadChats]];
            }
            
        }
        else
        {
            NSLog(@"User not found");            
        }
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}

-(void)setUserIsSigningIn: (bool)boolean {
    userIsSigningIn = boolean;
}

//---------------------------------------------------------

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%s url=%@","app delegate application openURL called ", [url absoluteString]);
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    } else 
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
}
@end
