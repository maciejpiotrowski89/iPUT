//
//  MPAdvertisingIntervalSelectionVC.m
//  BeaconManagerApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 09/09/14.
//  Copyright (c) 2014 Roche Polska Sp. z o.o. All rights reserved.
//

#import "MPAdvertisingIntervalSelectionVC.h"

@interface MPAdvertisingIntervalSelectionVC ()

@end

@implementation MPAdvertisingIntervalSelectionVC

#pragma mark - Initialization & Setup

- (void)initializeController {
    [self initializeRowTitles];
}

- (void)initializeRowTitles {
    NSMutableArray *objects = [NSMutableArray new];
    NSMutableArray *titles = [NSMutableArray new];
    for (int i = 50; i <= 2000; i+=50) {
        [objects addObject:[NSNumber numberWithInt:i]];
        [titles addObject:[NSString stringWithFormat:@"%@ ms", [[objects lastObject] description]]];
    }
    self.objects = objects;
    self.rowTitles = titles;
}

#pragma mark - Instance methods

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    [self.delegate advertisingIntervalSelectionViewController:self didSelectInterval:[self.objects objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate modalControllerDidCancel];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //avoid deselection of a cell;
}

@end
