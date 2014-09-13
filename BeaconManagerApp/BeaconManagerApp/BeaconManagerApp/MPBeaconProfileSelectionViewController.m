//
//  MPBeaconProfileSelectionViewController.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBeaconProfileSelectionViewController.h"
#import "MPUtils.h"

@implementation MPBeaconProfileSelectionViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    [self initializeRowTitles];
}

- (void)initializeRowTitles {
    self.rowTitles = [MPUtils contexts];
}

#pragma mark - Instance methods

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    id contextNumbers = nil;
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    if (nil != ip) {
        contextNumbers = [MPUtils contextNumbersForContextAtIndex: ip.row];
    }
    [self.delegate beaconProfileSelectionViewController:self didSelectProfile:contextNumbers];
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate modalControllerDidCancel];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //avoid deselection of a cell;
}

@end
