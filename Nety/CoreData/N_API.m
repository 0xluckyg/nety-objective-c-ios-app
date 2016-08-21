//
//  N_API.m
//  Nety
//
//  Created by Alex Agarkov on 20.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "N_API.h"
#import "Constants.h"

@implementation N_API

+(instancetype)sharedController
{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initController];
    });
    return sharedInstance;
}

- (void) initController
{
    //Configure Firebase
    [FIRApp configure];
    
    //Enable presistence
    [FIRDatabase database].persistenceEnabled = YES;
    self.firdatabase = [[FIRDatabase database] reference];
    [self listenForChildAdded];
    [self listenForChildChanged];
    [self listenForChildRemoved];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.YobibyteLLC.StaffMenu" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:TARGET_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",TARGET_NAME]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Firebase - Network

-(void) listenForChildAdded {
    
    [[self.firdatabase child:kUsers] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *usersDictionary = snapshot.value;
        NSString *otherUserID = snapshot.key;
        NSString *userID = _myUser.userID;
        
        [self addNewUser:usersDictionary UserID:otherUserID FlagMy:[otherUserID isEqualToString: userID]];
        
    } withCancelBlock:nil];
    
}

-(void) listenForChildRemoved {
    
    [[self.firdatabase child:kUsers] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *otherUserID = snapshot.key;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userID" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userID == %@",otherUserID]];
        NSError *error = nil;
        NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        if (findUserArray.count>0) {
            Users* user = [findUserArray lastObject];
            [self.managedObjectContext deleteObject:user];
            [self saveContext];
        }
        
    } withCancelBlock:nil];
    
}

-(void) listenForChildChanged {
    
    [[self.firdatabase child:kUsers] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *usersDictionary = snapshot.value;
        NSString *otherUserID = snapshot.key;
        NSString *userID = _myUser.userID;
        
        [self addNewUser:usersDictionary UserID:otherUserID FlagMy:[otherUserID isEqualToString: userID]];
        
    } withCancelBlock:nil];
    
}

#pragma mark - Firebase - MyNetwork

- (void) listenForNetworkChildAdded {
    
    [[[[self.firdatabase child:kUserDetails] child:_myUser.userID] child:kAddedUsers] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *otherUserID = snapshot.key;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userID == %@",otherUserID]];
        NSError *error = nil;
        NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        
        if (findUserArray.count>0) {
            Users* user = [findUserArray lastObject];
            [user setIsFriend:[NSNumber numberWithBool:YES]];
            [self saveContext];
        }
        
    } withCancelBlock:nil];
    
}

- (void) listenForNetworkChildRemoved {
    
    [[[[self.firdatabase child:kUserDetails] child:_myUser.userID] child:kAddedUsers] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *otherUserID = snapshot.key;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userID == %@",otherUserID]];
        NSError *error = nil;
        NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        
        if (findUserArray.count>0) {
            Users* user = [findUserArray lastObject];
            [user setIsFriend:[NSNumber numberWithBool:NO]];
            [self saveContext];
        }
        
    } withCancelBlock:nil];
    
}

//--------------------------------------------

- (void) addNewUser:(NSDictionary*)userInfo UserID:(NSString*)userID FlagMy:(BOOL)flagMy
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userID == %@",userID]];
    NSError *error = nil;
    NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    Users* user;
    if (findUserArray.count>0) {
        user = [findUserArray lastObject];
    }
    else
    {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:self.managedObjectContext];

    }
    [user setValue:userID forKey:@"userID"];
    for (NSString* keys in [userInfo allKeys]) {
        @try {
            [user setValue:[userInfo objectForKey:keys] forKey:keys];
        } @catch (NSException *exception) {
            NSLog(@"Create user ERROR: %@",exception);
        } @finally {
            ///
        }
    }
    
    if (flagMy) {
        user.itIsMe = [NSNumber numberWithBool:YES];
        [self setMyUser:user];
    }
    NSLog(@"UserADD");
    [self saveContext];
}

- (void) setMyUser:(Users *)myUser
{
    _myUser = myUser;
    [self listenForNetworkChildAdded];
    [self listenForNetworkChildRemoved];
}

#pragma mark - Login

- (void) loginToAcc:(NSString*) email pass:(NSString*) password  DoneBlock:(N_APIBlockDict)doneBlock
{
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             
                             if (error) {
                                 doneBlock(nil,error);
                             } else {
                                 
                                 NSString *userID = [[email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                 
                                 [[[self.firdatabase child:kUsers] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                     // Get user value
                                     
                                     NSDictionary *firebaseUserInfo = snapshot.value;
                                     
                                     [self addNewUser:firebaseUserInfo UserID:userID FlagMy:YES];
                                     doneBlock(firebaseUserInfo,nil);
                                 } withCancelBlock:^(NSError * _Nonnull error) {
                                     NSLog(@"%@", error.localizedDescription);
                                     
                                 }];
                                 
                             }
                             
                         }];
}
@end
