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
//        _netyBlue = [UIColor colorWithRed:226.0f/255.0f green:150.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
//        _netyBlue = [UIColor colorWithRed:122.0f/255.0f green:118.0f/255.0f blue: 193.0f/255.0f alpha:1.0f];
        _netyRed = [UIColor colorWithRed:220.0f/255.0f green:68.0f/255.0f blue:55.0f/255.0f alpha:1.0f];
        _netyGray = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        _netyTransparent = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
        _defaultGray = [UIColor colorWithRed:167.0f/255.0f green:167.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        _lightGray = [UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1.0f];
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

-(void)addNoContent: (UIViewController *)viewController setText:(NSString*)text setImage:(UIImage *)contentImage setColor:(UIColor *)color setSecondColor:(UIColor *)secondColor noContentController:(NoContent *)noContentController {
    
    float width = viewController.view.frame.size.width;
    float height = noContentController.view.frame.size.height;
    float xValue = 0;
    float yValue = viewController.view.frame.size.height/2 - height/2;
    
    noContentController.view.frame = CGRectMake(xValue, yValue, width, height);
    
    [noContentController.view setBackgroundColor:[UIColor clearColor]];
    
    [noContentController.label setTextColor:[UIColor whiteColor]];
    
    noContentController.label.text = text;
    noContentController.label.textColor = secondColor;
    
    noContentController.image.image = contentImage;
    [noContentController.image setTintColor:color];
    
    [viewController.view addSubview:noContentController.view];
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


//tabbartransition
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated sender:(UIViewController *)viewController completion:(void (^)(BOOL))completion {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible:viewController] == visible) return (completion)? completion(YES) : nil;
    
    // get a frame calculation ready
    CGRect frame = viewController.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        viewController.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:completion];
}

// know the current state
- (BOOL)tabBarIsVisible: (UIViewController *)viewController {
    return viewController.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(viewController.view.frame);
}

//Uploading image to server (make 10 times smaller)
-(UIImage*)scaleDownImage:(UIImage*)img {
    
    CGSize newSize = CGSizeMake(img.size.width / 13, img.size.height / 13);

    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
