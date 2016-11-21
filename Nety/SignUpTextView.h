//
//  SignUpTextView.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
@import JVFloatLabeledTextField;

@interface SignUpTextView : JVFloatLabeledTextView

@property (strong, nonatomic) NSString *titlePlaceholder;
@property (strong, nonatomic) UIView *border;

- (void)addBorder;

@end
