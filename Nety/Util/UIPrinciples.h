//
//  UIPrinciples.h
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NoContent.h"

@interface UIPrinciples : NSObject

@property (nonatomic, strong) UIColor *netyBlue;
@property (nonatomic, strong) UIColor *netyRed;
@property (nonatomic, strong) UIColor *netyGray;
@property (nonatomic, strong) UIColor *netyTransparent;
@property (nonatomic, strong) UIColor *defaultGray;
@property (nonatomic, strong) UIColor *linkedInBlue;
@property (nonatomic, strong) UIColor *facebookBlue;

@property (nonatomic, strong) UIFont *netyFont;

- (void)oneButtonAlert: (NSString *)buttonTitle controllerTitle:(NSString *)controllerTitle message:(NSString *)message viewController:(UIViewController *)viewController;

- (void)twoButtonAlert: (UIAlertAction *)leftButton rightButton:(UIAlertAction *)rightButton controller:(NSString *)controllerTitle message:(NSString *)message viewController:(UIViewController *)viewController;


-(void)addTopbarColor: (UIViewController *)viewController;
-(UIFont*)netyFontWithSize: (int)size;

-(void)addNoContent: (UIViewController *)viewController setText:(NSString*)text setImage:(UIImage *)contentImage setColor:(UIColor *)color noContentController:(NoContent *)noContentController;

-(void)removeNoContent: (NoContent *)noContentController;

-(UIImage*)scaleDownImage:(UIImage*)img;

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated sender:(UIViewController *)viewController completion:(void (^)(BOOL))completion;

- (BOOL)tabBarIsVisible: (UIViewController *)viewController;

@end
