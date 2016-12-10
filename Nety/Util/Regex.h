//
//  Regex.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// A simple abstraction over Regular Expression validations for sign ups
#import <Foundation/Foundation.h>

@interface Regex : NSObject

+(NSTextCheckingResult *)validateName: (NSString *)string;
+(NSTextCheckingResult *)validateEmail: (NSString *)string;
+(NSTextCheckingResult *)validatePassword: (NSString *)string;
+(NSTextCheckingResult *)validateAge: (NSString *)ageString;

@end
