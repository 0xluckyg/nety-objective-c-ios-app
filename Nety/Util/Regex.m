//
//  Regex.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/21/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "Regex.h"

@implementation Regex

NSString * const kNameExpression = @"[A-Za-z]+[ ][A-Za-z]+";
NSString * const kEmailExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
NSString * const kPasswordExpression = @"[A-Za-z0-9]{6,15}";
NSString * const kAgeExpression = @"[0-9]+";

// TODO: Add support for international names
+(NSTextCheckingResult *)validateName: (NSString *)string{
    // Two words (only letters) with a space in between
    NSString *expression = kNameExpression;
    return [self validateString:string withExpression:expression];
}

+(NSTextCheckingResult *)validateAge: (NSString *)ageString{
    // Two words (only letters) with a space in between
    NSString *expression = kAgeExpression;
    return [self validateString:ageString withExpression:expression];
}

+(NSTextCheckingResult *)validateEmail: (NSString *)string {
    NSString *expression = kEmailExpression;
    return [self validateString:string withExpression:expression];
}

+(NSTextCheckingResult *)validatePassword: (NSString *)string{
    //    NSString *expression = @"^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$";
    NSString *expression = kPasswordExpression;
    return [self validateString:string withExpression:expression];
}

// Add error checking
+(NSTextCheckingResult *)validateString: (NSString *)string withExpression: (NSString *)expression {
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return match;
}
@end
