//
//  userInformation.m
//  Nety
//
//  Created by Scott Cho on 7/24/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

static NSString *userID;

static NSString *name;

static NSInteger age;

static NSString *identity;

static NSString *status;

static NSString *summary;

static UIImage *profileImage;

static NSMutableArray *experiences;



+(NSString *) getUserID {
    return userID;
};

+(NSString *) getName {
    return name;
};

+(NSInteger) getAge {
    return age;
};

+(NSString *) getIdentity {
    return identity;
};

+(NSString *) getStatus {
    return status;
};

+(NSString *) getSummary {
    return summary;
};

+(UIImage *) getProfileImage{
    return profileImage;
};

+(NSMutableArray *) getExperiences{
    return experiences;
};

+(void) setUserID: (NSString *)setUserID {
    userID = setUserID;
};

+(void) setName: (NSString *)setName {
    name = setName;
};

+(void) setAge: (NSInteger)setAge {
    age = setAge;
};

+(void) setIdentity: (NSString *)setIdentity {
    identity = setIdentity;
};

+(void) setStatus: (NSString *)setStatus {
    status = setStatus;
};

+(void) setSummary: (NSString *)setSummary {
    summary = setSummary;
};

+(void) setProfileImage: (UIImage *)setProfileImage {
    profileImage = setProfileImage;
};

+(void) setExperiences: (NSMutableArray *)setExperiences {
    experiences = setExperiences;
};

@end
