//
//  Signup.m
//  Nety
//
//  Created by Scott Cho on 7/2/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Signup.h"

@interface Signup ()

@end

@implementation Signup


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
    
    [self.signupButtonOutlet.layer setBorderWidth:1.0];
    [self.signupButtonOutlet.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.signupButtonOutlet.layer setCornerRadius:self.signupButtonOutlet.frame.size.height/2];
    
    self.signupWithLinkedinButtonOutlet.backgroundColor = self.UIPrinciple.linkedInBlue;
    [self.signupWithLinkedinButtonOutlet.layer setCornerRadius:self.signupWithLinkedinButtonOutlet.frame.size.height/2];
    
    self.email.textColor = self.UIPrinciple.netyBlue;
    self.password.textColor = self.UIPrinciple.netyBlue;
    self.age.textColor = self.UIPrinciple.netyBlue;
    self.name.textColor = self.UIPrinciple.netyBlue;
    
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


- (IBAction)signupButton:(id)sender {
    
    //Age char check
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.age.text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    
    if (self.email.text.length < 10) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid email" message:@"Your email is too short!" viewController:self];
        
    } else if (self.password.text.length > 15 || self.password.text.length < 6) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid password" message:@"Your password has to be between 6 to 15 characters" viewController:self];
        
    } else if (!valid || self.age.text.integerValue < 5 || self.age.text.integerValue > 100) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid age" message:@"ex. 24" viewController:self];
        
    } else if (self.name.text.length < 2 || self.name.text.length > 30 || [[self.name.text componentsSeparatedByString:@" "] count] > 2 ) {
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid name" message:@"ex. Firstname Lastname" viewController:self];
        
    } else if ([self.name.text rangeOfString:@" "].location == NSNotFound){
        
        [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Please enter a valid name" message:@"Please separate your first and last name with a space" viewController:self];
        
    } else {
        
        
        NSArray *nameArray = [self.name.text componentsSeparatedByString:@" "];
        
        self.userInfo = [[NSMutableArray alloc] initWithArray:@[
                                                                self.email.text,
                                                                self.password.text,
                                                                nameArray[0],
                                                                nameArray[1],
                                                                self.age.text ]];
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setUserIsSigningIn:true];
        
        
        
        //Sign up the user
        [[FIRAuth auth]
         createUserWithEmail: [self.userInfo objectAtIndex:0]
         password: [self.userInfo objectAtIndex:1]
         completion:^(FIRUser *_Nullable user,
                      NSError *_Nullable error) {
             
             if (error) {
                 
                 NSLog(@"%@", error.localizedDescription);
                 
                 [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Problem signing up" message:error.localizedDescription viewController:self];
                 
             } else {
                 
                 //User ID is supposed to be the email without . and @
                 NSString *userID = [[[self.userInfo objectAtIndex:0] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
                 
                 NSMutableArray *experienceArray = [[NSMutableArray alloc] init];
                 
                 NSDictionary *post = @{kFirstName: [self.userInfo objectAtIndex:2],
                                        kLastName: [self.userInfo objectAtIndex:3],
                                        kAge: [self.userInfo objectAtIndex:4],
                                        kStatus: @"",
                                        kIdentity: @"",
                                        kSummary: @"",
                                        kExperiences: experienceArray,
                                        kProfilePhoto: kDefaultUserLogoName,
                                        kSmallProfilePhoto: kDefaultUserLogoName,
                                        kSecurity: @0};
                 
                 //Set user information inside global variables
                 [UserInformation setUserID:userID];
                 [UserInformation setName:[NSString stringWithFormat:@"%@ %@", [post objectForKey:kFirstName], [post objectForKey:kLastName]]];
                 [UserInformation setAge:[[post objectForKey:kAge] integerValue]];
                 [UserInformation setStatus:[post objectForKey:kStatus]];
                 [UserInformation setSummary:[post objectForKey:kSummary]];
                 [UserInformation setIdentity:[post objectForKey:kIdentity]];
                 [UserInformation setExperiences:experienceArray];
                 [UserInformation setProfileImage:[UIImage imageNamed:kDefaultUserLogoName]];
                 
                 [[[self.firdatabase child:kUsers] child:userID] setValue:post];
                 
                 [self performSegueWithIdentifier:@"signupProcess1Segue" sender:self];
             }
             
         }];
    }
    
}

- (IBAction)signupWithLinkedinButton:(id)sender {
    
}

//Go back to main screen
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - View Disappear
//---------------------------------------------------------


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"signupProcess1Segue"])
    {
        
        [self.email endEditing:YES];
        [self.name endEditing:YES];
        [self.age endEditing:YES];
        [self.password endEditing:YES];
        
        // Get reference to the destination view controller
        SignupProcess1 *process1 = [segue destinationViewController];
        
        process1.userInfo = self.userInfo;
        
    }
}


#pragma mark - Custom methods
//---------------------------------------------------------





//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
