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

@import UserNotifications;
@import FirebaseDatabase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

#define NSFoundationVersionNumber_iOS_9_x_Max 1299

@interface AppDelegate ()

//@property (strong,nonatomic) GeoFire *geoFire;

@end

@implementation AppDelegate
@synthesize numberOfUnreadChats;

#pragma mark - View Load
//---------------------------------------------------------


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MY_API;
    
    userIsSigningIn = false;
    
    //[self loginLinkedIn];
    //Check if user is signed in, and move on
    [self locationUpdateSettingAlert];
    [self initializeSettings];
    [self initializeLoginView];    
    [self initializeDesign];
    [self initializeTabBar];
    
    self.firdatabase = [[FIRDatabase database] reference];
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];

    return YES;
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
//    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
//    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

// [START disconnect_from_fcm]

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connectToFcm];
}


#pragma mark - Initialization
//---------------------------------------------------------

-(void)stopUpdatingLocationToServer {
    [self.locationUpdateTimer invalidate];
    self.locationUpdateTimer = nil;
    [self.locationTracker stopLocationTracking];    
}

-(void)initializeLoginView
{
    
        self.locationTracker = [[LocationTracker alloc]init];
    
        [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                        FIRUser *_Nullable user) {
            
            if (user != nil) {
                
                if (userIsSigningIn == false) {
                    
                    // User is signed in.
                    NSLog(@"App Delegate detected user signedin");
                    [self fetchUserInformation:user];
                    userIsSigningIn=true;
                    //Set root view controller to main app
                    self.firdatabase = nil;
                    self.firdatabase = [[FIRDatabase database] reference];

                    if (self.tabBarRootController==nil)
                        [self initializeTabBar];
                    [self.window setRootViewController:self.tabBarRootController];
                    self.tabBarRootController.selectedIndex = 2;
                }
                
                //Send the best location to server every 40 seconds
                //You may adjust the time interval depends on the need of your app.
                [self.locationTracker startLocationTracking];
                NSTimeInterval time = 40.0;
                [self updateLocationToServer];
                self.locationUpdateTimer =
                [NSTimer scheduledTimerWithTimeInterval:time
                                                 target:self
                                               selector:@selector(updateLocationToServer)
                                               userInfo:nil
                                                repeats:YES];
        } else  {
                    userIsSigningIn=false;
            
                    [self.locationTracker startLocationTracking];
            
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
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: [self.UIPrinciple netyFontWithSize:15], NSFontAttributeName, self.UIPrinciple.netyTheme, NSForegroundColorAttributeName, nil];
    
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
    
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
         }
         ];
        
        // For iOS 10 display notification (sent via APNS)
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        // For iOS 10 data message (sent via FCM)
        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
}

// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
//    NSDictionary *userInfo = notification.request.content.userInfo;
//    
//    // Print full message.
//    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
//- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
//    // Print full message
//    NSLog(@"%@", [remoteMessage appData]);
//}
#endif


-(void)initializeTabBar {
    //Create a tabBar instance
    self.tabBarRootController = [[UITabBarController alloc] init];
    self.tabBarRootController.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBarRootController.tabBar.backgroundColor = [UIColor whiteColor];
    
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
    [networkViewController.tabBarItem setTitle:nil];
    networkViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);

    
    [myNetworkViewController.tabBarItem setImage:[UIImage imageNamed:@"MyNetworkEmpty"]];
    [myNetworkViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"MyNetwork"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [myNetworkViewController.tabBarItem setTitle:nil];
    myNetworkViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);

    [chatViewController.tabBarItem setImage:[UIImage imageNamed:@"ChatEmpty"]];
    [chatViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [chatViewController.tabBarItem setTitle:nil];
    chatViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    
    [myInfoViewController.tabBarItem setImage:[UIImage imageNamed:@"ProfileEmpty"]];
    [myInfoViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [myInfoViewController.tabBarItem setTitle:nil];
    myInfoViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    
    [settingsViewController.tabBarItem setImage:[UIImage imageNamed:@"SettingsEmpty"]];
    [settingsViewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [settingsViewController.tabBarItem setTitle:nil];
    settingsViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    
    //Set tabBar style
    [[UITabBar appearance] setTintColor:self.UIPrinciple.netyTheme];
    
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
    [[FIRMessaging messaging] disconnect];
//    NSLog(@"Disconnected from FCM");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MY_API saveContext];
}


#pragma mark - Custom methods
//---------------------------------------------------------

-(void)locationUpdateSettingAlert {
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }

}

-(void)updateLocationToServer {
    
    [self.locationTracker updateLocationToServer];
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
        
        if ([snapshot exists]) {
            NSDictionary *usersDictionary = snapshot.value;
            NSString *userID = snapshot.key;
            
            [MY_API addNewUser:usersDictionary UserID:userID Location:nil FlagMy:YES];
            
            [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
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
    
//    NSLog(@"%s url=%@","app delegate application openURL called ", [url absoluteString]);
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

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
//    // Print message ID.
//    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
//    
//    // Pring full message.
//    NSLog(@"%@", userInfo);
}
@end
