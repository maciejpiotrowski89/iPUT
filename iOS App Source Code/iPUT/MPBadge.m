//
//  MPBadge.m
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBadge.h"

NSString *const kStringIdentifier = @"Advertised Badge Beacon Region";

@interface MPBadge()

@property (nonatomic, strong) CLBeaconRegion *regionForAdvertising;

@end

@implementation MPBadge

#pragma mark - Initialization & Setup

- (instancetype)initWithBeaconProfile:(BeaconProfile *)profile {
    self = [super init];
    if (nil != self) {
        NSUUID *proximityUUID = [[NSUUID alloc]initWithUUIDString:profile.proximityUUID];
        CLBeaconMajorValue major = [profile.major unsignedShortValue];
        CLBeaconMinorValue minor = [profile.minor unsignedShortValue];
        self.regionForAdvertising = [[CLBeaconRegion alloc]initWithProximityUUID:proximityUUID major:major minor:minor identifier: kStringIdentifier];
    }
    return self;

}

#pragma mark - Instance methods

- (NSUUID *)proximityUUID {
    return self.regionForAdvertising.proximityUUID;
}

- (NSNumber *)majorNumber {
    return self.regionForAdvertising.major;
}

- (NSNumber *)minorNumber {
    return self.regionForAdvertising.minor;
}

- (CLBeaconRegion*) region{
    return self.regionForAdvertising;
}

- (NSDictionary *)dataForAdvertising {
    return [self.regionForAdvertising peripheralDataWithMeasuredPower:nil];
}

@end
