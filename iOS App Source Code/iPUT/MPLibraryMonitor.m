//
//  MPLibraryMonitor.m
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPLibraryMonitor.h"
#import "MPBeaconRegionMonitor.h"

@interface MPLibraryMonitor() <MPBeaconRegionMonitorDelegate>

@property (nonatomic,strong) MPBeaconRegionMonitor *monitor;
@property (nonatomic,strong) NSSet *monitoredLibraries;
@property (nonatomic,strong) NSArray *monitoredRegions;
@property (nonatomic,strong) NSMutableSet *currentLibraries;

@end

@implementation MPLibraryMonitor

#pragma mark - Initialization & Setup

- (void)initializeObject {
    [self initializeMonitor];
    [self initializeLibraries];
    [self initializeRegions];
}

- (void)initializeMonitor {
    self.monitor = [MPBeaconRegionMonitor new];
    self.monitor.delegate = self;
}

- (void)initializeLibraries {
    self.monitoredLibraries = [MPUtils subscribedLibrariesForCurrentUser];
    self.currentLibraries = [NSMutableSet new];
}

- (void)initializeRegions {
    self.monitoredRegions = nil;
    if (nil != self.monitoredLibraries && 0 < self.monitoredLibraries.count) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.monitoredLibraries.count];
        for (Library *library in self.monitoredLibraries) {
            @autoreleasepool {
                ESTBeaconRegion *region = [MPUtils beaconRegionForBeaconProfile:library.beacon];
                [array addObject:region];
            }
        }
        self.monitoredRegions = array;
    }
}

#pragma mark - Instance methods

- (void)startMonitoringLibrariesForCurrentUser {
    [self.monitor startMonitoringRegions:self.monitoredRegions];
}

- (void)stopMonitoringLibrariesForCurrentUser {
    [self.monitor stopMonitoringAllRegions];
}

- (void)reinitialize {
    [self stopMonitoringLibrariesForCurrentUser];
    [self initializeLibraries];
    [self initializeRegions];
    [self startMonitoringLibrariesForCurrentUser];
    [self informDelegateAboutCurrentLibraries];
}

- (void)addLibraryForRegion:(ESTBeaconRegion *)region {
    BeaconProfile *profile = [MPUtils beaconProfileForBeaconRegion:region];
    Library *library = (Library *)profile.room;

    if (nil != library) {
        if (![self.currentLibraries containsObject:library]) {
            [self.currentLibraries addObject:library];
            [self informDelegateAboutCurrentLibraries];
            NSString *message = [NSString stringWithFormat:@"You entered the %@. New resources are available.", library];
            [MPUtils displayAlertViewForMessage: message];
        }
    }
}

- (void)informDelegateAboutCurrentLibraries {
    if ([self.delegate respondsToSelector:@selector(currentLibrariesChanged:)]) {
        [self.delegate currentLibrariesChanged:self.currentLibraries];
    }
}

- (void)removeLibraryForRegion:(ESTBeaconRegion *)region {
    BeaconProfile *profile = [MPUtils beaconProfileForBeaconRegion:region];
    Library *library = (Library *)profile.room;
    
    if (nil != library) {
        if ([self.currentLibraries containsObject:library]) {
            [self.currentLibraries removeObject:library];
            [self informDelegateAboutCurrentLibraries];
            NSString *message = [NSString stringWithFormat:@"You are no longer present in %@. Some of the resources are no longer available.", library];
            [MPUtils displayAlertViewForMessage: message];
        }
    }
}

#pragma mark - MPBeaconRegionMonitorDelegate

- (void)beaconRegionMonitorDidFailMonitoringRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
    [self removeLibraryForRegion:region];
}

- (void)beaconRegionMonitorDidEnterRegion:(ESTBeaconRegion *)region {
    [self addLibraryForRegion:region];
}

- (void)beaconRegionMonitorDidExitRegion:(ESTBeaconRegion *)region {
    [self removeLibraryForRegion:region];
}

@end
