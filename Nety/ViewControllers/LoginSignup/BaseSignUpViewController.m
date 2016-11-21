//
//  BaseSignUpViewController.m
//  Nety
//
//  Created by Magfurul Abeer on 11/15/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "BaseSignUpViewController.h"
#import "SignUpTextField.h"
#import "SignUpTextView.h"

@interface BaseSignUpViewController ()

@end

@implementation BaseSignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 4;
    [self addImage];
    [self addLogo];
    [self addNetyTitle];
    [self addLineThatIsBlue:false];
    [self addLineThatIsBlue:true];
    [self addNavigationCircles];
    [self addNavigationLabels];
    [self constrainLineThatIsBlue:false];
    NSMutableArray *base = [@[self.blueLine, self.greyLine, self.logo, self.netyTitle, self.imageView] mutableCopy];
    [base addObjectsFromArray:self.circleButtonStack.arrangedSubviews];
    [base addObjectsFromArray:self.labelButtonStack.arrangedSubviews];
    self.baseViews = [base copy];
    self.signupStoryboard = [UIStoryboard storyboardWithName:@"Signup" bundle:nil];
    
    if (!self.userData) {
        self.userData = [[UserData alloc] init];
    }
}

# pragma mark - Add UI Component Methods

- (void)addImage {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainPicture1"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    [self addBlur];
    [self addGradient];
}

- (void)addLogo {
    self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoTransparent"]];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logo];
    self.logo.translatesAutoresizingMaskIntoConstraints = false;
    [self.logo.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = true;
    [self.logo.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor].active = true;
    [self.logo.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.25].active = true;
    [self.logo.heightAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.25].active = true;
    NSLayoutConstraint *bottom = [self.logo.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    // Need to change priority so top+bottom constraints dont conflict with height
    bottom.priority = UILayoutPriorityDefaultHigh;
    bottom.active = true;
}

- (void)addNetyTitle {
    self.netyTitle = [[UILabel alloc] init];
    self.netyTitle.text = @"NETY";
    self.netyTitle.textColor = [UIColor whiteColor];
    self.netyTitle.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:60];
    [self.view addSubview:self.netyTitle];
    self.netyTitle.translatesAutoresizingMaskIntoConstraints = false;
    [self.netyTitle.centerYAnchor constraintEqualToAnchor:self.logo.centerYAnchor].active = true;
    [self.netyTitle.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:15].active = true;
}

// Adds ONLY the circles of the navigation at the bottom
- (void)addNavigationCircles {
    NSMutableArray *circles = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < 5; i++) {
        [circles addObject:[self circleButtonWithNumber:i]];
    }
    self.circleButtonStack = [[UIStackView alloc] initWithArrangedSubviews:[circles copy]];
    self.circleButtonStack.distribution = UIStackViewDistributionEqualSpacing;
    self.circleButtonStack.alignment = UIStackViewAlignmentCenter;
    self.circleButtonStack.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.circleButtonStack];
    
    self.circleButtonStack.translatesAutoresizingMaskIntoConstraints = false;
    [self.circleButtonStack.heightAnchor constraintEqualToConstant:20].active = true;
    [self.circleButtonStack.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor constant:20].active = true;
    [self.circleButtonStack.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor constant:-20].active = true;
    [self.circleButtonStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50].active = true;
    
}

// Adds ONLY the titles of the navigation at the bottom
// Despite being called labels, they're UIButtons
- (void)addNavigationLabels {
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < 5; i++) {
        [labels addObject:[self labelButtonWithNumber:i]];
    }
    self.labelButtonStack = [[UIStackView alloc] initWithArrangedSubviews:[labels copy]];
    self.labelButtonStack.distribution = UIStackViewDistributionFillEqually;
    self.labelButtonStack.alignment = UIStackViewAlignmentTop;
    self.labelButtonStack.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.labelButtonStack];
    
    self.labelButtonStack.translatesAutoresizingMaskIntoConstraints = false;
    [self.labelButtonStack.topAnchor constraintEqualToAnchor:self.circleButtonStack.bottomAnchor].active = true;
    [self.labelButtonStack.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor].active = true;
    [self.labelButtonStack.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor].active = true;
    [self.labelButtonStack.heightAnchor constraintEqualToConstant:20].active = true;
    
}

// Does not constrain views. Only adds them.
- (void)addLineThatIsBlue: (BOOL)isBlue {
    NSString *imageName = isBlue ? @"LineBlue" : @"Line1";
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    if(isBlue) {
        self.blueLine = line;
    } else {
        self.greyLine = line;
    }
    [self.view addSubview:(isBlue ? self.blueLine : self.greyLine)];
}

// Adding and constraining are separated because the lines need
// to be added before the circles but are constrained based on
// the circles' constraints
- (void)constrainLineThatIsBlue: (BOOL)isBlue {
    UIImageView *line = isBlue ? self.blueLine : self.greyLine;
    line.translatesAutoresizingMaskIntoConstraints = false;
    [line.leadingAnchor constraintEqualToAnchor:self.circleButtonStack.leadingAnchor].active = true;
    [line.centerYAnchor constraintEqualToAnchor:self.circleButtonStack.centerYAnchor].active = true;
    [line.heightAnchor constraintEqualToConstant:2.5].active = true;
    if(isBlue) {
        CGFloat multiplier = (self.stepNumber - 1) * 0.25;
        [line.widthAnchor constraintEqualToAnchor:self.circleButtonStack.widthAnchor multiplier:multiplier].active = true;
    } else {
        [line.widthAnchor constraintEqualToAnchor:self.circleButtonStack.widthAnchor].active = true;
    }
}

# pragma mark - Visual Prep Methods

// Returns a label button with the appropriate target and name
- (UIButton *)labelButtonWithNumber: (NSUInteger)number {
    UIButton *label = [[UIButton alloc] init];
    [label setTitle:[self titleForNumber:number] forState:UIControlStateNormal];
    label.titleLabel.text = [self titleForNumber:number];
    label.titleLabel.textColor = [UIColor whiteColor];
    label.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    
    SEL target = [self actionForNumber:number];
    
    [label addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    return label;
}

// Returns a circle button with the appropriate target
- (UIButton *)circleButtonWithNumber: (NSUInteger)number {
    UIButton *circle = [[UIButton alloc] init];
    [circle setImage:[UIImage imageNamed:@"Gray Circle"] forState:UIControlStateNormal];
    circle.imageView.image = [UIImage imageNamed:@"Gray Circle"];
    circle.translatesAutoresizingMaskIntoConstraints = false;
    [circle.widthAnchor constraintEqualToAnchor:circle.heightAnchor].active = true;
    
    SEL target = [self actionForNumber:number];
    
    [circle addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    return circle;
}

// Returns the title for the nav label
- (NSString *)titleForNumber: (NSUInteger)number {
    switch (number) {
        case 0:
            return @"Name";
        case 1:
            return @"Account";
        case 2:
            return @"WhoYouAre";
        case 3:
            return @"Experience";
        case 4:
            return @"Image";
        default:
            return nil;
            break;
    }
}

// Returns the selector for appropriate nav button
- (SEL)actionForNumber: (NSUInteger)number {
    switch (number) {
        case 0:
            return @selector(nameButtonTapped:);
        case 1:
            return @selector(accountButtonTapped:);
        case 2:
            return @selector(whoYouAreButtonTapped:);
        case 3:
            return @selector(experienceButtonTapped:);
        case 4:
            return @selector(imageButtonTapped:);
        default:
            return nil;
            break;
    }
}

- (void)addGradient {
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = self.imageView.bounds;
    gradientMask.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor,
                            (id)[UIColor blackColor].CGColor];
    [self.imageView.layer addSublayer:gradientMask];
}

- (void)addBlur {
    CIContext *context = [CIContext contextWithOptions:nil];
    
    UIImage *image = self.imageView.image;
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setDefaults];
    [clampFilter setValue:inputImage forKey:kCIInputImageKey];
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:clampFilter.outputImage forKey:kCIInputImageKey];
    [blurFilter setValue:@3.5f forKey:@"inputRadius"];
    
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *resultImage = [[UIImage alloc] initWithCGImage:cgImage scale:image.scale orientation:UIImageOrientationUp];
    
    self.imageView.image = resultImage;
}

// Makes the correct circles blue
- (void)prepareNavigation {
    for(NSUInteger i = 0; i < self.stepNumber; i ++) {
        UIButton *circleButton = self.circleButtonStack.arrangedSubviews[i];
        UIButton *labelButton = self.labelButtonStack.arrangedSubviews[i];
        
        circleButton.imageView.image = [UIImage imageNamed:@"Blue Circle"];
        [circleButton setImage:[UIImage imageNamed:@"Blue Circle"] forState:UIControlStateNormal];
        circleButton.tag = 5;
        [labelButton setTitleColor:[UIColor colorWithRed:21/255.0 green:122/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
        labelButton.titleLabel.textColor = [UIColor colorWithRed:21/255.0 green:122/255.0 blue:251/255.0 alpha:1.0];
        labelButton.tag = 5;
    }
}



#pragma mark - IBActions

- (void)nameButtonTapped:(UIButton *)sender {
    if (sender.tag == 5) {
        NSLog(@"Name button tapped");
    }
}

- (void)accountButtonTapped:(UIButton *)sender {
    if (sender.tag == 5) {
        NSLog(@"Account button tapped");
    }
}

- (void)whoYouAreButtonTapped:(UIButton *)sender {
    if (sender.tag == 5) {
        NSLog(@"WhoYouAre button tapped");
    }
}

- (void)experienceButtonTapped:(UIButton *)sender {
    if (sender.tag == 5) {
        NSLog(@"Experience button tapped");
    }
}

- (void)imageButtonTapped:(UIButton *)sender {
    if (sender.tag == 5) {
        NSLog(@"Image button tapped");
    }
}


// Take number of step and keep popping view controllers until desired vc is reached 


#pragma mark - UITextFieldDelegate && UITextViewDelegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    SignUpTextField *field = (SignUpTextField *)textField;
    field.floatingLabel.text = field.titlePlaceholder;
    NSLog(@"text field editing base sign up");
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    SignUpTextView *view = (SignUpTextView *)textView;
    view.floatingLabel.text = view.titlePlaceholder;
}

#pragma mark - Misc

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BaseSignUpViewController *vc = segue.destinationViewController;
    vc.userData = self.userData;
}
@end
