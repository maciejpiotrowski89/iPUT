//
//  MPiBeaconFinder.m
//  iPUT
//
//  Created by Paciej on 13/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPiBeaconFinder.h"

NSTimeInterval const kiBeaconDiscoveryTime = 15.0; //stabilization after 10s (if iOS device transmits as iBeacon)

@implementation MPiBeaconFinder

#pragma mark - Initialization & Setup

- (void)initializeObject {
    [self initializeBeaconRegions];
    [self initializeBeaconManagers];
    [self initializeBeaconsDiscoveredByManagers];
    self.beaconDiscoverInProgress = NO;
}

- (void)initializeBeaconRegions {
    self.beaconRegions = [NSMutableArray new];
    NSArray *uuids = [BeaconUUID findByAttribute:@"db_deleted" withValue:@NO];
    for (BeaconUUID *beaconUuid in uuids) {
        @autoreleasepool {
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:beaconUuid.uuidString];
            ESTBeaconRegion *region = [[ESTBeaconRegion alloc]initWithProximityUUID:uuid identifier:beaconUuid.uuidString];
            [self.beaconRegions addObject:region];
        }
    }
}

- (void)initializeBeaconManagers {
    self.beaconManagers = [[NSMutableArray alloc]initWithCapacity:self.beaconRegions.count];
    for (int i = 0; i < self.beaconRegions.count; i++ ) {
        ESTBeaconManager *beaconManager = [ESTBeaconManager new];
        beaconManager.delegate = self;
        beaconManager.avoidUnknownStateBeacons = YES;
        [self.beaconManagers addObject:beaconManager];
    }
}

- (void)initializeBeaconsDiscoveredByManagers {
    self.beaconsDiscoveredByManagers = [NSMutableDictionary new];
}

#pragma mark - Instance methods

- (void)discoveriBeaconsInProximity {
    NSLog(@"Discovery started");
    self.beaconDiscoverInProgress = YES;
    [self.beaconsDiscoveredByManagers removeAllObjects];
    for (int i = 0; i < self.beaconRegions.count; i++ ) {
        ESTBeaconRegion *region = [self.beaconRegions objectAtIndex:i];
        ESTBeaconManager *beaconManager = [self.beaconManagers objectAtIndex:i];
        [beaconManager startRangingBeaconsInRegion:region];
    }

    NSLog(@"Regions: %@", self.beaconRegions);
    if ([self.delegate respondsToSelector:@selector(iBeaconFinderDidStartRangingBeacons)]) {
        [self.delegate iBeaconFinderDidStartRangingBeacons];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:kiBeaconDiscoveryTime target:self selector:@selector(iBeaconsDiscoveryTimeElapsed:) userInfo:nil repeats:NO];
}

- (void)iBeaconsDiscoveryTimeElapsed: (NSDictionary *)userInfo {
    NSLog(@"Time elapsed");
    [self stopiBeaconsDiscovery];
}

- (void)stopiBeaconsDiscovery {
    for (int i = 0; i < self.beaconRegions.count; i++ ) {
        ESTBeaconRegion *region = [self.beaconRegions objectAtIndex:i];
        ESTBeaconManager *beaconManager = [self.beaconManagers objectAtIndex:i];
        [beaconManager stopRangingBeaconsInRegion:region];
    }
    
    NSMutableArray *discoveredBeacons = [[NSMutableArray alloc]initWithCapacity:self.beaconManagers.count];
    for (NSString *key in self.beaconsDiscoveredByManagers) {
        [discoveredBeacons addObjectsFromArray:[self.beaconsDiscoveredByManagers objectForKey:key]];
    }
    NSArray *sortedDiscoveredBeacons = [discoveredBeacons sortedArrayUsingComparator:^NSComparisonResult(ESTBeacon *beacon1, ESTBeacon *beacon2) {
//     NSLog(@"rssi1: %li, rssi2: %li", beacon1.rssi, (long)beacon2.rssi);
     if (beacon1.rssi < beacon2.rssi) return NSOrderedDescending;
     if (beacon1.rssi > beacon2.rssi) return NSOrderedAscending;
     return NSOrderedSame;
     }];
    if ([self.delegate respondsToSelector:@selector(iBeaconFinderDidFindBeacons:)]) {
        [self.delegate iBeaconFinderDidFindBeacons:sortedDiscoveredBeacons];
    }
    if ([self.delegate respondsToSelector:@selector(iBeaconFinderDidStopRangingBeacons)]) {
        [self.delegate iBeaconFinderDidStopRangingBeacons];

    }
    self.beaconDiscoverInProgress = NO;
    NSLog(@"Discovery stopped");
}

#pragma mark - ESTBeaconManagerDelegate

- (void)beaconManager:(ESTBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(ESTBeaconRegion *)region {
    if (nil != beacons && beacons.count > 0) {
        NSArray *newBeacons = beacons;
        NSMutableArray *oldBeacons = [[NSMutableArray alloc]initWithArray:[self.beaconsDiscoveredByManagers objectForKey:[manager description]]];
        for (ESTBeacon *newBeacon in newBeacons) {
            if (![oldBeacons containsObject:newBeacon]) {
                [oldBeacons addObject:newBeacon];
            }
        }
        [self.beaconsDiscoveredByManagers setObject:oldBeacons forKey:[manager description]];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region
           withError:(NSError *)error {
    NSLog(@"Discovery failed: %@", [error description]);
    if ([self.delegate respondsToSelector:@selector(iBeaconFinderDidFailRangingBeacons:)]) {
        [self.delegate iBeaconFinderDidFailRangingBeacons:error];
    }
    [self stopiBeaconsDiscovery];
}

@end
