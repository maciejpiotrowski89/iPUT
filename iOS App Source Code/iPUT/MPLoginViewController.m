//
//  CRLoginViewController.m
//  CRApprovalMockup
//
//  Created by Maciej Piotrowski on 2/20/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPLoginViewController.h"
#import "macros.h"
#import <Parse/PFUser.h>
#import "MPSynchronizationFacade.h"

NSString *const kLoginSegue = @"loginSegue";

@interface MPLoginViewController()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIView *usernameBackground;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordBackground;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginBackground;

@end

@implementation MPLoginViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [MPUtils setCornerRadius:5.0 forView:self.usernameBackground];
    [MPUtils setCornerRadius:5.0 forView:self.passwordBackground];
    [MPUtils setCornerRadius:5.0 forView:self.loginBackground];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

#pragma mark - Instance methods
- (void)synchronizationEnded:(NSNotification *)notification {
    [super synchronizationEnded:notification];
    [self performSelectorOnMainThread:@selector(performLoginSegue) withObject:nil waitUntilDone:NO];
}

- (IBAction)performLogin:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    NSString *login = self.usernameTextField.text;
    NSString *pass = self.passwordTextField.text;
    [self showLoadingIndicator];
    [[MPSynchronizationFacade sharedInstance]loginUser:login password:pass];
}

-(void)performLoginSegue {
    if (nil != [PFUser currentUser]) {
        [self performSegueWithIdentifier:kLoginSegue sender:self];
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else if(textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        [self performLogin:textField];
    }
    return YES;
}

@end
