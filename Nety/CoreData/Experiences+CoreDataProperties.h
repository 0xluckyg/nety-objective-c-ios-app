//
//  Experiences+CoreDataProperties.h
//  Nety
//
//  Created by Alex Agarkov on 21.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Experiences.h"

NS_ASSUME_NONNULL_BEGIN

@interface Experiences (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *startDate;
@property (nullable, nonatomic, retain) NSData *endDate;
@property (nullable, nonatomic, retain) NSString *descript;

@end

NS_ASSUME_NONNULL_END
