//
//  UserData.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// A simple user model to persist data between sign up view controller segues
// This is also useful for scaling the sign up process to include linkedin data later

#import <UIKit/UIKit.h>

@interface UserData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *occupation;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSMutableArray *experiences;
@property (strong, nonatomic) UIImage *profilePicture;
@property (assign, nonatomic) NSUInteger age;

@end
