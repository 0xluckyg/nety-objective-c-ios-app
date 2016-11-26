//
//  AccountSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "AccountSignUpVC.h"
#import "Regex.h"

@interface AccountSignUpVC ()
@property (assign, nonatomic) CGFloat displacement;
@end

@implementation AccountSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextField.delegate = self;
    self.emailConfirmationTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmationTextField.delegate = self;
    self.imageView.image = [UIImage imageNamed:@"MainPicture8"];
    self.stepNumber = 2;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.originalFrame = self.view.frame;
    
    // 30 for top space, 35 for textfield height
    self.emailConfirmationTextField.transform = CGAffineTransformMakeTranslation(0, (-30 -35));
    self.emailConfirmationTextField.alpha = 0;
    self.passwordConfirmationTextField.alpha = 0;
    
    NSMutableArray *base = [self.baseViews mutableCopy];
    [base addObjectsFromArray:@[self.emailTextField, self.emailConfirmationTextField, self.passwordTextField, self.passwordConfirmationTextField, self.whatIsYourEmailLabel, self.createAPasswordLabel]];
    self.baseViews = [base copy];
    
    self.fields = @[self.emailTextField, self.emailConfirmationTextField, self.passwordTextField, self.passwordConfirmationTextField];
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if (self.userData.email) {
        self.emailTextField.text = self.userData.email;
    }
    
    if (self.userData.password) {
        self.passwordTextField.text = self.userData.password;
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    
    
    if ([textField.titlePlaceholder isEqualToString:@"E-mail Address"]) {
        NSTextCheckingResult *isValidEmail = [Regex validateEmail:textField.text];

        if (isValidEmail) {
            if (self.emailConfirmationTextField.alpha == 0) {
                self.whatIsYourEmailLabel.text = @"Confirm just to be sure :)";
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.emailConfirmationTextField.alpha = 1;
                                     self.emailConfirmationTextField.transform = CGAffineTransformIdentity;
                                 } completion:^(BOOL finished) {
                                     [self.emailConfirmationTextField becomeFirstResponder];
                                 }];
            } else {
                self.whatIsYourEmailLabel.text = @"Confirmation doesn't match";
            }
        } else {
            self.whatIsYourEmailLabel.text = @"Email has an error";
        }
    }
    
    if ([textField.titlePlaceholder isEqualToString:@"E-mail Confirmation"]) {
        BOOL emailConfirmationIsIdentical = [self.emailTextField.text isEqualToString:self.emailConfirmationTextField.text];
        
        if (emailConfirmationIsIdentical) {
            [self.passwordTextField becomeFirstResponder];
        } else {
            self.whatIsYourEmailLabel.text = @"Confirmation doesn't match";
        }
    }
    
    if ([textField.titlePlaceholder isEqualToString:@"Password"]) {
        NSTextCheckingResult *isValidPassword = [Regex validatePassword:textField.text];

        if (isValidPassword) {
            if (self.passwordConfirmationTextField.alpha == 0) {
                self.createAPasswordLabel.text = @"Confirm this one too :)";
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.passwordConfirmationTextField.alpha = 1;
                                     self.passwordConfirmationTextField.transform = CGAffineTransformMakeTranslation(0, -self.displacement);
                                 } completion:^(BOOL finished) {
                                     [self.passwordConfirmationTextField becomeFirstResponder];
                                     
                                 }];
            } else {
                self.createAPasswordLabel.text = @"Confirmation doesn't match";
                [self.passwordConfirmationTextField becomeFirstResponder];
            }
        } else {
            self.createAPasswordLabel.text = @"Password has an error";
        }
    }
    
    if ([textField.titlePlaceholder isEqualToString:@"Password Confirmation"]) {
        BOOL passwordConfirmationIsIdentical = [self.passwordTextField.text isEqualToString:self.passwordConfirmationTextField.text];
        if (passwordConfirmationIsIdentical) {
            [textField resignFirstResponder];
            
            NSTextCheckingResult *isValidEmail = [Regex validateEmail:self.emailTextField.text];
            BOOL emailConfirmationIsIdentical = [self.emailTextField.text isEqualToString:self.emailConfirmationTextField.text];
            NSTextCheckingResult *isValidPassword = [Regex validatePassword:textField.text];

            if (isValidEmail && emailConfirmationIsIdentical &&
                isValidPassword && passwordConfirmationIsIdentical) {
                
                self.userData.email = [self.emailTextField.text lowercaseString];
                self.userData.password = self.passwordTextField.text;
                [self moveViewsDown];
                [self performSegueWithIdentifier:@"ToWhoYouAreSegue" sender:self];
            } else {
                if (isValidEmail) {
                    NSLog(@"valid email");
                }
                if (emailConfirmationIsIdentical) {
                    NSLog(@"valid email conf");
                }
                if (isValidPassword) {
                    NSLog(@"valid password");
                }
                if (passwordConfirmationIsIdentical) {
                    NSLog(@"valid password conf");
                }
                self.whatIsYourEmailLabel.text = @"Incomplete input.";
                self.createAPasswordLabel.text = @"Incomplete input.";
            }

            
        } else {
            self.createAPasswordLabel.text = @"Confirmation doesn't match";
        }
    }
    
    
    return YES;
}

-(void)textFieldDidBeginEditing:(SignUpTextField *)textField {
    [super textFieldDidBeginEditing:textField];
    
    BOOL isPassword = [textField.titlePlaceholder isEqualToString:@"Password"];
    BOOL isPasswordConfirmation = [textField.titlePlaceholder isEqualToString:@"Password Confirmation"];
    BOOL viewNotMoved = CGAffineTransformIsIdentity(self.view.transform);
    if ( (isPassword || isPasswordConfirmation) && viewNotMoved ) {
        self.viewNeedsToBeMovedUp = YES;
    }
}


-(void)keyboardDidShow: (NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.displacement = self.displacement == 0 ? keyboardSize.height : self.displacement;
    if (self.viewNeedsToBeMovedUp) {
        [self moveViewsUp];
    }


}

-(void)keyboardDidHide: (NSNotification *)aNotification {
    if (self.viewNeedsToBeMovedUp) {
        [self moveViewsDown];
    }
}

-(void)moveViewsDown {
    for (UIView* view in self.baseViews) {
        view.transform = CGAffineTransformIdentity;
    }
}

-(void)moveViewsUp {
    for (UIView* view in self.baseViews) {
        if (view == self.passwordConfirmationTextField && view.alpha == 0) {
            self.passwordConfirmationTextField.transform = CGAffineTransformMakeTranslation(0, (-self.displacement - 30 - 35));
        } else {
            view.transform = CGAffineTransformMakeTranslation(0, -self.displacement);
        }
    }
}

@end

