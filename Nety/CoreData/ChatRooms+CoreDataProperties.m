//
//  ChatRooms+CoreDataProperties.m
//  Nety
//
//  Created by Alex Agarkov on 04.09.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatRooms+CoreDataProperties.h"

@implementation ChatRooms (CoreDataProperties)

@dynamic chatRoomID;
@dynamic fullName;
@dynamic online;
@dynamic profileImageUrl;
@dynamic recentMessage;
@dynamic type;
@dynamic unread;
@dynamic updateTime;
@dynamic members;
@dynamic mesages;

@end
