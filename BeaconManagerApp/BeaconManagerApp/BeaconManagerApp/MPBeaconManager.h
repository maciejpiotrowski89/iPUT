//
//  MPBeaconManager.h
//  iPUT
//
//  Created by Paciej on 20/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import <EstimoteSDK/ESTBeacon.h>

@class MPBeaconManager;

@protocol MPBeaconManagerDelegate <NSObject>

@optional
//Connecting to ESTBeacon
- (void)manager:(MPBeaconManager*)manager didStartConnectingToBeacon:(ESTBeacon *)beacon;
- (void)manager:(MPBeaconManager*)manager didFailConnectingBeacon:(ESTBeacon *)beacon withError:(NSError*)error;
- (void)manager:(MPBeaconManager*)manager didConnectToBeacon:(ESTBeacon *)beacon;

- (void)manager:(MPBeaconManager*)manager didDisconnectBeacon:(ESTBeacon *)beacon;

//Setting context to ESTBeacon
- (void)manager:(MPBeaconManager*)manager didSetContext:(id)context toBeacon:(ESTBeacon *)beacon;
- (void)manager:(MPBeaconManager*)manager didFailSettingContext:(id)context toBeacon:(ESTBeacon *)beacon  withError:(NSError*)error;

//Resetting context of ESTBeacon
- (void)manager:(MPBeaconManager*)manager didResetContextToBeacon:(ESTBeacon *)beacon;
- (void)manager:(MPBeaconManager*)manager didFailResettingContextToBeacon:(ESTBeacon *)beacon  withError:(NSError*)error;

//Setting power to ESTBeacon
- (void)manager:(MPBeaconManager*)manager didSetPower:(ESTBeaconPower)value toBeacon:(ESTBeacon *)beacon;
- (void)manager:(MPBeaconManager*)manager didFailSettingPower:(ESTBeaconPower)value toBeacon:(ESTBeacon *)beacon withError:(NSError*)error;

//Setting adv interval to ESTBeacon
- (void)manager:(MPBeaconManager*)manager didSetInterval:(unsigned short)value toBeacon:(ESTBeacon *)beacon;
- (void)manager:(MPBeaconManager*)manager didFailSettingInterval:(unsigned short)value toBeacon:(ESTBeacon *)beacon withError:(NSError*)error;

@end

@interface MPBeaconManager : MPBaseObject

@property (nonatomic,weak) id <MPBeaconManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (BOOL)managesBeacon; //returns YES if has ESTBeacon instance to manage
- (void)connectToBeacon;
- (void)disconnectBeacon;
- (void)setBeacon:(ESTBeacon *)beacon;
- (ESTBeacon *)getBeacon;
- (void)setContext:(id)context;
- (void)setPower:(NSNumber *)power;
- (void)setAdvertisingInterval:(NSNumber *)interval;
- (void)resetContext;

@end
