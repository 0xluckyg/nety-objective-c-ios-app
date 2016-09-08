//
//  N_API.m
//  Nety
//
//  Created by Alex Agarkov on 20.08.16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "N_API.h"
#import "Constants.h"
#import "ChatRooms.h"
#import "Experiences.h"

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
    
    [self initializeLocationManager];
    
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

- (void) listenForNetworkBlockChildAdd {
    
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
            [user setIsBlocked:[NSNumber numberWithBool:YES]];
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
        [user setValue:userID forKey:@"userID"];

    }
    for (NSString* keys in [userInfo allKeys]) {
        @try {
            if ([keys isEqualToString:@"experiences"]) {
                [user removeExperiences:user.experiences];
                for (NSString* expKey in [[userInfo objectForKey:keys] allKeys]) {
                    NSDictionary* expDict = [NSDictionary dictionaryWithDictionary:[[userInfo objectForKey:keys] objectForKey:expKey]];
                    //                    Experiences* expir = [NSEntityDescription insertNewObjectForEntityForName:@"Experiences" inManagedObjectContext:self.managedObjectContext];
                    //
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    // Edit the entity name as appropriate.
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiences" inManagedObjectContext:MY_API.managedObjectContext];
                    [fetchRequest setEntity:entity];
                    
                    
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"experienceKey == %@ AND user == %@",expKey,user];
                    [fetchRequest setPredicate:predicate];
                    
                    NSMutableArray* findExpirArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
                    
                    Experiences* expir;
                    if (findExpirArray.count == 0) {
                        
                        expir = [NSEntityDescription insertNewObjectForEntityForName:@"Experiences" inManagedObjectContext:self.managedObjectContext];
                        
                        for (NSString* keyExp in [expDict allKeys]) {
                            if ([keyExp isEqualToString:@"description"])
                            {
                                [expir setValue:[expDict objectForKey:keyExp] forKey:@"descript"];
                            }
                            else
                            {
                                [expir setValue:[expDict objectForKey:keyExp] forKey:keyExp];
                            }
                        }
                        
                        [expir setUser:user];
                        [expir setExperienceKey:expKey];
                        [user addExperiencesObject:expir];
                    }
                    else
                    {
                        expir = [findExpirArray lastObject];
                        NSLog(@"ПОВТОР");
                        for (NSString* keyExp in [expDict allKeys]) {
                            if ([keyExp isEqualToString:@"description"])
                            {
                                [expir setValue:[expDict objectForKey:keyExp] forKey:@"descript"];
                            }
                            else
                            {
                                [expir setValue:[expDict objectForKey:keyExp] forKey:keyExp];
                            }
                        }
                    }
                    //                    if (![user.experiences containsObject:expir]) {
                    //                        NSLog(@"expir added %@", expir);
                    //                        [expir setUser:user];
                    //                        [expir setExperienceKey:[NSString stringWithFormat:@"experience%i",[user.experiences count]]];
                    //                        [user addExperiencesObject:expir];
                    //                    }
                    
                }
            }
            else if ([keys isEqualToString:@"imdiscoverable"])
            {
                [user setValue:[NSNumber numberWithInteger:[[userInfo objectForKey:keys] integerValue]] forKey:keys];
            }
            else if ([keys isEqualToString:@"age"])
            {
                [user setValue:[NSString stringWithFormat:@"%@",[userInfo objectForKey:keys]] forKey:keys];
            }
            else
            {
                [user setValue:[userInfo objectForKey:keys] forKey:keys];
            }
        } @catch (NSException *exception) {
            NSLog(@"Create user ERROR: %@",exception);
        } @finally {
            ///
        }
    }
    
    NSArray* tempLocationArray = [NSArray arrayWithArray:[user.geocoordinate componentsSeparatedByString:@":"]];
    CLLocation* tempLocation = [[CLLocation alloc] initWithLatitude:[tempLocationArray[0] floatValue] longitude:[tempLocationArray[1] floatValue]];
    double distance = [tempLocation distanceFromLocation:MY_API.locationManager.location];
    NSLog(@"distance %f",distance);
    [user setValue:[NSNumber numberWithDouble:distance] forKey:@"distance"];
    if (flagMy) {
        user.itIsMe = [NSNumber numberWithBool:YES];
        [self setMyUser:user];
    }
    NSLog(@"UserADD");
    [self saveContext];
}

-(BOOL)containsExperience: (NSMutableArray *)set exp:(NSDictionary *)experience2 {
    
    BOOL returnValue = false;
    NSLog(@"setLength %lu", (unsigned long)[set count]);
    for (Experiences *experience1 in set) {
        
        if ([experience1.descript isEqualToString: [experience2 objectForKey:kExperienceDescription]] &&
            [experience1.name isEqualToString: [experience2 objectForKey:kExperienceName]] &&
            [experience1.startDate isEqualToString: [experience2 objectForKey:kExperienceStartDate]] &&
            [experience1.endDate isEqualToString: [experience2 objectForKey:kExperienceEndDate]]) {
            returnValue = true;
            break;
        } else {
//            NSLog(@"expUserID %@ : %@", experience1.user.userID, experience2.user.userID);
            NSLog(@"expDecript %@ : %@", experience1.descript,[experience2 objectForKey:kExperienceDescription]);
            NSLog(@"expName %@ : %@", experience1.name, [experience2 objectForKey:kExperienceName]);
            NSLog(@"expStart %@ : %@", experience1.startDate, [experience2 objectForKey:kExperienceStartDate]);
            NSLog(@"expStart %@ : %@", experience1.endDate, [experience2 objectForKey:kExperienceEndDate]);
            returnValue = false;
        }
    }
    NSLog(returnValue ? @"returnValue true" : @"returnValue false");
    return returnValue;
}

- (Users*) getUserrsWithID:(NSString*)userID
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
    return user;
}

- (void) setMyUser:(Users *)myUser
{
    if (!_myUser) {
        _myUser = myUser;
        [self listenForChildAdded];
        [self listenForChildChanged];
        [self listenForChildRemoved];
        
        [self listenForNetworkChildAdded];
        [self listenForNetworkChildRemoved];
        [self listenForNetworkBlockChildAdd];
        [self listenForChatsChildAdded];
        [self listenForChatsChildRemoved];
        [self listenForChatsChildChanged];
        // [self listenForChatsChildMoved]
    }
    _myUser = myUser;
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

//self.chatRoomsRef = [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] queryOrderedByChild:kUpdateTime];

#pragma mark - Chats

-(void)listenForChatsChildAdded {
    
    [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSDictionary *members = [snapshot.value objectForKey:kMembers];
        NSString *chatRoomKey = snapshot.key;
        
        //NSLog(@"Got snapchat: %@", snapshot.value);
        //NSLog(@"Got you: %@", [members objectForKey:@"member1"]);
        
        Users* tempUser = [self getUserrsWithID:[members objectForKey:@"member1"]];
            
            NSString *profilePhotoUrl = tempUser.profileImageUrl;
            NSString *name = [NSString stringWithFormat:@"%@ %@", tempUser.firstName, tempUser.lastName];
            
            [chatRoomInfoDict setValue:name forKey:kFullName];
            [chatRoomInfoDict setValue:profilePhotoUrl forKey:kProfilePhoto];
        
        [self addNewChatRoom:chatRoomInfoDict WithID:chatRoomKey Members:tempUser];
        
    } withCancelBlock:nil];
    
}

- (void) addNewChatRoom:(NSDictionary*)userInfo WithID:(NSString*)roomID  Members:(Users*)user
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatRooms" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"chatRoomID == %@",roomID]];
    NSError *error = nil;
    NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    ChatRooms* rooms;
    if (findUserArray.count>0) {
        rooms = [findUserArray lastObject];
    }
    else
    {
        rooms = [NSEntityDescription insertNewObjectForEntityForName:@"ChatRooms" inManagedObjectContext:self.managedObjectContext];
        
    }
    [rooms setMembers:user];
    [rooms setValue:roomID forKey:@"chatRoomID"];
    for (NSString* keys in [userInfo allKeys]) {
        @try {
            [rooms setValue:[userInfo objectForKey:keys] forKey:keys];
        } @catch (NSException *exception) {
            //NSLog(@"ERROR:%@ /n key:%@",exception,keys);
        } @finally {
            ///
        }
    }
    //NSLog(@"ChatRooms ADD OK");
    [self saveContext];
}

-(void)listenForChatsChildRemoved {
    
    [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *chatRoomKey = snapshot.key;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatRooms" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"chatRoomID == %@",chatRoomKey]];
        NSError *error = nil;
        NSMutableArray* findUserArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        ChatRooms* rooms;
        if (findUserArray.count>0) {
            rooms = [findUserArray lastObject];
            [self.managedObjectContext deleteObject:rooms];
        }
        
    } withCancelBlock:nil];
    
}

-(void)listenForChatsChildChanged {
    
    //THIS PART CRASHES!!!
    [[[[self.firdatabase child:kUserChats] child:MY_USER.userID] child:kChats] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *chatRoomInfoDict = snapshot.value;
        NSDictionary *members = [snapshot.value objectForKey:kMembers];
        NSString *chatRoomKey = snapshot.key;
        Users* tempUser = [self getUserrsWithID:[members objectForKey:@"member1"]];
        [self addNewChatRoom:chatRoomInfoDict WithID:chatRoomKey Members:tempUser];
        
    } withCancelBlock:nil];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager: (CLLocationManager *)manager
    didUpdateToLocation: (CLLocation *)newLocation
           fromLocation: (CLLocation *)oldLocation {
    
    NSLog(@"location called");
    
    
    if (MY_USER) {
        FIRDatabaseReference *geo = [[FIRDatabase database] reference];
        
        //Save name and age to the database
        [[[[geo child:kUsers] child:MY_USER.userID] child:kGeoCoordinate] setValue:[NSString stringWithFormat:@"%f:%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
        
        NSLog(@"location UDATE OK!!!");
    }
    
}

- (void)initializeLocationManager {
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //whenever user moves
    self.locationManager.distanceFilter = 10;//10m
    
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"location initialized");
    
}

- (void) logOut
{
    NSArray* allObjects = [self allObjects];
    
    [self.firdatabase removeAllObservers];
    [[FIRAuth auth] signOut:nil];
    self.myUser = nil;
    
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}

- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ALL"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}


#pragma mark - MyInfo

- (void) clearExperiences {
    NSArray* allExperiences = [self allExperiences];
    
    for (id object in allExperiences) {
        [self.managedObjectContext deleteObject:object];
    }
}

- (NSArray*) allExperiences {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"Experiences"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

@end
