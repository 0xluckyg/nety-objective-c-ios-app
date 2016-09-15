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
    
    [self.passwordOld setPlaceholder:NSLocalizedString(@"passwordOld", nil)];
    [self.passwordNew setPlaceholder:NSLocalizedString(@"passwordNew", nil)];
    [self.passwordNewRepeat setPlaceholder:NSLocalizedString(@"passwordRepeat", nil)];
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.navigationItem.title = NSLocalizedString(@"changePassword", nil);
    
    //Style the navigation bar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(backButtonPressed)];
    
    //Style the navigation bar
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil) style:normal target:self action:@selector(doneButtonPressed)];
    
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
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        for (id<FIRUserInfo> profile in user.providerData) {
            if ([profile.providerID isEqualToString:@"facebook.com"]) {
                [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidChangePasswordTitle", nil) message:NSLocalizedString(@"invalidChangePasswordDescription", nil) viewController:self];
                [self.navigationController popViewControllerAnimated:YES];

            }
        }
        
        //Change password process
        if (![self.passwordNew.text isEqualToString:self.passwordNewRepeat.text]) {
            
            [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil) message: NSLocalizedString(@"incorrectPasswordChange1", nil) viewController:self];
            
        } else if ([self.passwordNew.text isEqualToString:self.passwordOld.text]) {
            
            [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil) message: NSLocalizedString(@"incorrectPasswordChange2", nil) viewController:self];
            
        } else if (self.passwordNew.text.length > 15 || self.passwordNew.text.length < 6) {
            
            [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"invalidPasswordTitle", nil) message:NSLocalizedString(@"invalidPasswordDescription", nil) viewController:self];
            
        } else {
            
            FIRUser *user = [FIRAuth auth].currentUser;
            NSString *newPassword = self.passwordNew.text;
            
            [user updatePassword:newPassword completion:^(NSError *_Nullable error) {
                if (error) {
                    [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"errorTitle", nil) message:NSLocalizedString(@"errorDescription", nil) viewController:self];
                    
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    } else {
        [self.UIPrinciple oneButtonAlert:NSLocalizedString(@"ok", nil) controllerTitle:NSLocalizedString(@"errorTitle", nil) message:NSLocalizedString(@"errorDescription", nil) viewController:self];
        
        [self.navigationController popViewControllerAnimated:YES];
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
