//
//  MPBadgeController.h
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"

@class MPBadgeController;

@protocol MPBadgeControllerDelegate

@required
- (void)badgeControllerDidStartEmittingBeaconIdentifier;
- (void)badgeControllerDidFailEmittingBeaconIdentifier:(NSError *)error;
- (void)badgeControllerDidStopEmittingBeaconIdentifier;

@end

@interface MPBadgeController : MPBaseObject

@property (nonatomic,weak) id <MPBadgeControllerDelegate> delegate;

- (void)setBeaconProfile:(BeaconProfile *)profile;
- (void)startEmittingBeaconIdentifier;
- (void)stopEmittingBeaconIdentifier;

@end
