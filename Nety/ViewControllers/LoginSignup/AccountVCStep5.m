//
//  AccountVCStep5.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"
#import "UserData.h"

@implementation AccountVCStep5

-(BOOL)isValidNextState:(Class)stateClass {
    return NO;
}

-(void)didEnterWithPreviousState:(GKState *)previousState {
    for (UIControl *field in self.viewController.fields) {
        [field resignFirstResponder];
    }
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
             [[N_API sharedController] addNewUser:post UserID:userID Location:nil FlagMy:YES];
             [[[self.firdatabase child:kUsers] child:userID] setValue:post];
             
             [self.viewController goToNextPage];
         }
         
     }];

}

@end
