//
//  ChatRooms+CoreDataProperties.h
//  Nety
//
//  Created by Alex Agarkov on 22.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatRooms.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRooms (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSNumber *online;
@property (nullable, nonatomic, retain) NSString *recentMessage;
@property (nullable, nonatomic, retain) NSNumber *unread;
@property (nullable, nonatomic, retain) NSString *charRoomID;
@property (nullable, nonatomic, retain) NSString *profileImageUrl;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *updateTime;
@property (nullable, nonatomic, retain) Users *members;

@end

NS_ASSUME_NONNULL_END
