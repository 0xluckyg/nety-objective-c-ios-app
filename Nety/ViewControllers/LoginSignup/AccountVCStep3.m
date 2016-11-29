//
//  AccountVCStep3.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"

@implementation AccountVCStep3

-(BOOL)isValidNextState:(Class)stateClass {
    if (stateClass != [AccountVCStep4 class]) {
        return NO;
    }
    
    if ([self passwordIsValid]) {
        return YES;
    }
        
    return NO;
}

-(void)willExitWithNextState:(GKState *)nextState {
    self.viewController.createAPasswordLabel.text = @"Confirm this one too :)";
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.viewController.passwordConfirmationTextField.alpha = 1;
                         self.viewController.passwordConfirmationTextField.transform = CGAffineTransformMakeTranslation(0, -self.viewController.displacement);
                     } completion:^(BOOL finished) {
                         [self.viewController.passwordConfirmationTextField becomeFirstResponder];
                     }];

}
@end
