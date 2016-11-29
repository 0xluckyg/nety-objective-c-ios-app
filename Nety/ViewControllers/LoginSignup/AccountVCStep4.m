//
//  AccountVCStep4.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"


@implementation AccountVCStep4

-(BOOL)isValidNextState:(Class)stateClass {
    if (stateClass != [AccountVCStep5 class]) {
        return NO;
    }
    
    if ([self emailConfirmationIsValid] && [self emailIsValid] &&
        [self passwordConfirmationIsValid] && [self passwordIsValid]) {
        return YES;
    }
    
    return NO;
}

-(void)willExitWithNextState:(GKState *)nextState {
    self.viewController.createAPasswordLabel.text = @"Fantastic!";
    self.viewController.userData.email = [self.viewController.emailTextField.text lowercaseString];
    self.viewController.userData.password = self.viewController.passwordTextField.text;
    [self.viewController moveViewsDown];
}



@end
