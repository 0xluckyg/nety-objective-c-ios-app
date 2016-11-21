//
//  ImageSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "ImageSignUpVC.h"

@interface ImageSignUpVC ()
@property (weak, nonatomic) IBOutlet UILabel *finallyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLookLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) UIImage *chosenImage;
@end

@implementation ImageSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 5;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.imageView.image = [UIImage imageNamed:@"MainPicture2"];
    
//    self.imageButton.layer.cornerRadius = self.imageButton.frame.size.height/2;
    self.imageButton.imageView.layer.cornerRadius = self.imageButton.frame.size.height/2;
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (IBAction)imageButtonWasTapped:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
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

- (IBAction)skipButtonWasTapped:(UIButton *)sender {
    
}


@end
