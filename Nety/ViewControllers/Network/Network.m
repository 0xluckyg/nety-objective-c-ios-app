//
//  Network.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Network.h"
#import "UIPrinciples.h"

@interface Network ()

@end

@implementation Network

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
}

-(void) initializeDesign {
    
    // UIPrinciples class from Util folder
    UIPrinciples *UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set navbar color
    self.topBar.backgroundColor = UIPrinciple.color;
    [[UINavigationBar appearance] setBarTintColor:UIPrinciple.color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
