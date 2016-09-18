//
//  Constants.m
//  Nety
//
//  Created by Scott Cho on 7/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Constants.h"

NSString *const kFullName = @"fullName";

NSString *const kUsers = @"users";
    NSString *const kFirstName = @"firstName";
    NSString *const kLastName = @"lastName";
    NSString *const kAge = @"age";
    NSString *const kIdentity = @"identity";
    NSString *const kStatus = @"status";
    NSString *const kSummary = @"summary";
    NSString *const kExperiences = @"experiences";
        NSString *const kExperienceName = @"name";
        NSString *const kExperienceStartDate = @"startDate";
        NSString *const kExperienceEndDate = @"endDate";
        NSString *const kExperienceDescription = @"descript";//description -- Property name clashes with a method implemented by NSManagedObject or NSObject
    NSString *const kProfilePhoto = @"profileImageUrl";
    NSString *const kSecurity = @"security";

NSString *const kUserChats = @"userChatRooms";
    NSString *const kChats = @"chats";
        NSString *const kOnline = @"online";
        NSString *const kUnread = @"unread";
        NSString *const kType = @"type";
        NSString *const kUpdateTime = @"updateTime";
        NSString *const kRecentMessage = @"recentMessage";

NSString *const kChatRooms = @"chats";
    NSString *const kCreated = @"created";
        NSString *const kMembers = @"members";
    NSString *const kMessages = @"messages";
        NSString *const kDate = @"date";
        NSString *const kSenderDisplayName = @"senderDisplayName";
        NSString *const kSenderId = @"senderId";
        NSString *const kText = @"text";
        NSString *const kMedia = @"media";

NSString *const kUserDetails = @"userDetails";
    NSString *const kBlockedUsers = @"blockedUsers";
    NSString *const kAddedUsers = @"addedUsers";

NSString *const kDefaultUserLogoName = @"NetyBlueLogo";
NSString *const kGeoCoordinate = @"geocoordinate";
NSString *const kIAmDiscoverable = @"imdiscoverable";

NSString *const kProfileImages = @"ProfileImages";
    NSString *const kBig = @"Big";
    NSString *const kSmall = @"Small";
NSString *const kChatImages = @"ChatImages";

@implementation Constants

@end