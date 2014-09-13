//
//  MPBadgeController.m
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBadgeController.h"
#import "MPBadge.h"

@import CoreBluetooth;
@import CoreLocation;


@interface MPBadgeController() <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) MPBadge *badge;
@property (nonatomic, strong) BeaconProfile *profile;

@end

@implementation MPBadgeController

#pragma mark - Initialization & Setup

- (void)initializeObject {
    self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

#pragma mark - Instance methods

- (void)setBeaconProfile:(BeaconProfile *)profile {
    if (nil != profile) {
        self.profile = profile;
        self.badge = [[MPBadge alloc]initWithBeaconProfile:profile];
    }
}

- (void)startEmittingBeaconIdentifier {
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn && !self.peripheralManager.isAdvertising && nil != self.badge.dataForAdvertising) {
        [self.peripheralManager startAdvertising: self.badge.dataForAdvertising];
            NSLog(@"Controller STARTED emitting Beacon ID");
    } else {
        [self.delegate badgeControllerDidFailEmittingBeaconIdentifier:[NSError errorWithDomain:@"BLE" code:CBPeripheralManagerStateUnsupported userInfo:@{NSLocalizedDescriptionKey : @"The platform/hardware doesn't support Bluetooth Low Energy."}]];
    }
}

- (void)stopEmittingBeaconIdentifier {
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn && self.peripheralManager.isAdvertising) {
        [self.peripheralManager stopAdvertising];
    NSLog(@"Controller STOPPED emitting Beacon ID");
        [self.delegate badgeControllerDidStopEmittingBeaconIdentifier];
    }
}

#pragma mark - Peripheral Manager Delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSString *state = nil;
    switch (peripheral.state)
    {
        case CBPeripheralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBPeripheralManagerStatePoweredOn:
            state = @"Bluetooth is currently powered on.";
            break;
        case CBPeripheralManagerStateUnknown:
            state = @"Bluetooth status is currently unknown.";
            break;
        case CBPeripheralManagerStateResetting:
            state = @"Bluetooth status is currently resetting.";
            break;
    }
    NSLog(@"Peripheral Manager state: %@", state);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (nil == error) {
        [self.delegate badgeControllerDidStartEmittingBeaconIdentifier];
    } else {
        [self.delegate badgeControllerDidFailEmittingBeaconIdentifier:error];
    }
    NSLog(@"peripheral: %@ did start advertising, error: %@", [peripheral description],  [error description]);
}
/*
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict {
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    
}
*/

@end
