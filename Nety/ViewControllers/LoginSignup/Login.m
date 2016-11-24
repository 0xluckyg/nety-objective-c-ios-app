//
//  Login.m
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
#if DEBUG
//    [_password setText:@"ptest3"];
//    [_email setText:@"test3@gmail.com"];
#endif
    
    [self initializeSettings];
    [self initializeDesign];
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    self.firdatabase = [[FIRDatabase database] reference];
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyTheme;
    self.holdingView.backgroundColor = self.UIPrinciple.netyTheme;
    
    [self.loginButtonOutlet.layer setBorderWidth:1.0];
    [self.loginButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginButtonOutlet.layer setCornerRadius:self.loginButtonOutlet.frame.size.height/2];
    
    [self.email setBackgroundColor:[UIColor whiteColor]];
    [self.email.layer setCornerRadius:self.email.frame.size.height/2];
    self.email.textColor = self.UIPrinciple.netyTheme;
    
    
    [self.password setBackgroundColor:[UIColor whiteColor]];
    [self.password.layer setCornerRadius:self.password.frame.size.height/2];
    self.password.textColor = self.UIPrinciple.netyTheme;
    
    self.email.placeholder = NSLocalizedString(@"email", nil);
    self.password.placeholder = NSLocalizedString(@"password", nil);
    [self.loginButtonOutlet setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//Touching on sceen will make keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Buttons
//---------------------------------------------------------


//Log in the user after checking pw/id
- (IBAction)loginButton:(id)sender {
    
    if (self.email.text.length < 10) {
        
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidEmailTitle", nil) message:NSLocalizedString(@"invalidEmailDescription", nil) viewController:self];
        
    } else if (self.password.text.length > 15 || self.password.text.length < 6) {
        
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil)  controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil)  message:NSLocalizedString(@"invalidPasswordDescription", nil)  viewController:self];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud.label setText:NSLocalizedString(@"loggingIn", nil)];;
        [hud.bezelView setColor:[self.UIPrinciple.netyTheme colorWithAlphaComponent:0.3f]];
        [hud showAnimated:YES];
        
        [MY_API loginToAcc:self.email.text pass:self.password.text DoneBlock:^(NSDictionary *dict, NSError *error) {
            if (error)
            {
                [hud hideAnimated:YES];
                
                [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil)  controllerTitle:NSLocalizedString(@"problemSigningIn", nil)  message:error.localizedDescription viewController:self];
            }
            else
            {
                [self changeRoot];
                
                [hud hideAnimated:YES];

            }
        }];
    }
}

#pragma mark -

- (void)fetchUserInformation: (FIRUser *)user {
    
    FIRDatabaseReference *firdatabase = [[FIRDatabase database] reference];
    
    NSString *userEmail = user.email;
    NSString *userID = [[userEmail stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [[[firdatabase child:kUsers] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        
        if ([snapshot exists]) {
            NSDictionary *usersDictionary = snapshot.value;
            NSString *otherUserID = snapshot.key;
            
            [MY_API addNewUser:usersDictionary UserID:otherUserID Location:nil FlagMy:YES];
            [self changeRoot];
        }
        else
        {
            NSLog(@"User not found");
            [self createNewUser:user UserID:userID];
        }
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
   
}

- (void) createNewUser:(FIRUser*)userInfo UserID:(NSString*)userID
{

    NSArray *nameArray = [userInfo.displayName componentsSeparatedByString:@" "];
    
    NSDictionary *post = @{kFirstName: nameArray[0],
                           kLastName: nameArray[1],
                           kAge: @(0),
                           kStatus: @"",
                           kIdentity: @"",
                           kSummary: @"",
                           kExperiences: @{},
                           kProfilePhoto: userInfo.photoURL.absoluteString};
    
    
    //Set user information inside global variables
    [MY_API addNewUser:post UserID:userID Location:nil FlagMy:YES];
    [[[self.firdatabase child:kUsers] child:userID] setValue:post];
    [self changeRoot];
    
}
//Go back to main screen
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark - Custom methods
//---------------------------------------------------------


- (void)changeRoot {
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate initializeTabBar];
    [appDelegate initializeLoginView];
    
    [UIView
     transitionWithView:self.view.window
     duration:0.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         [appDelegate.window setRootViewController:appDelegate.tabBarRootController];
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
