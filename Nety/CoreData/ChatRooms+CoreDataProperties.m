//
//  ChatRooms+CoreDataProperties.m
//  Nety
//
//  Created by Alex Agarkov on 22.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatRooms+CoreDataProperties.h"

@implementation ChatRooms (CoreDataProperties)

@dynamic fullName;
@dynamic online;
@dynamic recentMessage;
@dynamic unread;
@dynamic charRoomID;
@dynamic profileImageUrl;
@dynamic type;
@dynamic updateTime;
@dynamic members;

@end
