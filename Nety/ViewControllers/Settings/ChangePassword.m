//
//  ChangePassword.m
//  Nety
//
//  Created by Scott Cho on 9/12/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "ChangePassword.h"

@interface ChangePassword ()

@end

@implementation ChangePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeSettings];
    [self initializeDesign];
}

- (void) initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];

}

- (void) initializeDesign {
    
    [self.passwordOld setPlaceholder:@"Old Password"];
    [self.passwordNew setPlaceholder:@"New Password"];
    [self.passwordNewRepeat setPlaceholder:@"Repeat Password"];
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.navigationItem.title = @"Change Password";
    
    //Style the navigation bar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    //Style the navigation bar
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:normal target:self action:@selector(doneButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes forState:normal];
    
    [self.tableView setAllowsSelection:NO];
    
}

-(void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) doneButtonPressed {
    
    if (![self.passwordNew.text isEqualToString:self.passwordNewRepeat.text]) {
    
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil) message:@"You repeated an incorrect password" viewController:self];
        
    } else if ([self.passwordNew.text isEqualToString:self.passwordOld.text]) {
        
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil) message:@"Your new password can't be same as your old password" viewController:self];
        
    } else if (self.passwordNew.text.length > 15 || self.passwordNew.text.length < 6) {
        
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil) message:NSLocalizedString(@"invalidPasswordDescription", nil) viewController:self];
        
    } else {
        
//         *userData = [[[FIRAuth auth] currentUser] providerData];
//        
//        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
//            for userInfo in providerData {
//                switch userInfo.providerID {
//                case "facebook.com":
//                    print("user is signed in with facebook")
//                default:
//                    print("user is signed in with \(userInfo.providerID)")
//                }
//            }
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
