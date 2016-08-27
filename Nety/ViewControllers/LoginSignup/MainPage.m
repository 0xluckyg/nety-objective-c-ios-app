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
    
    [self.loginWithFacebookOutlet.layer setBorderWidth:1.0];
    [self.loginWithFacebookOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginWithFacebookOutlet.layer setCornerRadius:self.signupButtonOutlet.frame.size.height/2];
    
    [self.loginWithLinkedinOutlet.layer setBorderWidth:1.0];
    [self.loginWithLinkedinOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.loginWithLinkedinOutlet.layer setCornerRadius:self.signupButtonOutlet.frame.size.height/2];
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------





#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)loginButton:(id)sender {
}

- (IBAction)signupButton:(id)sender {
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


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------





#pragma mark - Warnings
//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---------------------------------------------------------


@end
