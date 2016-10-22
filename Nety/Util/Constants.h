//
//  Constants.h
//  Nety
//
//  Created by Scott Cho on 7/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kFullName;

extern NSString *const kUsers;
    extern NSString *const kFirstName;
    extern NSString *const kLastName;
    extern NSString *const kAge;
    extern NSString *const kIdentity;
    extern NSString *const kStatus;
    extern NSString *const kSummary;
    extern NSString *const kExperiences;
        extern NSString *const kExperienceName;
        extern NSString *const kExperienceStartDate;
        extern NSString *const kExperienceEndDate;
        extern NSString *const kExperienceDescription;
    extern NSString *const kProfilePhoto;
    extern NSString *const kSecurity;

extern NSString *const kUserChats;
    extern NSString *const kChats;
        extern NSString *const kOnline;
        extern NSString *const kUnread;
        extern NSString *const kType;
        extern NSString *const kUpdateTime;
        extern NSString *const kRecentMessage;

extern NSString *const kChatRooms;
    extern NSString *const kCreated;
        extern NSString *const kMembers;
    extern NSString *const kMessages;
        extern NSString *const kDate;
        extern NSString *const kSenderDisplayName;
        extern NSString *const kSenderId;
        extern NSString *const kText;
        extern NSString *const kMedia;

extern NSString *const kUserDetails;
    extern NSString *const kBlockedUsers;
    extern NSString *const kAddedUsers;

extern NSString *const kDefaultUserLogoName;
extern NSString *const kGeoCoordinate;

extern NSString *const kIAmDiscoverable;
@interface Constants : NSObject

@end
