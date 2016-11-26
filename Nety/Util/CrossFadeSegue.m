//
//  CrossFadeSegue.m
//  Nety
//
//  Created by Magfurul Abeer on 11/26/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "CrossFadeSegue.h"
//#import "Constants.h"

@implementation CrossFadeSegue

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition *transition = kCrossFadeAnimation();
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
    
}

@end
