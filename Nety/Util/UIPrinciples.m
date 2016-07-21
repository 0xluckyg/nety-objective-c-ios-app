//
//  UIPrinciples.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "UIPrinciples.h"
#import "AppDelegate.h"
#import "NoContent.h"

@implementation UIPrinciples

- (instancetype)init
{
    self = [super init];
    if (self) {
        _netyBlue = [UIColor colorWithRed:73.0f/255.0f green:101.0f/255.0f blue:146.0f/255.0f alpha:1.0f];
        _netyRed = [UIColor colorWithRed:220.0f/255.0f green:68.0f/255.0f blue:55.0f/255.0f alpha:1.0f];
        _netyGray = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        _netyTransparent = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
        _defaultGray = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:194.0f/255.0f alpha:1.0f];
        _linkedInBlue = [UIColor colorWithRed:0.0/255.0f green:123.0/255.0f blue:181.0/255.0f alpha:1.0f];
        _facebookBlue = [UIColor colorWithRed:59.0/255.0f green:89.0/255.0f blue:152.0/255.0f alpha:1.0f];
        
        _netyFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
        
    }
    return self;
}

- (void)oneButtonAlert: (NSString *)buttonTitle controllerTitle:(NSString *)controllerTitle message:(NSString *)message viewController:(UIViewController *)viewController {
    
    UIAlertAction *button = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:controllerTitle
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:button];
    [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)twoButtonAlert: (UIAlertAction *)leftButton rightButton:(UIAlertAction *)rightButton controller:(NSString *)controllerTitle message:(NSString *)message viewController:(UIViewController *)viewController {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:controllerTitle
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:leftButton];
    [alert addAction:rightButton];
    [viewController presentViewController:alert animated:YES completion:nil];
    
    
}

-(UIFont*)netyFontWithSize: (int)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

-(void)removeNoContent: (NoContent *)noContentController {
    
    [noContentController.view removeFromSuperview];
    
}

-(void)addNoContent: (UIViewController *)viewController setText:(NSString*)text noContentController:(NoContent *)noContentController {
    
    noContentController.view.frame = CGRectMake(0, viewController.view.frame.size.height/2 - 50, viewController.view.frame.size.width, 150);
    
    [noContentController.view setBackgroundColor:self.netyTransparent];
    
    [noContentController.label setTextColor:[UIColor whiteColor]];
    
    noContentController.label.text = text;
    
    [viewController.navigationController.view addSubview:noContentController.view];
}

-(void)addTopbarColor: (UIViewController *)viewController {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=self.netyBlue;
    [viewController.view addSubview:view];
}

-(void)addNavBar: (UIViewController *)viewController setTitle:(NSString *)setTitle{
    
    //Set navbar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50)];
    navbar.backgroundColor = self.netyBlue;
    [navbar setTranslucent:NO];
    
    //Set navbar items
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = setTitle;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    navItem.leftBarButtonItem = leftButton;
    
    navbar.items = @[navItem];
    
    [viewController.view addSubview:navbar];
    
}

@end
