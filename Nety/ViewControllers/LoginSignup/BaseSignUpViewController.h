//
//  BaseSignUpViewController.h
//  Nety
//
//  Created by Magfurul Abeer on 11/15/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//
// This is just a base class for the signup view controllers
// It has the background image, the nety branding, and the progress bar

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface BaseSignUpViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

// stepNumber is used to color the progress bar appropriately
@property (assign, nonatomic) NSUInteger stepNumber;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UILabel *netyTitle;
@property (assign, nonatomic) BOOL viewNeedsToBeMovedUp;
@property (assign, nonatomic) CGRect originalFrame;
@property (strong, nonatomic) UIStackView *circleButtonStack;
@property (strong, nonatomic) UIStackView *labelButtonStack;
//@property (strong, nonatomic) NSArray *labelButtons;
@property (weak, nonatomic) UIImageView *blueLine;
@property (weak, nonatomic) UIImageView *greyLine;
@property (strong, nonatomic) NSArray *baseViews;
@property (strong, nonatomic) UIStoryboard *signupStoryboard;
@property (strong, nonatomic) UserData *userData;
@property (strong, nonatomic) NSArray *fields;
- (void)prepareNavigation;
- (void)constrainLineThatIsBlue: (BOOL)isBlue;
- (void)viewWasTapped;
@end
