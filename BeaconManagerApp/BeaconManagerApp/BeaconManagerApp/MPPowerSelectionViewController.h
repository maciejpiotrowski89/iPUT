//
//  MPPowerSelectionViewController.h
//  BeaconManagerApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 09/09/14.
//  Copyright (c) 2014 Roche Polska Sp. z o.o. All rights reserved.
//

#import "MPBaseTableViewController.h"

@class MPPowerSelectionViewController;

@protocol MPPowerSelectionProtocol <MPModalControllerDelegateProtocol>

@required
- (void)powerSelectionViewController: (MPPowerSelectionViewController *)vc didSelectPower: (NSNumber *)power;

@end

@interface MPPowerSelectionViewController : MPBaseTableViewController

@property (nonatomic,weak) id <MPPowerSelectionProtocol>delegate;

@end
