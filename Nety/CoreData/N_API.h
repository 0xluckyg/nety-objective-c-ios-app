//
//  N_API.h
//  Nety
//
//  Created by Alex Agarkov on 20.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Users.h"
#import "Constants.h"
#import "LocationShareModel.h"

@import Firebase;

typedef void (^N_APIBlockDict)(NSDictionary* dict, NSError* error);
typedef void (^N_APIBlockArray)(NSArray* array, NSError* error);

#define TARGET_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

@interface N_API : NSObject

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (strong, nonatomic) Users* myUser;
#pragma mark - Core Data stack
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - API stack

+ (instancetype)sharedController;

#pragma mark - Firebase

@property (strong, nonatomic) FIRDatabaseReference *firdatabase;

- (void) loginToAcc:(NSString*) email pass:(NSString*) password  DoneBlock:(N_APIBlockDict)doneBlock;

- (void) addNewUser:(NSDictionary*)userInfo UserID:(NSString*)userID FlagMy:(BOOL)flagMy;

- (void) logOut;
@end
