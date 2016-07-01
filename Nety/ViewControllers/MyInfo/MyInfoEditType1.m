//
//  MyInfoEditType1.m
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditType1.h"

@interface MyInfoEditType1 ()

@end

@implementation MyInfoEditType1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeDesign];
}

- (void)initializeDesign {
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    self.topBar.backgroundColor = self.UIPrinciple.netyBlue;
    
    self.navBar.backgroundColor = self.UIPrinciple.netyBlue;
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextField *)textView
{
    // You may need to check that it is the right textView if you have more than one.
    textView.attributedText = nil;
    return YES;
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end



























