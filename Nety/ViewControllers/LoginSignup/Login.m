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
        hud.labelText = @"Logging in";
        hud.color = [self.UIPrinciple.netyBlue colorWithAlphaComponent:0.3f];
        [hud show:YES];
        
        [[FIRAuth auth] signInWithEmail:self.email.text
                               password:self.password.text
                             completion:^(FIRUser *user, NSError *error) {
                                 
                                 if (error) {
                                     [hud hide:YES];

                                     [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Problem signing in" message:error.localizedDescription viewController:self];
                                 } else {
                                     
                                     NSString *userID = [[self.email.text stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                     
                                     [[[self.firdatabase child:kUsers] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                         // Get user value
                                                                                  
                                         NSDictionary *firebaseUserInfo = snapshot.value;
                                         
                                         //Set user information inside global variables
                                         [self saveUserInformationLocally:firebaseUserInfo userID:userID profileImageUrl:[firebaseUserInfo objectForKey:kProfilePhoto]];
                                         
                                         [hud hide:YES];
                                         
                                     } withCancelBlock:^(NSError * _Nonnull error) {
                                         NSLog(@"%@", error.localizedDescription);
                                     }];
                                     
                                 }
                                 
                             }];
    }
}

- (IBAction)loginWithLinkedinButton:(id)sender {
    
    //Just set root controller to tabbar
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarRootController];
    
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


- (void)saveUserInformationLocally: (NSDictionary *)firbaseUserInfo userID:(NSString *)userID profileImageUrl:(NSString *)profileImageUrl{
    
    //Set user information inside global variables
    [UserInformation setUserID:userID];
    [UserInformation setName:[NSString stringWithFormat:@"%@ %@", [firbaseUserInfo objectForKey:kFirstName], [firbaseUserInfo objectForKey:kLastName]]];
    [UserInformation setAge:[[firbaseUserInfo objectForKey:kAge] integerValue]];
    [UserInformation setStatus:[firbaseUserInfo objectForKey:kStatus]];
    [UserInformation setSummary:[firbaseUserInfo objectForKey:kSummary]];
    [UserInformation setIdentity:[firbaseUserInfo objectForKey:kIdentity]];
    
    NSMutableArray *experienceArray = [NSMutableArray arrayWithArray:[[firbaseUserInfo objectForKey:kExperiences] allValues]];
    
    [UserInformation setExperiences:experienceArray];
    
    // Create a reference to the file you want to download
    if ([profileImageUrl isEqualToString:kDefaultUserLogoName]) {
        
        [UserInformation setProfileImage:[UIImage imageNamed:kDefaultUserLogoName]];
        [self changeRoot];
        
    } else {
        FIRStorageReference *userProfileImageRef = [[FIRStorage storage] referenceForURL:profileImageUrl];
        
        // Fetch the download URL
        [userProfileImageRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            if (error != nil) {
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Problem signing in" message:error.localizedDescription viewController:self];
            } else {
                [UserInformation setProfileImage:[UIImage imageWithData:data]];
                [self changeRoot];
            }
        }];
        
    }
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


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
