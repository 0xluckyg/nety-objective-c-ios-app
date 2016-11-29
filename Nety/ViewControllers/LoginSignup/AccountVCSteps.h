//
//  AccountVCSteps.h
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "AccountSignUpVC.h"

// Base class
@interface AccountVCStep : GKState
@property (weak, nonatomic) AccountSignUpVC *viewController;
- (instancetype)initWithViewController: (AccountSignUpVC *)viewController;
- (BOOL)emailIsValid;
- (BOOL)emailConfirmationIsValid;
- (BOOL)passwordIsValid;
- (BOOL)passwordConfirmationIsValid;
@end

// Only email field showing
@interface AccountVCStep1 : AccountVCStep
@end

// Both email fields showing
@interface AccountVCStep2 : AccountVCStep
@end

// Display password portions
@interface AccountVCStep3 : AccountVCStep
@end

// Display everything
@interface AccountVCStep4 : AccountVCStep
@end

// Allow segue to next page
@interface AccountVCStep5 : AccountVCStep
@end


