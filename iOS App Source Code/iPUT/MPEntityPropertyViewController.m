//
//  MPEntityPropertyViewController.m
//  iPUT
//
//  Created by Paciej on 23/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityPropertyViewController.h"

@interface MPEntityPropertyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation MPEntityPropertyViewController

- (void)setupController {
    self.navigationItem.title = self.propertyDisplayedName;
    self.textView.text = [self.propertyValue description];
    if ([self.propertyName isEqualToString:@"yearStart"] || [self.propertyName isEqualToString:@"yearEnd"]) {
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    if (nil != self.propertyValue) {
        [self.datePicker setDate:self.propertyValue];
    }
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate modalControllerDidCancel];
}

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    id object = nil;
    if ([self.className isEqualToString:@"NSDate"]) {
        object = [self.datePicker date];
    } else if ([self.className isEqualToString:@"NSNumber"]) {
        NSNumberFormatter * f = [NSNumberFormatter new];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        object = [f numberFromString:self.textView.text];
    } else {
        object = self.textView.text;
    }
    [self.delegate editPropertyControllerDidRequestSaveObject:object forPropertyName:self.propertyName];
}

@end
