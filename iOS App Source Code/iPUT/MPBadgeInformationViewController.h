//
//  MPPersonInformationViewController.h
//  iPUT
//
//  Created by Paciej on 23/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@interface MPBadgeInformationViewController : MPBaseTableViewController

@property (nonatomic, strong) BeaconProfile *beaconProfile;
@property (nonatomic, strong) NSNumber *shouldEnableUserInteractionOnViewDidLoad;//boolValue

- (void)enableUserInteraction;
- (void)disableUserInteraction;

@end
