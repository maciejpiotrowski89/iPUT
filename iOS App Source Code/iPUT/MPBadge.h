//
//  MPBadge.h
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import <CoreLocation/CLBeaconRegion.h>

@interface MPBadge : MPBaseObject

@property (readonly, nonatomic) NSUUID *proximityUUID;
@property (readonly, nonatomic) NSNumber *major;
@property (readonly, nonatomic) NSNumber *minor;
@property (readonly, nonatomic) NSDictionary *dataForAdvertising;

- (instancetype)initWithBeaconProfile:(BeaconProfile *)profile;

@end
