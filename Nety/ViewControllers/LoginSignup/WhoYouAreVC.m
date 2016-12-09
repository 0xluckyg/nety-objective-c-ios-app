//
//  WhoYouAreVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/17/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "WhoYouAreVC.h"

@interface WhoYouAreVC ()

@end

@implementation WhoYouAreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 3;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    
    [self.bioTextView addBorder];
    self.imageView.image = [UIImage imageNamed:@"MainPicture9"];
    
    self.positionTextField.delegate = self;
    //    self.bioTextView.delegate = self;
    
    self.fields = @[self.positionTextField, self.bioTextView];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.userData.occupation) {
        self.positionTextField.text = self.userData.occupation;
    }
    
    if (self.userData.bio) {
        self.bioTextView.text = self.userData.bio;
    }
}

- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    
    if ([textField.titlePlaceholder isEqualToString:@"Occupation"]) {
        
        if ([self occupationIsValid:YES]) {
            [self.bioTextView becomeFirstResponder];
        }
    }
    
    return YES;
}

//- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if([text isEqualToString:@"\n"]){
//        // TODO: Figure out what the minimum is
//        [self goToNextPage];
//        return NO;
//    }else{
//        return YES;
//    }
//}


-(BOOL)occupationIsValid: (BOOL)display {
    NSString *occupation = self.positionTextField.text;
    
    if (occupation.length < 5) {
        if (display) { self.whatDoYouDoLabel.text = @"Minimum 5 characters"; }
        return NO;
    }
    if (display) { self.whatDoYouDoLabel.text = @"Oh. Interesting!"; }
    return YES;
}

-(BOOL)bioIsValid: (BOOL)display {
    NSString *occupation = self.bioTextView.text;
    
    if (occupation.length < 5) {
        if (display) { self.tellMeMoreAboutYouLabel.text = @"Minimum 5 characters"; }
        return NO;
    }
    if (display) { self.tellMeMoreAboutYouLabel.text = @"Great!"; }
    return YES;
}

-(BOOL)allFieldsAreValidated: (BOOL)display {
    return [self occupationIsValid:display] && [self bioIsValid:display];
}

-(void)viewWasTapped {
    [super viewWasTapped];
    if ([self allFieldsAreValidated: NO]) {
        [self goToNextPage];
    } else if ([self occupationIsValid:NO]) {
        [self.bioTextView becomeFirstResponder];
    } else {
        [self.positionTextField becomeFirstResponder];
    }
}

-(void)goToNextPage {
    self.userData.occupation = self.positionTextField.text;
    self.userData.bio = self.bioTextView.text;
    [self performSegueWithIdentifier:@"ToExperienceSegue" sender:self];
}


@end
