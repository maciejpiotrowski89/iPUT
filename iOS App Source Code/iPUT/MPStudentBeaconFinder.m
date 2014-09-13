//
//  MPStudentsFinder.m
//  iPUT
//
//  Created by Paciej on 24/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPStudentBeaconFinder.h"

NSString *const kStudentRegionIdentifier = @"Student Region Identifier";

@implementation MPStudentBeaconFinder

- (void)initializeBeaconRegions {
    NSUUID *personUUID = [[NSUUID alloc] initWithUUIDString:kiPUTPersonBeaconUUID];
    MPPersonalBeaconMajorType studentMajor = MPPersonalBeaconMajorTypeStudent;
    ESTBeaconRegion *region = [[ESTBeaconRegion alloc]initWithProximityUUID:personUUID major:studentMajor identifier:kiPUTPersonBeaconUUID];
    self.beaconRegions = [@[region]mutableCopy];
}

- (void)discoverStudentBeaconsInProximity {
    [self discoveriBeaconsInProximity];
}

@end
