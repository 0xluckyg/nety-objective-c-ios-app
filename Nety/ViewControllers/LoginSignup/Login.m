//
//  Login.m
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Login.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>

@interface Login ()<FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation Login


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    [_loginButton setDelegate:self];
    
#if DEBUG
    [_password setText:@"ptest3"];
    [_email setText:@"test3@gmail.com"];
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
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.holdingView.backgroundColor = self.UIPrinciple.netyBlue;
    
    [self.loginButtonOutlet.layer setBorderWidth:1.0];
    [self.loginButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginButtonOutlet.layer setCornerRadius:self.loginButtonOutlet.frame.size.height/2];
    
    self.loginWithLinkedinOutlet.backgroundColor = self.UIPrinciple.linkedInBlue;
    [self.loginWithLinkedinOutlet.layer setCornerRadius:self.loginWithLinkedinOutlet.frame.size.height/2];
    
    self.email.textColor = self.UIPrinciple.netyBlue;
    self.password.textColor = self.UIPrinciple.netyBlue;
    
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
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid email" message:@"Your email is too short!" viewController:self];
        
    } else if (self.password.text.length > 15 || self.password.text.length < 6) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid password" message:@"Your password has to be between 6 to 15 characters" viewController:self];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud.label setText:@"Logging in"];;
        [hud.bezelView setColor:[self.UIPrinciple.netyBlue colorWithAlphaComponent:0.3f]];
        [hud showAnimated:YES];
        
        [MY_API loginToAcc:self.email.text pass:self.password.text DoneBlock:^(NSDictionary *dict, NSError *error) {
            if (error)
            {
                [hud hideAnimated:YES];
                
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Problem signing in" message:error.localizedDescription viewController:self];
            }
            else
            {
                [self changeRoot];
                
                [hud hideAnimated:YES];

            }
        }];
    }
}

#pragma mark - Linkedin
- (IBAction)loginWithLinkedinButton:(id)sender {
    
    //Just set root controller to tabbar
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate.window setRootViewController:appDelegate.tabBarRootController];
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
                                         state:@"some state"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                                      NSLog(@"%s","success called!");
                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                                      NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
                                      NSMutableString *text = [[NSMutableString alloc] initWithString:[session.accessToken description]];
                                      [text appendString:[NSString stringWithFormat:@",state=\"%@\"",returnState]];
                                      NSLog(@"Response label text %@",text);
                                      

//                                      [[FIRAuth auth] signInWithCustomToken:session.accessToken.accessTokenValue completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//                                              if (error) {
//                                                  NSLog(@"Error: %@",error.localizedDescription);
//                                              }
//                                              else
//                                              {
//                                                  NSLog(@"Login OK");
//                                              }
//                                      }];
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                        
                                    }
     ];
    
    
    
}

#pragma mark - Facebook

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
    if (error) {
        NSLog(@"Process error");
    } else if (result.isCancelled) {
        NSLog(@"Cancelled");
    } else {
        NSLog(@"Logged in");
        NSLog(@"Token: %@",result.token.tokenString);
        
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      if (!error) {
                                          NSLog(@"Login OK");
                                          NSLog(@"FB User Info: %@",user);
                                          [self fetchUserInformation:user];
                                      }
                                      else
                                      {
                                          NSLog(@"FB Login Error: %@",error.localizedDescription);
                                      }
                                  }];
    }
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"LogOut");
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
            
            [MY_API addNewUser:usersDictionary UserID:otherUserID FlagMy:YES];
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
    [MY_API addNewUser:post UserID:userID FlagMy:YES];
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
