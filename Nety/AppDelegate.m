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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Check if user is signed in, and move on
    self.UIPrinciple = [[UIPrinciples alloc] init];
    [self initializeLoginView];
    [self initializeDesign];
    [self initializeTabBar];
    
    return YES;
}

-(void)initializeLoginView {
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
    UIViewController *myNetworkViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"MainPageNav"];

    [self.window setRootViewController:myNetworkViewController];
}

-(void)initializeDesign {
    [self.window setBackgroundColor:self.UIPrinciple.netyBlue];
    [UINavigationBar appearance].clipsToBounds = YES;
    [[UINavigationBar appearance] setBarTintColor:self.UIPrinciple.netyBlue];
}

-(void)initializeTabBar {
    //Create a tabBar instance
    self.tabBarRootController = [[UITabBarController alloc] init];
    
    //Create storyboard instances
    UIStoryboard *networkStoryboard = [UIStoryboard storyboardWithName:@"Network" bundle:nil];
    UIStoryboard *myNetworkStoryboard = [UIStoryboard storyboardWithName:@"MyNetwork" bundle:nil];
    UIStoryboard *chatStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UIStoryboard *myInfoStoryboard = [UIStoryboard storyboardWithName:@"MyInfo" bundle:nil];
    
    //Create view controller instances inside each storyboard
    UIViewController *networkViewController = [networkStoryboard instantiateViewControllerWithIdentifier:@"Network"];
    UIViewController *myNetworkViewController = [myNetworkStoryboard instantiateViewControllerWithIdentifier:@"MyNetwork"];
    UIViewController *chatViewController = [chatStoryboard instantiateViewControllerWithIdentifier:@"Chat"];
    UIViewController *myInfoViewController = [myInfoStoryboard instantiateViewControllerWithIdentifier:@"MyInfo"];
    
    //Set title and image of each tabBar item
    
    [networkViewController.tabBarItem setImage:[UIImage imageNamed:@"Network"]];
    [networkViewController.tabBarItem setTitle:@"Net"];
    
    [myNetworkViewController.tabBarItem setImage:[UIImage imageNamed:@"MyNetwork"]];
    [myNetworkViewController.tabBarItem setTitle:@"My Net"];
    
    [chatViewController.tabBarItem setImage:[UIImage imageNamed:@"Chat"]];
    [chatViewController.tabBarItem setTitle:@"Chat"];
    
    [myInfoViewController.tabBarItem setImage:[UIImage imageNamed:@"Profile"]];
    [myInfoViewController.tabBarItem setTitle:@"Me"];
    
    //Set tabBar style
    [[UITabBar appearance] setBackgroundColor:self.UIPrinciple.netyBlue];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Connect tabBar and view controllers together
    NSArray* controllers = [NSArray arrayWithObjects:networkViewController, myNetworkViewController, chatViewController, myInfoViewController, nil];
    self.tabBarRootController.viewControllers = controllers;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
