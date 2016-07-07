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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.view.backgroundColor = self.UIPrinciple.netyBlue;
    self.holdingView.backgroundColor = self.UIPrinciple.netyBlue;
    
    self.logoImage.image = [UIImage imageNamed:@"LogoTransparent"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
}

- (IBAction)signupButton:(id)sender {
}

















@end
