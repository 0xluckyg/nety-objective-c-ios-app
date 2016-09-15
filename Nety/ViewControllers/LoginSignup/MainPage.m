//
//  MainPage.m
//  Nety
//
//  Created by Scott Cho on 7/1/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MainPage.h"

@interface MainPage ()



@end

@implementation MainPage


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initializeDesign];
    [self initializeSettings];
}

#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.holdingView.backgroundColor = self.UIPrinciple.netyBlue;
    
    self.logoImage.image = [UIImage imageNamed:@"LogoTransparent"];
    
    [self.loginButtonOutlet.layer setBorderWidth:1.0];
    [self.loginButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginButtonOutlet.layer setCornerRadius:self.loginButtonOutlet.frame.size.height/2];
    
    [self.signupButtonOutlet.layer setBorderWidth:1.0];
    [self.signupButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.signupButtonOutlet.layer setCornerRadius:self.signupButtonOutlet.frame.size.height/2];
    
//    [self.loginWithFacebookOutlet.layer setBorderWidth:1.0];
//    [self.loginWithFacebookOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginWithFacebookOutlet.layer setCornerRadius:self.signupButtonOutlet.frame.size.height/2];
    
//    [self.loginWithLinkedinOutlet.layer setBorderWidth:1.0];
//    [self.loginWithLinkedinOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginWithLinkedinOutlet.layer setCornerRadius:self.signupButtonOutlet.frame.size.height/2];
    
    
    [self.loginButtonOutlet setTitle:NSLocalizedString(@"login", nil) forState:normal];
    [self.signupButtonOutlet setTitle:NSLocalizedString(@"signup", nil) forState:normal];
    
    UIImage *facebookImage = [[UIImage imageNamed:@"Facebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *linkedinImage = [[UIImage imageNamed:@"LinkedIn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    
    [self.loginWithFacebookOutlet setImage:facebookImage forState:UIControlStateNormal];
    [self.loginWithFacebookOutlet setTintColor:self.UIPrinciple.facebookBlue];
    self.loginWithFacebookOutlet.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.loginWithFacebookOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    
    [self.loginWithLinkedinOutlet setImage:linkedinImage forState:UIControlStateNormal];
    [self.loginWithLinkedinOutlet setTintColor:self.UIPrinciple.linkedInBlue];
    self.loginWithLinkedinOutlet.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.loginWithLinkedinOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    
    
}

-(void)initializeSettings {
    self.firdatabase = [[FIRDatabase database] reference];
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------





#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)loginButton:(id)sender {    
}

- (IBAction)signupButton:(id)sender {
}

- (IBAction)loginWithFacebookButton:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             
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
     }];
}

#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------


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
    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
        if (!error) {
            
            //            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
            //                                          initWithGraphPath:@"me"
            //                                          parameters:[NSDictionary dictionaryWithObject:@"cover,picture.type(large),id,name,first_name,last_name,gender,birthday,email,location,hometown,bio,photos" forKey:@"fields"]
            //                                          HTTPMethod:@"GET"];
            //
            //            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
            //                                                  id result,
            //                                                  NSError *error) {
            //                if (!error)
            //                {
            NSDictionary *post = @{kFirstName:profile.firstName,
                                   kLastName:profile.lastName,
                                   kAge: @(0),
                                   kStatus: @"",
                                   kIdentity: @"",
                                   kSummary: @"",
                                   kExperiences: @{},
                                   kProfilePhoto: [profile imageURLForPictureMode:FBSDKProfilePictureModeNormal size:CGSizeMake(720, 720)].absoluteString};
            
            //Set user information inside global variables
            [MY_API addNewUser:post UserID:userID FlagMy:YES];
            [[[self.firdatabase child:kUsers] child:userID] setValue:post];
            [self changeRoot];
        }
        else
        {
            NSLog(@"Error %@",error.localizedDescription);
        }
        
        //            }];
        //
        //        }
        //        else
        //        {
        //            NSLog(@"Error %@",error.localizedDescription);
        //        }
    }];
    
}

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



#pragma mark - Warnings
//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---------------------------------------------------------


@end
