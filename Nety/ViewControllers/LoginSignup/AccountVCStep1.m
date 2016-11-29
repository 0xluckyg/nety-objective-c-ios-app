//
//  AccountVCStep1.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"

@implementation AccountVCStep1

-(BOOL)isValidNextState:(Class)stateClass {
    if (stateClass != [AccountVCStep2 class]) {
        return NO;
    }
    
    if ([self emailIsValid]) {
        return YES;
    }
    
    return NO;
}

-(void)willExitWithNextState:(GKState *)nextState {
    self.viewController.whatIsYourEmailLabel.text = @"Confirm just to be sure :)";
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.viewController.emailConfirmationTextField.alpha = 1;
                         self.viewController.emailConfirmationTextField.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self.viewController.emailConfirmationTextField becomeFirstResponder];
                     }];
}


@end
