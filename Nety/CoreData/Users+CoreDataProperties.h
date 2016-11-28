//
//  Users+CoreDataProperties.h
//  Nety
//
//  Created by Alex Agarkov on 04.09.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Users.h"

NS_ASSUME_NONNULL_BEGIN

@interface Users (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSString *geocoordinate;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *identity;
@property (nullable, nonatomic, retain) NSNumber *imdiscoverable;
@property (nullable, nonatomic, retain) NSNumber *isBlocked;
@property (nullable, nonatomic, retain) NSNumber *isFriend;
@property (nullable, nonatomic, retain) NSNumber *itIsMe;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *profileImageUrl;
@property (nullable, nonatomic, retain) NSNumber *security;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSSet<Experiences *> *experiences;
@property (nullable, nonatomic, retain) NSSet<ChatRooms *> *chatrooms;

@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addExperiencesObject:(Experiences *)value;
- (void)removeExperiencesObject:(Experiences *)value;
- (void)addExperiences:(NSSet<Experiences *> *)values;
- (void)removeExperiences:(NSSet<Experiences *> *)values;

- (void)addChatroomsObject:(ChatRooms *)value;
- (void)removeChatroomsObject:(ChatRooms *)value;
- (void)addChatrooms:(NSSet<ChatRooms *> *)values;
- (void)removeChatrooms:(NSSet<ChatRooms *> *)values;

@end

NS_ASSUME_NONNULL_END
