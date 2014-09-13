//
//  MPSettingsViewController.m
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPSettingsViewController.h"
#import <Parse/PFUser.h>
#import "MPSynchronizationFacade.h"

NSString *const kLogoutSegue = @"logoutSegue";
NSString *const kLogoutTitle = @"Logout";

@implementation MPSettingsViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
    self.rowTitles = @[kLogoutTitle];
}

- (void)synchronizationEnded:(NSNotification *)notification {
    [super synchronizationEnded:notification];
    [self performSelectorOnMainThread:@selector(performLogout) withObject:nil waitUntilDone:NO];
}

- (void)synchronizationFailed:(NSNotification *)notification {
    [super synchronizationFailed:notification];
    [MPUtils displayErrorAlertViewForMessage:@"Error occured while logging out user."];
}


#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == self.rowTitles.count - 1) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSString *title = [self rowTitleForIndexPath:indexPath];
    if ([title isEqualToString:kLogoutTitle]) {
        [self logoutButtonPressed:self];
    }
}

- (NSString *)tableViewHeaderImageName {
    return @"settings";
}

#pragma mark - Instance methods

- (IBAction)logoutButtonPressed:(id)sender {
    [[MPSynchronizationFacade sharedInstance]logoutCurrentUser];
}

- (void)performLogout {
    if (nil == [PFUser currentUser]) {
        [self performSegueWithIdentifier:kLogoutSegue sender:self];
    }
}

@end
