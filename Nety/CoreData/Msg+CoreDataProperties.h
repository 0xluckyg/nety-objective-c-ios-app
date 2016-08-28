//
//  Msg+CoreDataProperties.h
//  Nety
//
//  Created by Alex Agarkov on 28.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Msg.h"

NS_ASSUME_NONNULL_BEGIN

@interface Msg (CoreDataProperties)

<<<<<<< HEAD
@property (nullable, nonatomic, retain) NSString *chatroomID;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *media;
=======
@property (nullable, nonatomic, retain) NSNumber *date;
>>>>>>> origin/master
@property (nullable, nonatomic, retain) NSString *senderDisplayName;
@property (nullable, nonatomic, retain) NSString *senderId;
@property (nullable, nonatomic, retain) NSString *text;

@end

NS_ASSUME_NONNULL_END
