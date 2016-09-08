//
//  SignupProcess3.m
//  Nety
//
//  Created by Scott Cho on 7/6/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcess3.h"

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
    
    self.profileImage.image = [UIImage imageNamed:kDefaultUserLogoName];
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
    
    [self uploadImage:userID];
    

}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View Disappear
//---------------------------------------------------------





#pragma mark - Custom methods
//---------------------------------------------------------


-(void)uploadImage: (NSString *)userID {
    
    //Uploading profile image
    NSString *uniqueImageIDBig = [[NSUUID UUID] UUIDString];
    NSString *uniqueImageIDSmall = [[NSUUID UUID] UUIDString];
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *profileImageBigRef = [[[[storage reference]
                                             child:@"ProfileImages"]
                                            child:@"Big" ]
                                            child:uniqueImageIDBig];
    FIRStorageReference *profileImageSmallRef = [[[[storage reference]
                                              child:@"ProfileImages"]
                                             child:@"Small" ]
                                            child:uniqueImageIDSmall];
    
    //If user doesn't set profile image, set it to default image without uploading it.
    NSData *logoImage = UIImagePNGRepresentation([UIImage imageNamed:kDefaultUserLogoName]);
    NSData *pickedImage = UIImagePNGRepresentation(self.profileImage.image);
    
    if ([logoImage isEqualToData:pickedImage]) {
        
        [self registerUserInfo:userID metaDataBigUid:kDefaultUserLogoName metaDataSmallUid:kDefaultUserLogoName];
        [self changeRoot];
        
    } else {
        
        UIImage *bigProfileImage = self.profileImage.image;
        UIImage *smallProfileImage = [self.UIPrinciple scaleDownImage:bigProfileImage];
        
        NSData *uploadDataBig = UIImagePNGRepresentation(bigProfileImage);
        NSData *uploadDataSmall = UIImagePNGRepresentation(smallProfileImage);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"Uploading";
        hud.bezelView.color = [self.UIPrinciple.netyBlue colorWithAlphaComponent:0.3f];
        [hud showAnimated:YES];
        
        //Uploading big profile picture first
        [profileImageBigRef putData:uploadDataBig metadata:nil completion:^(FIRStorageMetadata * _Nullable metadataBig, NSError * _Nullable error) {
            
            if (error) {
                [hud hideAnimated:YES];
                NSLog(@"%@", error.localizedDescription);
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Can not upload image" message:@"Please try again at another time" viewController:self];
                
            } else {
                
                //Uploading small profile picture next
                [profileImageSmallRef putData:uploadDataSmall metadata:nil completion:^(FIRStorageMetadata * _Nullable metadataSmall, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@", error.localizedDescription);
                        
                    } else {
                        
                        [self registerUserInfo:userID
                                metaDataBigUid:[[metadataBig downloadURL] absoluteString]
                              metaDataSmallUid:[[metadataSmall downloadURL] absoluteString]];
                        
                        [hud hideAnimated:YES];
                        [self changeRoot];
                    }
                }];
                
            }
            
        }];
        
    }
    
}

-(void)registerUserInfo: (NSString *)userID metaDataBigUid:(NSString *)metaDataBigUid metaDataSmallUid:(NSString *)metaDataSmallUid {
    
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
                           kIAmDiscoverable: @(1),
                           kProfilePhoto: metaDataBigUid,
                           kSecurity: @(0)};
    
    //Set user information inside global variables
    [MY_API addNewUser:post UserID:userID FlagMy:YES];
    [[[self.firdatabase child:kUsers] child:userID] setValue:post];
    
}

-(void)changeRoot {
    
    //Set root controller to tabbar with cross dissolve animation
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setUserIsSigningIn:false];
    
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
