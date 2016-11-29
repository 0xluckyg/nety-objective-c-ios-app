//
//  AccountVCStep.m
//  Nety
//
//  Created by Magfurul Abeer on 11/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "AccountVCSteps.h"
#import "Regex.h"

@implementation AccountVCStep

- (instancetype)initWithViewController: (AccountSignUpVC *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (BOOL)emailIsValid {
    NSTextCheckingResult *isValidEmail = [Regex validateEmail:self.viewController.emailTextField.text];
    if (isValidEmail) {
        __block BOOL blockCompleted = NO;
        __block BOOL unique;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self emailIsUnique:^void(BOOL isUnique) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{ [self.viewController hideActivityIndicator]; }];
                unique = isUnique;
                blockCompleted = YES;
            }];
        });
        
        while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !blockCompleted) {}
        
        if (unique) { return YES; }
        else { self.viewController.whatIsYourEmailLabel.text = @"E-mail is already registered!"; }
        
    } else {
        self.viewController.whatIsYourEmailLabel.text = @"Email has an error";
    }
    return NO;
}

- (void)emailIsUnique: (void (^)(BOOL isUnique))completionHandler {
    NSString *userID = [[self.viewController.emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{ [self.viewController showActivityIndicator]; }];

    self.firdatabase = [[FIRDatabase database] reference];
    
    [[self.firdatabase child:kUsers] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        BOOL isNew;
        
        if ([snapshot hasChild:userID]) {
            NSLog(@"ALREADY EXISTS");
            isNew = NO;
        } else {
            NSLog(@"IS NEW");
            isNew = YES;
        }
        
        return completionHandler(isNew);
    }];

}



//func findUniqueId(completion:(uniqueId:String)->()) {
//    self.firDB.child("sessions").observeSingleEventOfType(.Value, withBlock: { snapshot in
//        var sID = self.genCode()
//        while snapshot.hasChild(sID) {
//            sID = self.genCode()
//        }
//        completion(uniqueId:sID)
//    })
//}

- (BOOL)emailConfirmationIsValid {
    NSString *email = [self.viewController.emailTextField.text lowercaseString];
    NSString *emailConfirmation = [self.viewController.emailConfirmationTextField.text lowercaseString];
    if ([email isEqualToString:emailConfirmation] ) {
        return YES;
    }
    
    self.viewController.whatIsYourEmailLabel.text = @"Confirmation does not match";
    return NO;
}

- (BOOL)passwordIsValid {
    NSString *password = self.viewController.passwordTextField.text;
    NSTextCheckingResult *isValidPassword = [Regex validatePassword:password];
    if (isValidPassword) {
        return YES;
    }
    
    if (password.length < 6) {
        self.viewController.createAPasswordLabel.text = @"Password must be at least 6 chars";
    }
    if (password.length > 15) {
        self.viewController.createAPasswordLabel.text = @"Password must be at most 15 chars";
    }
    if (password.length > 15) {
        self.viewController.createAPasswordLabel.text = @"Password can only have letters and numbers";
    }
    
    return NO;
}

- (BOOL)passwordConfirmationIsValid {
    if ([self.viewController.passwordTextField.text isEqualToString:self.viewController.passwordConfirmationTextField.text]) {
        return YES;
    }
    
    self.viewController.createAPasswordLabel.text = @"Confirmation does not match";
    return NO;
}

@end
