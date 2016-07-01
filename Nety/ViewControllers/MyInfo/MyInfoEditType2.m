//
//  MyInfoEditType2.m
//  Nety
//
//  Created by Scott Cho on 6/28/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfoEditType2.h"

@interface MyInfoEditType2 ()

@end

@implementation MyInfoEditType2

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
    
    self.editType2Label.text = @"Summary";
    self.editType2Label.textColor = self.UIPrinciple.netyBlue;
    
    self.editType2TextFieldView.backgroundColor = self.UIPrinciple.netyGray;
    self.editType2TextField.text = @"Write a summary about yourself!";
    self.editType2TextField.textColor = self.UIPrinciple.netyBlue;
    self.editType2TextField.backgroundColor = self.UIPrinciple.netyGray;

    [self.saveButtonOutlet setTintColor:self.UIPrinciple.netyBlue];
    
    
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

- (IBAction)saveButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end



























