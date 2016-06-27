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
    [self initializeTabBar];
    
    return YES;
}

-(void)initializeTabBar {
    //Create a tabBar instance
    UITabBarController *tabBarRootController = [[UITabBarController alloc] init];
    
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
    [networkViewController.tabBarItem setTitle:@"Net"];
    [myNetworkViewController.tabBarItem setTitle:@"My Net"];
    [chatViewController.tabBarItem setTitle:@"Chat"];
    [myInfoViewController.tabBarItem setTitle:@"Me"];
    
    //Set tabBar style
    UIPrinciples *UIPrinciple = [[UIPrinciples alloc] init];
    [[UITabBar appearance] setBackgroundColor:UIPrinciple.netyBlue];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Connect tabBar and view controllers together
    NSArray* controllers = [NSArray arrayWithObjects:networkViewController, myNetworkViewController, chatViewController, myInfoViewController, nil];
    tabBarRootController.viewControllers = controllers;
    
    //initialize tabBar
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:tabBarRootController];
    
    //make status bar text color white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

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
