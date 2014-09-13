//
//  MPBeaconRegionMonitor.m
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBeaconRegionMonitor.h"

@import CoreLocation;

@interface MPBeaconRegionMonitor () <CLLocationManagerDelegate>

@property (nonatomic,strong) NSArray *beaconRegions;
@property (nonatomic,strong) CLLocationManager *beaconManager; //ESTBeaconManager objects
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation MPBeaconRegionMonitor

#pragma mark - Instance methods

- (void)initializeObject {
    CLLocationManager *beaconManager = [CLLocationManager new];
    beaconManager.delegate = self;
    self.beaconManager = beaconManager;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"Timer invalidated");
}

- (void)setupMonitoringForBeaconManagers {
    for (ESTBeaconRegion *region in self.beaconRegions) {
        [self.beaconManager startMonitoringForRegion:region];
    }
}

- (void)startMonitoringRegions:(NSArray *)regions {
    if (nil != regions && regions.count <=20) { //only 20 regions can be monitored via the app
        self.beaconRegions = regions;
        [self setupMonitoringForBeaconManagers];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(requestStateForRegions) userInfo:nil repeats:YES];
    }
}

- (void)stopMonitoringAllRegions {
    for (int i = 0; i < self.beaconRegions.count; i++ ) {
        ESTBeaconRegion *region = [self.beaconRegions objectAtIndex:i];
        [self.beaconManager stopMonitoringForRegion:region];
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)requestStateForRegions {
    static NSUInteger count = 0;
    NSLog(@"Request for state for a %zi time", count);
    count ++;
    for (int i=0; i<self.beaconRegions.count; i++) {
        ESTBeaconRegion *region = [self.beaconRegions objectAtIndex:i];
        [self.beaconManager requestStateForRegion:region];
    }
}
#pragma mark - ESTBeaconManagerDelegate

-(void)beaconManager:(ESTBeaconManager *)manager
monitoringDidFailForRegion:(ESTBeaconRegion *)region
           withError:(NSError *)error {
    NSLog(@"Beacon manager did fail monitoring region: %@. Error: %@", region, error);
    if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidFailMonitoringRegion:withError:)]) {
        [self.delegate beaconRegionMonitorDidFailMonitoringRegion:region withError:error];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
      didEnterRegion:(ESTBeaconRegion *)region {
    NSLog(@"Beacon manager did enter region: %@.", region);
    if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidEnterRegion:)]) {
        [self.delegate beaconRegionMonitorDidEnterRegion:region];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
       didExitRegion:(ESTBeaconRegion *)region {
    NSLog(@"Beacon manager did exit region: %@.", region);
    if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidExitRegion:)]) {
        [self.delegate beaconRegionMonitorDidExitRegion:region];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(ESTBeaconRegion *)region {
    NSLog(@"Beacon manager: %@ did determine state %zd region: %@.", manager, state, region);
    if (CLRegionStateInside == state) {
        if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidEnterRegion:)]) {
            [self.delegate beaconRegionMonitorDidEnterRegion:region];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidExitRegion:)]) {
            [self.delegate beaconRegionMonitorDidExitRegion:region];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"Beacon manager: %@ did determine state %zd region: %@.", manager, state, region);
    if (CLRegionStateInside == state) {
        if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidEnterRegion:)]) {
            [self.delegate beaconRegionMonitorDidEnterRegion:(ESTBeaconRegion *)region];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidExitRegion:)]) {
            [self.delegate beaconRegionMonitorDidExitRegion:(ESTBeaconRegion *)region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon manager did enter region: %@.", region);
    if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidEnterRegion:)]) {
        [self.delegate beaconRegionMonitorDidEnterRegion:(ESTBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Beacon manager did exit region: %@.", region);
    if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidExitRegion:)]) {
        [self.delegate beaconRegionMonitorDidExitRegion:(ESTBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Beacon manager did fail monitoring region: %@. Error: %@", region, error);
    if ([self.delegate respondsToSelector:@selector(beaconRegionMonitorDidFailMonitoringRegion:withError:)]) {
        [self.delegate beaconRegionMonitorDidFailMonitoringRegion:(ESTBeaconRegion *)region withError:error];
    }
}
@end
