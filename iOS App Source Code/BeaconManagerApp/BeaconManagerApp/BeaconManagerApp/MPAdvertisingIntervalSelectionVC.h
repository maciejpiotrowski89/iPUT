//
//  MPAdvertisingIntervalSelectionVC.h
//  BeaconManagerApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 09/09/14.
//  Copyright (c) 2014 Roche Polska Sp. z o.o. All rights reserved.
//

#import "MPBaseTableViewController.h"

@class MPAdvertisingIntervalSelectionVC;

@protocol MPAdvertisingIntervalSelectionProtocol <MPModalControllerDelegateProtocol>

- (void)advertisingIntervalSelectionViewController: (MPAdvertisingIntervalSelectionVC *)vc didSelectInterval:(NSNumber *)interval;

@end

@interface MPAdvertisingIntervalSelectionVC : MPBaseTableViewController

@property (nonatomic,weak) id <MPAdvertisingIntervalSelectionProtocol>delegate;

@end
