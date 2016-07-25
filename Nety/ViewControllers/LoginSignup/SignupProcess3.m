//
//  SignupProcess3.m
//  Nety
//
//  Created by Scott Cho on 7/6/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcess3.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "SingletonUserData.h"
#import "UserInformation.h"

@interface SignupProcess3 ()

@end

@implementation SignupProcess3

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
    
    self.profileImage.image = [UIImage imageNamed:@"NetyBlueLogo"];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    [self.doneButtonOutlet setTintColor:[UIColor whiteColor]];
    [self.addProfileImageOutlet setTintColor:[UIColor whiteColor]];
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------


//When photo choosing screen shows, customize nav controller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //Customizing view controller here
    [viewController.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [viewController.navigationController.navigationBar setTranslucent:NO];
    [self.UIPrinciple addTopbarColor:viewController];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [viewController.navigationController.navigationBar setTitleTextAttributes:attributes];
    
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //You can retrieve the actual UIImage
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *editedimage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (![UIImagePNGRepresentation(image) isEqualToData:UIImagePNGRepresentation(editedimage)]) {
        image = editedimage;
    }
    
    self.profileImage.image = image;
    [self.doneButtonOutlet setTitle:@"Done" forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Buttons
//---------------------------------------------------------


- (IBAction)addProfileImage:(id)sender {
    
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = (id)self;
    pickerLibrary.allowsEditing = YES;
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerLibrary animated:YES completion:nil];
    
}

//Moving to the main screen
- (IBAction)doneButton:(id)sender {
    
    // 0: email
    // 1: password
    // 2: first name
    // 3: last name
    // 4: age
    // 5: identity
    // 6: summary
    // 7: array of experiences
    //     7-0: name
    //     7-1: startDate
    //     7-2: endDate
    //     7-3: description
    
    //Get userID and save to database
    NSString *userID = [[[self.userInfo objectAtIndex:0] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    //    SingletonUserData *singletonUserData = [SingletonUserData sharedInstance];
    //    singletonUserData.userID = userID;
    
    
    //Uploading profile image
    NSString *uniqueImageID = [[NSUUID UUID] UUIDString];
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *profileImageRef = [[[storage reference] child:@"profileImages"] child:uniqueImageID];
    
    //If user doesn't set profile image, set it to default image without uploading it.
    if (self.profileImage.image == [UIImage imageNamed:@"NetyBlueLogo"]) {
        
        [self registerUserInfo:userID metaDataUid:@"NetyBlueLogo"];
        
    } else {
        
        NSData *uploadData = UIImagePNGRepresentation(self.profileImage.image);
        
        [profileImageRef putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Can not upload image" message:@"Please try again at another time" viewController:self];
                
            } else {
                NSLog(@"%@", metadata);
                
                [self registerUserInfo:userID metaDataUid:[[metadata downloadURL] absoluteString]];
                [self changeRoot];
                
            }
            
        }];
        
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------


-(void)changeRoot {
    
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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

-(void)registerUserInfo: (NSString *)userID metaDataUid:(NSString *)metaDataUid {
    
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    NSMutableArray *experienceArray = [self.userInfo objectAtIndex:7];
    
    for (int i = 0; i < [experienceArray count]; i ++) {
        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
        [experiences setObject:[experienceArray objectAtIndex:i] forKey:experienceKey];
    }
    
    NSDictionary *post = @{kFirstName: [self.userInfo objectAtIndex:2],
                           kLastName: [self.userInfo objectAtIndex:3],
                           kAge: [self.userInfo objectAtIndex:4],
                           kStatus: @"",
                           kIdentity: [self.userInfo objectAtIndex:5],
                           kSummary: [self.userInfo objectAtIndex:6],
                           kExperiences: experiences,
                           kProfilePhoto: metaDataUid};
    
    
    //Set user information inside global variables
    [UserInformation setUserID:userID];
    [UserInformation setName:[NSString stringWithFormat:@"%@ %@", [post objectForKey:kFirstName], [post objectForKey:kLastName]]];
    [UserInformation setAge:[[post objectForKey:kAge] integerValue]];
    [UserInformation setStatus:[post objectForKey:kStatus]];
    [UserInformation setSummary:[post objectForKey:kSummary]];
    [UserInformation setIdentity:[post objectForKey:kIdentity]];
    [UserInformation setExperiences:experienceArray];
    [UserInformation setProfileImage:self.profileImage.image];
    
    [[[self.firdatabase child:@"users"] child:userID] setValue:post];
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
