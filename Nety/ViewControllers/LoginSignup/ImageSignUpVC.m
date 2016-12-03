//
//  ImageSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "ImageSignUpVC.h"
#import "UIPrinciples.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AppDelegate.h"

@import Firebase;

@interface ImageSignUpVC ()
@property (weak, nonatomic) IBOutlet UILabel *finallyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLookLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) UIImage *chosenImage;
@property (strong, nonatomic) FIRDatabaseReference *firdatabase;
@property (strong, nonatomic) UIPrinciples *UIPrinciple;
@property (strong,nonatomic) LocationShareModel *shareModel;
@end

@implementation ImageSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 5;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.imageView.image = [UIImage imageNamed:@"MainPicture2"];
    
    self.imageButton.imageView.layer.cornerRadius = self.imageButton.frame.size.height/2;
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self initializeSettings];
    
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.userData.profilePicture) {
        [self.imageButton setImage:self.userData.profilePicture forState:UIControlStateNormal];
        [self.imageButton setImage:self.userData.profilePicture forState:UIControlStateHighlighted];
    }
}

- (void)initializeSettings {
    self.firdatabase = [[FIRDatabase database] reference];
    self.UIPrinciple = [[UIPrinciples alloc] init];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"imagepicker finished");

    [picker dismissViewControllerAnimated:true completion:^{
        
    }];
    
    self.chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageButton.imageView.image = self.chosenImage;
    [self.imageButton setImage:self.chosenImage forState:UIControlStateNormal];
    [self.imageButton setImage:self.chosenImage forState:UIControlStateSelected];
    self.finallyLabel.text = @"Wow ...";
    self.goodLookLabel.text = @"Not too shabby";
    self.userData.profilePicture = self.chosenImage;
}

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
//    NSData *logoImage = UIImagePNGRepresentation([UIImage imageNamed:kDefaultUserLogoName]);
//    NSData *pickedImage = UIImagePNGRepresentation(self.chosenImage);
    
    if (self.chosenImage) {
        UIImage *bigProfileImage = self.chosenImage;
        UIImage *smallProfileImage = [self.UIPrinciple scaleDownImage:self.chosenImage];
        
        NSData *uploadDataBig = UIImagePNGRepresentation(bigProfileImage);
        NSData *uploadDataSmall = UIImagePNGRepresentation(smallProfileImage);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"Uploading";
        hud.bezelView.color = [self.UIPrinciple.netyTheme colorWithAlphaComponent:0.3f];
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
    } else {
        [self registerUserInfo:userID metaDataBigUid:kDefaultUserLogoName metaDataSmallUid:kDefaultUserLogoName];
    }
    [self changeRoot];
}

-(void)registerUserInfo: (NSString *)userID metaDataBigUid:(NSString *)metaDataBigUid
metaDataSmallUid:(NSString *)metaDataSmallUid {
    
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    NSMutableArray *experienceArray = self.userData.experiences;
    
    for (int i = 0; i < [experienceArray count]; i ++) {
        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
        [experiences setObject:experienceArray[i] forKey:experienceKey];
    }
    NSArray *fullName = [self.userData.name componentsSeparatedByString:@" "];
    
    NSDictionary *post = @{kFirstName: fullName[0],
                           kLastName: fullName[1],
                           kAge: @(self.userData.age), // TODO: Change later
                           kStatus: @"",
                           kIdentity: self.userData.occupation,
                           kSummary: self.userData.bio,
                           kExperiences: [experiences copy],
                           kIAmDiscoverable: @(20000),
                           kProfilePhoto: metaDataBigUid,
                           kSecurity: @(0)};
    //Set user information inside global variables
    CLLocation *myLocation = [self getBestLocation];
    
    NSLog(@"post %@", post);
    
    [MY_API addNewUser:post UserID:userID Location:myLocation FlagMy:YES];
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



#pragma mark - IBActions

- (IBAction)imageButtonWasTapped:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)skipButtonWasTapped:(UIButton *)sender {
//    self.chosenImage = [UIImage imageNamed:kDefaultUserLogoName];
    NSString *userID = [[self.userData.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [self registerUserInfo:userID
            metaDataBigUid:kDefaultUserLogoName
          metaDataSmallUid:@""];
}

- (IBAction)doneButtonTapped:(UIButton *)sender {
    NSString *userID = [[self.userData.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [self uploadImage:userID];
}


-(void)goToNextPage {
    if (self.chosenImage) {
        self.chosenImage = [UIImage imageNamed:kDefaultUserLogoName];
    }
    NSString *userID = [[self.userData.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [self uploadImage:userID];
}

#pragma mark - Custom

- (CLLocation *) getBestLocation {
    
    LocationShareModel *shareModel = [LocationShareModel sharedModel];
    CLLocation *myLocation = [CLLocation alloc];
    
    //Set distance
    if ([shareModel.myLocationArray count] != 0) {
        //Pick best location accuracy
        int bestAccuracy = 0;
        int bestLocationIndex = 0;
        for (int i = 0; i < [shareModel.myLocationArray count]; i ++) {
            if ([[shareModel.myLocationArray[i] objectForKey:@"theAccuracy"] floatValue] > bestAccuracy) {
                bestAccuracy = [[shareModel.myLocationArray[i] objectForKey:@"theAccuracy"] floatValue];
                bestLocationIndex = i;
            }
        }
        
        myLocation = [myLocation initWithLatitude:[[shareModel.myLocationArray[bestLocationIndex] objectForKey:@"latitude"] floatValue] longitude:[[shareModel.myLocationArray[bestLocationIndex] objectForKey:@"longitude"] floatValue]];
        
        return myLocation;
    } else {
        return nil;
    }
}

@end
