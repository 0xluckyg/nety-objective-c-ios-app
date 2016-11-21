//
//  SignUpTextField.h
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

IB_DESIGNABLE
@interface SignUpTextField : JVFloatLabeledTextField 

IBInspectable
@property (strong, nonatomic) NSString *titlePlaceholder;
@property (strong, nonatomic) UIView *border;

@end
