//
//  AccountVCStep2.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"


@implementation AccountVCStep2

-(BOOL)isValidNextState:(Class)stateClass {
    if (stateClass != [AccountVCStep3 class]) {
        return NO;
    }

    if ([self emailConfirmationIsValid] && [self emailIsValid]) {
        return YES;
    }
    
    return NO;
}

-(void)willExitWithNextState:(GKState *)nextState {
    self.viewController.whatIsYourEmailLabel.text = @"Great!";
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.viewController.createAPasswordLabel.alpha = 1;
                         self.viewController.passwordTextField.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self.viewController.passwordTextField becomeFirstResponder];
                     }];
}
@end
