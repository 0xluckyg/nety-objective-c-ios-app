//
//  SignupProcess3.m
//  Nety
//
//  Created by Scott Cho on 7/6/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "SignupProcess3.h"
#import "AppDelegate.h"

@interface SignupProcess3 ()

@end

@implementation SignupProcess3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSettings];
    [self initializeDesign];
}

- (void)initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
    [self.firdatabase observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot.value);
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addProfileImage:(id)sender {
    
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = (id)self;
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerLibrary animated:YES completion:nil];
    
}

//When photo choosing screen shows, customize nav controller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.profileImage.image = pickedImage;
    [self.doneButtonOutlet setTitle:@"Done" forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
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
    
    NSMutableDictionary *experiences = [[NSMutableDictionary alloc] init];
    NSMutableArray *experienceArray = [self.userInfo objectAtIndex:7];
    NSString *userID = [[[self.userInfo objectAtIndex:0] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    for (int i = 0; i < [experienceArray count]; i ++) {
        NSString *experienceKey = [NSString stringWithFormat:@"experience%@",[@(i) stringValue]];
        [experiences setObject:[experienceArray objectAtIndex:i] forKey:experienceKey];
    }
    
    NSDictionary *post = @{@"firstName": [self.userInfo objectAtIndex:2],
                           @"lastName": [self.userInfo objectAtIndex:3],
                           @"age": [self.userInfo objectAtIndex:4],
                           @"status": @"",
                           @"identity": [self.userInfo objectAtIndex:5],
                           @"summary": [self.userInfo objectAtIndex:6],
                           @"experiences": experiences};
    
    [[[self.firdatabase child:@"users"] child:userID] setValue:post];
    
    [self changeRoot];
    
}

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

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
