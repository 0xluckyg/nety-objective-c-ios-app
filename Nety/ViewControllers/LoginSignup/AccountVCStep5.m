//
//  AccountVCStep5.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"
#import "UserData.h"
#import "LocationShareModel.h"
#import "GeoFire.h"
#import "AppDelegate.h"

@implementation AccountVCStep5

-(BOOL)isValidNextState:(Class)stateClass {
    return NO;
}

-(void)didEnterWithPreviousState:(GKState *)previousState {
    for (UIControl *field in self.viewController.fields) {
        [field resignFirstResponder];
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate setUserIsSigningIn:true];
    
    [self createUser];
    [self.viewController goToNextPage];
}

-(void)createUser {
    self.firdatabase = [[FIRDatabase database] reference];
    
    UserData *userData = self.viewController.userData;
    
    //Sign up the user
    [[FIRAuth auth]
     createUserWithEmail: userData.email
     password: userData.password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         
         if (error) {
             
             NSLog(@"%@", error.localizedDescription);
             
             [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"problemSigningUp", nil) message:error.localizedDescription viewController:self.viewController];
             
         } else {
             
             //User ID is supposed to be the email without . and @
             NSString *userID = [[userData.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
             
             NSArray *fullName = [userData.name componentsSeparatedByString:@" "];

             NSDictionary *post = @{kFirstName: fullName[0],
                                    kLastName: fullName[1],
                                    kAge: @(userData.age),
                                    kStatus: @"",
                                    kIdentity: @"",
                                    kSummary: @"",
                                    kExperiences: userData.experiences,
                                    kProfilePhoto: kDefaultUserLogoName,
                                    kSecurity: @(0)};
             
             //Set user information inside global variables
             
             FIRDatabaseReference *geo = [[[FIRDatabase database] reference] child:kUserLocation];
             
             //Save location to the database
             GeoFire *geoFire = [[GeoFire alloc] initWithFirebaseRef:geo];
             CLLocation *myLocation = [self getBestLocation];
             
             [geoFire setLocation:[[CLLocation alloc] initWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude] forKey:userID];
             
             [MY_API addNewUser:post UserID:userID Location:myLocation FlagMy:YES];
             [[[self.firdatabase child:kUsers] child:userID] setValue:post];
             
             [self.viewController goToNextPage];
         }
         
     }];

}

- (CLLocation *) getBestLocation {
    
    LocationShareModel *shareModel = [LocationShareModel sharedModel];
    CLLocation *myLocation = [CLLocation alloc];
    
    //Set distance
    if ([shareModel.myLocationArray count] != 0) {
        //Pick best location accuracy
        int bestAccuracy = 0;
        int bestLocationIndex = 0;
        for (int i = 0; i < [shareModel.myLocationArray count]; i ++) {
            if ([[shareModel.myLocationArray[i] objectForKey:@"theAccuracy"] floatValue] > bestAccuracy) {
                bestAccuracy = [[shareModel.myLocationArray[i] objectForKey:@"theAccuracy"] floatValue];
                bestLocationIndex = i;
            }
        }
        
        myLocation = [myLocation initWithLatitude:[[shareModel.myLocationArray[bestLocationIndex] objectForKey:@"latitude"] floatValue] longitude:[[shareModel.myLocationArray[bestLocationIndex] objectForKey:@"longitude"] floatValue]];
        
        return myLocation;
    } else {
        return nil;
    }
}
@end
