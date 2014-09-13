//
//  MPBeaconProfileSelectionViewController.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBeaconProfileSelectionViewController.h"

@implementation MPBeaconProfileSelectionViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    [super initializeController];
    self.className = @"BeaconProfile";
}

#pragma mark - Instance methods

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    BeaconProfile *profile = nil;
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    if (nil != ip) {
        profile = [self.objects objectAtIndex:ip.row];
    }
    [self.delegate beaconProfileSelectionViewController:self didSelectProfile:profile];
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate beaconProfileSelectionViewControllerDidCancel:self];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //avoid deselection of a cell;
}

@end
