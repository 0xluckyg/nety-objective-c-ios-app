//
//  userInformation.h
//  Nety
//
//  Created by Scott Cho on 7/24/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserInformation : NSObject


+(NSString *) getUserID;
+(NSString *) getName;
+(NSInteger) getAge;
+(NSString *) getIdentity;
+(NSString *) getStatus;
+(NSString *) getSummary;
+(UIImage *) getProfileImage;
+(NSMutableArray *) getExperiences;

+(NSCache *)getImagesCache;

+(void) setUserID: (NSString *)userID;
+(void) setName: (NSString *)name;
+(void) setAge: (NSInteger)age;
+(void) setIdentity: (NSString *)identity;
+(void) setStatus: (NSString *)status;
+(void) setSummary: (NSString *)summary;
+(void) setProfileImage: (UIImage *)profileImage;
+(void) setExperiences: (NSMutableArray *)experiences;

+(void) setImagesCache: (UIImage *)image;

@end
