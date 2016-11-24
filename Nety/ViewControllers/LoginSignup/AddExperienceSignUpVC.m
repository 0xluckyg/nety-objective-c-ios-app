//
//  AddExperienceSignUpVC.m
//  NetySignUp
//
//  Created by Magfurul Abeer on 11/18/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "AddExperienceSignUpVC.h"
#import "SignUpTextView.h"
#import "SignUpTextField.h"
#import "Regex.h"

@interface AddExperienceSignUpVC ()
@property (weak, nonatomic) IBOutlet UIButton *noDatesButton;
@property (weak, nonatomic) IBOutlet UIButton *presentButton;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *whatDidYouDoLabel;
@property (weak, nonatomic) IBOutlet UILabel *whenDidYouDoItLabel;
@property (weak, nonatomic) IBOutlet UILabel *tellMeMoreLabel;
@property (weak, nonatomic) IBOutlet SignUpTextField *positionTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *startTextField;
@property (weak, nonatomic) IBOutlet SignUpTextField *endTextField;
@property (weak, nonatomic) IBOutlet SignUpTextView *detailsTextView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (assign, nonatomic) CGFloat displacement;
@property (weak, nonatomic) SignUpTextField *activeField;
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation AddExperienceSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepNumber = 4;
    [self prepareNavigation];
    [self constrainLineThatIsBlue:YES];
    self.imageView.image = [UIImage imageNamed:@"MainPicture2"];
    
    self.positionTextField.delegate = self;
    self.startTextField.delegate = self;
    self.endTextField.delegate = self;
    self.detailsTextView.delegate = self;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.startTextField setInputView:self.datePicker];
    [self.endTextField setInputView:self.datePicker];
    
//    self.dateFromTextField.tag = 1;
//    self.dateToTextField.tag = 2;
    
    self.fields = @[self.positionTextField, self.startTextField, self.endTextField, self.detailsTextView];

    NSMutableArray *base = [self.baseViews mutableCopy];
    [base addObjectsFromArray:@[self.positionTextField, self.startTextField, self.endTextField, self.detailsTextView, self.whatDidYouDoLabel, self.whenDidYouDoItLabel, self.tellMeMoreLabel, self.toLabel, self.addButton, self.skipButton, self.noDatesButton, self.presentButton]];
    self.baseViews = [base copy];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"MM/dd/YYYY"];
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (IBAction)skipButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(SignUpTextField *)textField {
    
    if ([textField.titlePlaceholder isEqualToString:@"Position"]) {
        // Add validations here
        if (textField.text.length > 3) {
            self.whatDidYouDoLabel.text = @"Nice!";
            [self.startTextField becomeFirstResponder];
        }
    }
    
    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(SignUpTextField *)textField {
    [super textFieldDidBeginEditing:textField];
    self.activeField = textField;
    return YES;
}

-(void)textFieldDidBeginEditing:(SignUpTextField *)textField {
    NSLog(@"DATE BEFORE: %@", [self.formatter stringFromDate:self.datePicker.date]);
    BOOL isDateField = [self.activeField.titlePlaceholder isEqualToString:@"Start Date"]
    ||
    [self.activeField.titlePlaceholder isEqualToString:@"End Date"];
    NSDate *date = [self.formatter dateFromString:self.activeField.text];
    
    if (isDateField && date != nil) {
        [self.datePicker setDate:date animated:NO];
        NSLog(@"DATE AFTER: %@", [self.formatter stringFromDate:self.datePicker.date]);
    } else if (isDateField) {
        self.activeField.text = [self.formatter stringFromDate:self.datePicker.date];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [super textViewDidBeginEditing:textView];
    self.viewNeedsToBeMovedUp = YES;
}

- (IBAction)addButtonTapped:(UIButton *)sender {
    NSDictionary *experienceDict = @{
                                     kExperienceName: self.positionTextField.text,
                                     kExperienceStartDate: self.startTextField.text,
                                     kExperienceEndDate: self.endTextField.text,
                                     kExperienceDescription: self.detailsTextView.text
                                     };
    [self.delegate addExperienceVCDismissedWithExperience:experienceDict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardDidShow: (NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.displacement = self.displacement == 0 ? keyboardSize.height : self.displacement;
    if (self.viewNeedsToBeMovedUp) {
        for (UIView* view in self.baseViews) {
            view.transform = CGAffineTransformMakeTranslation(0, -self.displacement);
        }
    }
    
    
}

-(void)keyboardDidHide: (NSNotification *)aNotification {
    if (self.viewNeedsToBeMovedUp) {
        for (UIView* view in self.baseViews) {
            view.transform = CGAffineTransformIdentity;
        }
        self.viewNeedsToBeMovedUp = NO;
    }
}

-(void)datePickerValueChanged: (UIDatePicker *)datePicker {
    if ([self.activeField.titlePlaceholder isEqualToString:@"Start Date"]
        ||
        [self.activeField.titlePlaceholder isEqualToString:@"End Date"]) {
        
        self.activeField.text = [NSString stringWithFormat:@"%@", [self.formatter stringFromDate:self.datePicker.date]];
    }
}

- (IBAction)presentButtonTapped:(UIButton *)sender {
    self.endTextField.text = @"Present";
}

- (IBAction)noDatesButtonTapped:(UIButton *)sender {
    self.startTextField.text = @"";
    self.endTextField.text = @"";
}

@end
