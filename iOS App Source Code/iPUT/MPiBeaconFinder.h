//
//  MPiBeaconFinder.h
//  iPUT
//
//  Created by Paciej on 13/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import <EstimoteSDK/ESTBeaconManager.h>

@protocol MPiBeaconFinderDelegate <NSObject>

@required
- (void)iBeaconFinderDidFailRangingBeacons:(NSError *)error;
- (void)iBeaconFinderDidFindBeacons:(NSArray *)beacons;

@optional
- (void)iBeaconFinderDidStartRangingBeacons;
- (void)iBeaconFinderDidStopRangingBeacons;

@end

@interface MPiBeaconFinder : MPBaseObject <ESTBeaconManagerDelegate>

@property (nonatomic) BOOL beaconDiscoverInProgress;
@property (nonatomic,weak) id <MPiBeaconFinderDelegate> delegate;

- (void)discoveriBeaconsInProximity;

//Private Properties
@property (nonatomic,strong) NSMutableArray *beaconRegions;
@property (nonatomic,strong) NSMutableArray *beaconManagers; //ESTBeaconManager objects
@property (nonatomic,strong) NSMutableDictionary *beaconsDiscoveredByManagers;

@end

@interface MPiBeaconFinder (PrivateMethods)

- (void)initializeBeaconRegions;
- (void)initializeBeaconManagers;
- (void)initializeBeaconsDiscoveredByManagers;
- (void)iBeaconsDiscoveryTimeElapsed: (NSDictionary *)userInfo;
- (void)stopiBeaconsDiscovery;

@end
