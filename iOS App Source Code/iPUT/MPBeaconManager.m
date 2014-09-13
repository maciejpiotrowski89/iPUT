//
//  MPBeaconManager.m
//  iPUT
//
//  Created by Paciej on 20/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBeaconManager.h"

@interface MPBeaconManager() <ESTBeaconDelegate>

@property (nonatomic, strong) BeaconProfile *profile;
@property (nonatomic, strong) ESTBeacon *beaconDevice;

@end

@implementation MPBeaconManager
@synthesize beaconDevice = _beaconDevice;

#pragma mark - Instance methods

+ (instancetype)sharedManager {
    static MPBeaconManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MPBeaconManager new];
    });
    return manager;
}

- (BOOL)managesBeacon {
    return (nil == self.beaconDevice);
}

- (void)setBeacon:(ESTBeacon *)beacon {
    self.beaconDevice = beacon;
}

- (ESTBeacon *)getBeacon {
    return self.beaconDevice;
}

- (void)setBeaconDevice:(ESTBeacon *)beacon {
    if (nil != _beaconDevice) {
        _beaconDevice.delegate = nil;
        if (_beaconDevice.isConnected) {
            [_beaconDevice disconnectBeacon];
        }
    }
    _beaconDevice = beacon;
    _beaconDevice.delegate = self;
}

- (void)connectToBeacon {
    if (![self isConnectedToBeacon]) {
        if ([self.delegate respondsToSelector:@selector(manager:didStartConnectingToBeacon:)]) {
            [self.delegate manager:self didStartConnectingToBeacon:self.beaconDevice];
        }
        [self.beaconDevice connectToBeacon];
    }
}

- (void)disconnectBeacon {
    if ([self isConnectedToBeacon]) {
        [self.beaconDevice disconnectBeacon];
    }
}

- (void)setContext: (BeaconProfile *)context {
    self.profile = context;
    if ((nil != self.profile) && (![self isProfileLoadedToBeacon])) {
        //set proximity uuid
        [self.beaconDevice writeBeaconProximityUUID:self.profile.proximityUUID withCompletion:^(NSString *value, NSError *error) {
            if(![self errorOccuredForSettingContext:error]) {
                //set major
                [self.beaconDevice writeBeaconMajor:[self.profile.major unsignedShortValue] withCompletion:^(unsigned short value, NSError *error) {
                    if(![self errorOccuredForSettingContext:error]) {
                        //set minor
                        [self.beaconDevice writeBeaconMinor:[context.minor unsignedShortValue] withCompletion:^(unsigned short value, NSError *error) {
                            if(![self errorOccuredForSettingContext:error] && [self.delegate respondsToSelector:@selector(manager:didSetContext:toBeacon:)]) {
                                    //successfuly set context
                                    [self.delegate manager:self didSetContext:self.profile toBeacon:self.beaconDevice];
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)resetContext {
    [self.beaconDevice writeBeaconProximityUUID:kEstimoteBeaconUUID withCompletion:^(NSString *value, NSError *error) {
        if (![self errorOccuredForResettingContext:error] && [self.delegate respondsToSelector:@selector(manager:didResetContextToBeacon:)]) {
            [self.delegate manager:self didResetContextToBeacon:self.beaconDevice];
        }
    }];
}

- (BOOL)isConnectedToBeacon {
    return self.beaconDevice.isConnected;
}

- (BOOL)errorOccuredForSettingContext:(NSError *)error {
    if (nil == error) {
        return NO;
    }
    [MPUtils displayErrorAlertViewForMessage:[error localizedDescription]];
    if ([self.delegate respondsToSelector:@selector(manager:didFailSettingContext:toBeacon:withError:)]) {
        [self.delegate manager:self didFailSettingContext:self.profile toBeacon:self.beaconDevice withError:error];
    }
    return YES;
}

- (BOOL)errorOccuredForResettingContext:(NSError *)error {
    if (nil == error) {
        return NO;
    }
    [MPUtils displayErrorAlertViewForMessage:[error localizedDescription]];
    if ([self.delegate respondsToSelector:@selector(manager:didFailResettingContextToBeacon:withError:)]) {
        [self.delegate manager:self didFailResettingContextToBeacon:self.beaconDevice withError:error];
    }
    return YES;
}

- (BOOL)isProfileLoadedToBeacon {
    return ([[self.beaconDevice.proximityUUID UUIDString] isEqualToString:self.profile.proximityUUID] &&
            [self.beaconDevice.major isEqualToNumber:self.profile.major] &&
            [self.beaconDevice.minor isEqualToNumber:self.profile.minor]);
}

#pragma mark - ESTBeaconDelegate

- (void)beaconConnectionDidFail:(ESTBeacon*)beacon withError:(NSError*)error {
    NSLog(@"Error when connecting beacon: %@.", [error localizedDescription]);
    if ([self.delegate respondsToSelector:@selector(manager:didFailConnectingBeacon:withError:)]) {
        [self.delegate manager:self didFailConnectingBeacon:beacon withError:error];
    }
}

- (void)beaconConnectionDidSucceeded:(ESTBeacon*)beacon {
    NSLog(@"Beacon connected: %@.",[beacon description]);
    if ([self.delegate respondsToSelector:@selector(manager:didConnectToBeacon:)]) {
        [self.delegate manager:self didConnectToBeacon:beacon];
    }
}

- (void)beaconDidDisconnect:(ESTBeacon*)beacon withError:(NSError*)error {
    NSLog(@"Beacon disconnected: %@.",[beacon description]);
    if ([self.delegate respondsToSelector:@selector(manager:didDisconnectBeacon:)]) {
        [self.delegate manager:self didDisconnectBeacon:beacon];
    }
}

@end
