//
//  AccountVCStep5.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"


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

@end
