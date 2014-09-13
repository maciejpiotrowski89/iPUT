//
//  MPPowerSelectionViewController.m
//  BeaconManagerApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 09/09/14.
//  Copyright (c) 2014 Roche Polska Sp. z o.o. All rights reserved.
//

#import "MPPowerSelectionViewController.h"

@interface MPPowerSelectionViewController ()

@end

@implementation MPPowerSelectionViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    [self initializeRowTitles];
}

- (void)initializeRowTitles {
    /*   
     ESTBeaconPowerLevel1 = -30,
     ESTBeaconPowerLevel2 = -20,
     ESTBeaconPowerLevel3 = -16,
     ESTBeaconPowerLevel4 = -12,
     ESTBeaconPowerLevel5 = -8,
     ESTBeaconPowerLevel6 = -4,
     ESTBeaconPowerLevel7 = 0,
     ESTBeaconPowerLevel8 = 4,*/
    
    NSArray *objects = @[@(ESTBeaconPowerLevel1), @(ESTBeaconPowerLevel2), @(ESTBeaconPowerLevel3), @(ESTBeaconPowerLevel4), @(ESTBeaconPowerLevel5), @(ESTBeaconPowerLevel6), @(ESTBeaconPowerLevel7), @(ESTBeaconPowerLevel8)];
    //nsnumber number with char
    NSMutableArray *titles = [NSMutableArray new];
    for (NSUInteger i = 0; i <= 7; i++) {
        [titles addObject:[NSString stringWithFormat:@"%d dBm", [[objects objectAtIndex:i]intValue]]];
        NSLog(@"Char: %c, Int: %d", [[objects objectAtIndex:i] charValue], [[objects objectAtIndex:i] intValue]);
    }
    self.objects = objects;
    self.rowTitles = titles;
}

#pragma mark - Instance methods

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    [self.delegate powerSelectionViewController:self didSelectPower:[self.objects objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate modalControllerDidCancel];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //avoid deselection of a cell;
}

@end