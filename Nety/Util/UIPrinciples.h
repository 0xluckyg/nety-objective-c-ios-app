//
//  UIPrinciples.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIPrinciples : NSObject

@property (nonatomic, strong) UIColor *netyBlue;
@property (nonatomic, strong) UIColor *netyRed;
@property (nonatomic, strong) UIColor *netyGray;
@property (nonatomic, strong) UIColor *netyTransparent;
@property (nonatomic, strong) UIColor *defaultGray;

-(void)addTopbarColor: (UIViewController *)viewController;

@end
