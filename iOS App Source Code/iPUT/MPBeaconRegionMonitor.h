//
//  MPBeaconRegionMonitor.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import <EstimoteSDK/ESTBeaconManager.h>

@protocol MPBeaconRegionMonitorDelegate <NSObject>

@required
- (void)beaconRegionMonitorDidFailMonitoringRegion:(ESTBeaconRegion *)region withError:(NSError *)error;

@optional
- (void)beaconRegionMonitorDidEnterRegion:(ESTBeaconRegion *)region;
- (void)beaconRegionMonitorDidExitRegion:(ESTBeaconRegion *)region;

@end

@interface MPBeaconRegionMonitor : MPBaseObject <ESTBeaconManagerDelegate>

@property (nonatomic,weak) id <MPBeaconRegionMonitorDelegate> delegate;

- (void)startMonitoringRegions: (NSArray *)regions; //ESTBeaconRegion objects
- (void)stopMonitoringAllRegions;

@end

