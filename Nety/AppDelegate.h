//
//  AppDelegate.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"
#import "UIPrinciples.h"
#import <CoreLocation/CoreLocation.h>

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarRootController;

@property (strong, nonatomic) UIPrinciples *UIPrinciple;


@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString * stringLatitude;

@property (strong, nonatomic) NSString * stringLongitude;

-(NSString*)returnLatLongString;

@end

