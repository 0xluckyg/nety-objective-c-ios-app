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
    self.bioTextView.delegate = self;
    
    self.fields = @[self.positionTextField, self.bioTextView];
}

- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    
    if ([textField.titlePlaceholder isEqualToString:@"Occupation"]) {
        
        if (true) {
            self.whatDoYouDoLabel.text = @"Oh. Interesting ...";
            [self.bioTextView becomeFirstResponder];
        }
    }
    
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        // TODO: Figure out what the minimum is
        if (self.positionTextField.text.length > 3 && self.bioTextView.text.length > 3) {
            [textView resignFirstResponder];
            self.userData.occupation = self.positionTextField.text;
            self.userData.bio = self.bioTextView.text;
            [self performSegueWithIdentifier:@"ToExperienceSegue" sender:self];
        }
        return NO;
    }else{
        return YES;
    }
}


@end
