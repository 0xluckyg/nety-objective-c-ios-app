//
//  MyInfo.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyInfo ()

@end

@implementation MyInfo


#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self initializeSettings];
    
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    self.nameLabel.text = MY_USER.firstName;
    
    if ([MY_USER.identity isEqualToString:@""]) {
        self.identityLabel.text = @"You haven't described who you are!";
    } else {
        self.identityLabel.text = MY_USER.identity;
    }
    
    if ([MY_USER.status isEqualToString:@""]) {
        self.userStatusInfo.text = @"You haven't set a status yet!";
    } else {
        self.userStatusInfo.text = MY_USER.status;
    }
    
    if ([MY_USER.summary isEqualToString:@""]) {
        self.userSummaryInfo.text = @"You haven't set a summary yet!";
    } else {
        self.userSummaryInfo.text = MY_USER.summary;
    }
    
    self.experienceArray = [NSMutableArray arrayWithArray:[MY_USER.experiences allObjects]];
    
    if ([self.experienceArray count] > 0) {
        
        NSString *experienceString = @"";
        
        for (int i = 0; i < [self.experienceArray count]; i ++) {
            
            NSString *experienceStringAdd = [NSString stringWithFormat:@"%@\r%@ ~ %@\r\r%@\r\r\r",
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceName],
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceStartDate],
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceEndDate],
                                             [[self.experienceArray objectAtIndex:i] objectForKey:kExperienceDescription]
                                             ];
            
            experienceString = [experienceString stringByAppendingString:experienceStringAdd];
        }
        
        self.userExperienceInfo.text = experienceString;
        
    } else {
        
        self.experienceArray = [[NSMutableArray alloc] init];
        
        self.userExperienceInfo.text = @"You didn't add any experience or interest yet";
    }
    
    [self.userProfileImage sd_setImageWithURL:[NSURL URLWithString:MY_USER.profileImageUrl] placeholderImage:[UIImage imageNamed:kDefaultUserLogoName] completed:nil];
    
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set background color
    [self.view setBackgroundColor:self.UIPrinciple.netyBlue];
    
    //Color for the small view
    self.userBasicInfoView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    
    //Color for the big view
    self.userInfoView.backgroundColor = self.UIPrinciple.netyBlue;
    
    self.userInfoViewTopConstraint.constant = self.view.frame.size.height / 2.3;
    
    
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
    
    [self changeImage:picker getInfo:info];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Buttons
//---------------------------------------------------------


//For image tapped
- (IBAction)imageTapped:(id)sender {
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = (id)self;
    pickerLibrary.allowsEditing = YES;
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerLibrary animated:YES completion:nil];
    
    NSLog(@"tapped");
}



#pragma mark - View Disappear
//---------------------------------------------------------


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"myInfoEditTableSegue"]) {
        MyInfoEditTable *editTableVC = [segue destinationViewController];
        
        editTableVC.experienceArray = self.experienceArray;
        
    } else if ([segue.identifier isEqualToString:@"myInfoEditStatusSegue"]) {
        MyInfoEditType2 *editTableVC = [segue destinationViewController];
        
        editTableVC.statusOrSummary = 0;
    
    } else if ([segue.identifier isEqualToString:@"myInfoEditSummarySegue"]) {
        MyInfoEditType2 *editTableVC = [segue destinationViewController];
        
        editTableVC.statusOrSummary = 1;
    }
}


#pragma mark - Custom methods
//---------------------------------------------------------


-(void)changeImage: (UIImagePickerController *)picker getInfo:(NSDictionary *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *editedimage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (![UIImagePNGRepresentation(image) isEqualToData:UIImagePNGRepresentation(editedimage)]) {
        image = editedimage;
    }
    
    
    //Get userID and save to database
    NSString *userID = MY_USER.userID;
    
    //Uploading profile image
    NSString *uniqueImageID = [[NSUUID UUID] UUIDString];
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *profileImageRef = [[[storage reference] child:@"profileImages"] child:uniqueImageID];
    
    //If user doesn't set profile image, set it to default image without uploading it.
    NSData *pickedImage = UIImagePNGRepresentation(image);
    NSData *originalImage = UIImagePNGRepresentation(self.userProfileImage.image);
    
    if (![originalImage isEqualToData:pickedImage]) {
        
        NSData *uploadData = pickedImage;
        
        [profileImageRef putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Can not upload image" message:@"Please try again at another time" viewController:self];
                
            } else {
                
                NSLog(@"image url saved");
                
                [[[[self.firdatabase child:kUsers] child:userID] child:kProfilePhoto] setValue: [[metadata downloadURL] absoluteString]];
                
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
