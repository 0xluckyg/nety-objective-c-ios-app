//
//  AppDelegate.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AppDelegate.h"
#import "UIPrinciples.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - View Load
//---------------------------------------------------------


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    userIsSigningIn = false;
    
    [self initializeLocationManager];
    
    //Check if user is signed in, and move on
    [self initializeSettings];
    [self initializeLoginView];
    [self initializeDesign];
    [self initializeTabBar];
    
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
            if (user != nil) {
                
                if (userIsSigningIn == false) {
                
                    // User is signed in.
                    NSLog(@"App Delegate detected user signedin");
                    [self fetchUserInformation:user];
                    
                    //Set root view controller to main app
                    [self.window setRootViewController:self.tabBarRootController];
                    
                }
                
            } else {
                
                    NSLog(@"App Delegate detected user not signed in");
                    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
                    UIViewController *myNetworkViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"MainPageNav"];
                    
                    //Set root view controller to login page
                    [self.window setRootViewController:myNetworkViewController];
            }
        }];
    
    
    
}

-(void)initializeDesign {
    [self.window setBackgroundColor:self.UIPrinciple.netyBlue];
    [UINavigationBar appearance].clipsToBounds = YES;
    [[UINavigationBar appearance] setBarTintColor:self.UIPrinciple.netyBlue];
}

-(void)initializeSettings {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Configure Firebase
    [FIRApp configure];
    
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
    
    [networkViewController.tabBarItem setImage:[UIImage imageNamed:@"Network"]];
    [networkViewController.tabBarItem setTitle:@"Net"];
    
    [myNetworkViewController.tabBarItem setImage:[UIImage imageNamed:@"MyNetwork"]];
    [myNetworkViewController.tabBarItem setTitle:@"My Net"];
    
    [chatViewController.tabBarItem setImage:[UIImage imageNamed:@"Chat"]];
    [chatViewController.tabBarItem setTitle:@"Chat"];
    
    [myInfoViewController.tabBarItem setImage:[UIImage imageNamed:@"Profile"]];
    [myInfoViewController.tabBarItem setTitle:@"Me"];
    
    [settingsViewController.tabBarItem setImage:[UIImage imageNamed:@"Settings"]];
    [settingsViewController.tabBarItem setTitle:@"Settings"];
    
    //Set tabBar style
    [[UITabBar appearance] setBackgroundColor:self.UIPrinciple.netyBlue];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : self.UIPrinciple.netyGray}
    //                                             forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
    //                                             forState:UIControlStateSelected];
    
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


- (void)locationManager: (CLLocationManager *)manager
    didUpdateToLocation: (CLLocation *)newLocation
           fromLocation: (CLLocation *)oldLocation {
    
    NSLog(@"location called");
    
    float latitude = newLocation.coordinate.latitude;
    self.stringLatitude = [NSString stringWithFormat:@"%f",latitude];
    float longitude = newLocation.coordinate.longitude;
    self.stringLongitude = [NSString stringWithFormat:@"%f", longitude];
    //[self returnLatLongString:strLatitude:strLongitude];
    
}


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
}


#pragma mark - Custom methods
//---------------------------------------------------------


- (void)initializeLocationManager {
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //whenever user moves
    self.locationManager.distanceFilter = kCLDistanceFilterNone;    
    
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"location initialized");
    
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
        
        NSDictionary *firebaseUserInfo = snapshot.value;
        
        //Set user information inside global variables
        [self saveUserInformationLocally:firebaseUserInfo userID:userID profileImageUrl:[firebaseUserInfo objectForKey:kProfilePhoto]];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}

- (void)saveUserInformationLocally: (NSDictionary *)firbaseUserInfo userID:(NSString *)userID profileImageUrl:(NSString *)profileImageUrl{
    
    //Set user information inside global variables
    [UserInformation setUserID:userID];
    [UserInformation setName:[NSString stringWithFormat:@"%@ %@", [firbaseUserInfo objectForKey:kFirstName], [firbaseUserInfo objectForKey:kLastName]]];
    [UserInformation setAge:[[firbaseUserInfo objectForKey:kAge] integerValue]];
    [UserInformation setStatus:[firbaseUserInfo objectForKey:kStatus]];
    [UserInformation setSummary:[firbaseUserInfo objectForKey:kSummary]];
    [UserInformation setIdentity:[firbaseUserInfo objectForKey:kIdentity]];
    
    NSMutableArray *experienceArray = [NSMutableArray arrayWithArray:[[firbaseUserInfo objectForKey:kExperiences] allValues]];
    
    [UserInformation setExperiences:experienceArray];
    
    if ([profileImageUrl isEqualToString:kDefaultUserLogoName]) {
        
        [UserInformation setProfileImage:[UIImage imageNamed:kDefaultUserLogoName]];
        
    } else {
        
        // Create a reference to the file you want to download
        FIRStorageReference *userProfileImageRef = [[FIRStorage storage] referenceForURL:profileImageUrl];
        
        // Fetch the download URL
        [userProfileImageRef dataWithMaxSize:1 * 1180 * 1180 completion:^(NSData *data, NSError *error){
            if (error != nil) {
                
                //Error downloading Message
                NSLog(@"%@", error.localizedDescription);
                
            } else {
                [UserInformation setProfileImage:[UIImage imageWithData:data]];
            }
        }];
        
    }
}

-(void)setUserIsSigningIn: (bool)boolean {
    userIsSigningIn = boolean;
}

//---------------------------------------------------------


@end
