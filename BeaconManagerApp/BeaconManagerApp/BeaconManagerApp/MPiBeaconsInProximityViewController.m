//
//  MPiBeaconsInProximityViewController.m
//  iPUT
//
//  Created by Paciej on 13/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPiBeaconsInProximityViewController.h"
#import "MPiBeaconFinder.h"
#import "MPBeaconManager.h"

@interface MPiBeaconsInProximityViewController () <MPiBeaconFinderDelegate>

@property (nonatomic,strong) MPiBeaconFinder *iBeaconFinder;
@property (nonatomic,strong) NSArray *iBeacons;

@end

@implementation MPiBeaconsInProximityViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
    [self initializeiBeaconFinder];
}

- (void)initializeiBeaconFinder {
    self.iBeaconFinder = [MPiBeaconFinder new];
    self.iBeaconFinder.delegate = self;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadTableViewData];
}

#pragma mark - Instance methods

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    if(self.iBeaconFinder.beaconDiscoverInProgress == NO) {
        [self.iBeaconFinder discoveriBeaconsInProximity];
    }
}

#pragma mark - MPiBeaconFinderDelegate

- (void)iBeaconFinderDidStartRangingBeacons {
    [self showLoadingIndicator];
}

- (void)iBeaconFinderDidFailRangingBeacons:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"There was a problem ..." message:[error localizedDescription]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)iBeaconFinderDidFindBeacons:(NSArray *)beacons {
    self.iBeacons = beacons;
    [self reloadTableViewData];
}

- (void)iBeaconFinderDidStopRangingBeacons {
    [self hideLoadingIndicator];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPBeaconManager *manager = [MPBeaconManager sharedManager];
    ESTBeacon *beacon = [self.iBeacons objectAtIndex:indexPath.row];
    [manager setBeacon: beacon];
}

- (void)reloadTableViewData {
    NSMutableArray *titles = [[NSMutableArray alloc]initWithCapacity:self.iBeacons.count];
    NSMutableArray *values = [[NSMutableArray alloc]initWithCapacity:self.iBeacons.count];
    
    for (ESTBeacon *beacon in self.iBeacons) {
        [titles addObject:[MPUtils contextForESTBeacon:beacon]];
        [values addObject:[NSString stringWithFormat:@"Major: %@, Minor: %@", beacon.major, beacon.minor]];
    }
    self.rowTitles = titles;
    self.rowValues =  values;
    [self.tableView reloadData];
}

@end
