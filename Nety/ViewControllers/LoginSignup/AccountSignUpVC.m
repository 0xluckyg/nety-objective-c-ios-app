//
//  AccountSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "AccountSignUpVC.h"
#import "Regex.h"
#import <GameKit/GameKit.h>
#import "AccountVCSteps.h"

@interface AccountSignUpVC ()
@property (strong, nonatomic) AccountVCStep1 *state1;
@property (strong, nonatomic) AccountVCStep2 *state2;
@property (strong, nonatomic) AccountVCStep3 *state3;
@property (strong, nonatomic) AccountVCStep4 *state4;
@property (strong, nonatomic) AccountVCStep5 *state5;
@property (strong, nonatomic) GKStateMachine *stateMachine;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@end

@implementation AccountSignUpVC

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpStates];
    
    self.imageView.image = [UIImage imageNamed:@"MainPicture8"];
    self.stepNumber = 2;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.originalFrame = self.view.frame;
    
    // 30 for top space, 35 for textfield height
    self.emailConfirmationTextField.transform = CGAffineTransformMakeTranslation(0, (-30 -35));
    self.emailConfirmationTextField.alpha = 0;
    self.passwordConfirmationTextField.alpha = 0;
    self.createAPasswordLabel.alpha = 0;
    self.passwordTextField.alpha = 0;
    
    NSMutableArray *base = [self.baseViews mutableCopy];
    [base addObjectsFromArray:@[self.emailTextField, self.emailConfirmationTextField, self.passwordTextField, self.passwordConfirmationTextField, self.whatIsYourEmailLabel, self.createAPasswordLabel]];
    self.baseViews = [base copy];
    
    self.fields = @[self.emailTextField, self.emailConfirmationTextField, self.passwordTextField, self.passwordConfirmationTextField];
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [self setUpStateMachine];
}

-(void)viewWillAppear:(BOOL)animated {
    self.emailTextField.delegate = self;
    self.emailConfirmationTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmationTextField.delegate = self;
    
    if (self.userData.email) {
        self.emailTextField.text = self.userData.email;
        self.emailConfirmationTextField.text = self.userData.email;
        self.emailConfirmationTextField.alpha = 1;
        self.emailConfirmationTextField.transform = CGAffineTransformIdentity;
    }
    
    if (self.userData.password) {
        self.passwordTextField.text = self.userData.password;
        self.passwordConfirmationTextField.text = self.userData.password;
        self.passwordTextField.alpha = 1;
        self.passwordConfirmationTextField.alpha = 1;
        self.passwordConfirmationTextField.transform = CGAffineTransformIdentity;
        self.createAPasswordLabel.alpha = 1;
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - Setup Methods

-(void)setUpStates {
    self.state1 = [[AccountVCStep1 alloc] initWithViewController:self];
    self.state2 = [[AccountVCStep2 alloc] initWithViewController:self];
    self.state3 = [[AccountVCStep3 alloc] initWithViewController:self];
    self.state4 = [[AccountVCStep4 alloc] initWithViewController:self];
    self.state5 = [[AccountVCStep5 alloc] initWithViewController:self];
}

// Does not automatically enter state 5 because that would cause an auto-segue
-(void)setUpStateMachine {
    self.stateMachine = [GKStateMachine stateMachineWithStates:@[self.state1, self.state2, self.state3, self.state4, self.state5]];
    BOOL emailConfirmationFieldIsVisible = self.emailConfirmationTextField.alpha == 1;
    BOOL passwordFieldIsVisible = self.passwordTextField.alpha == 1;
    BOOL passwordConfirmationFieldIsVisible = self.passwordConfirmationTextField.alpha == 1;
    if (passwordConfirmationFieldIsVisible) {
        [self.stateMachine enterState:[self.state4 class]];
    } else if (passwordFieldIsVisible) {
        [self.stateMachine enterState:[self.state3 class]];
    } else if (emailConfirmationFieldIsVisible) {
        [self.stateMachine enterState:[self.state2 class]];
    } else {
        [self.stateMachine enterState:[self.state1 class]];
    }
}


#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    [self enterNextStateIfPossible];
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

#pragma mark - Keyboard Response Methods

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

#pragma mark - Progress Methods

// TODO: Refactor
-(void)enterNextStateIfPossible {
    if ([self.stateMachine canEnterState:[self.state2 class]]) {
        [self.stateMachine enterState:[self.state2 class]];
    } else if ([self.stateMachine canEnterState:[self.state3 class]]) {
        [self.stateMachine enterState:[self.state3 class]];
    } else if ([self.stateMachine canEnterState:[self.state4 class]]) {
        [self.stateMachine enterState:[self.state4 class]];
    } else if ([self.stateMachine canEnterState:[self.state5 class]]) {
        [self.stateMachine enterState:[self.state5 class]];
    }
}

-(void)viewWasTapped {
    [super viewWasTapped];
    [self enterNextStateIfPossible];
}

-(void)goToNextPage {
    [self performSegueWithIdentifier:@"ToWhoYouAreSegue" sender:self];
}

-(void)showActivityIndicator {
    // Add, constrain, and animate Activity Indicator
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityView];
    
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.activityView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [self.activityView startAnimating];
}

-(void)hideActivityIndicator {
    self.activityView.hidesWhenStopped = YES;
    [self.activityView stopAnimating];
}
@end

