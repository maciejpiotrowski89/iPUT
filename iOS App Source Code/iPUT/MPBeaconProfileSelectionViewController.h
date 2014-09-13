//
//  MPBeaconProfileSelectionViewController.h
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityListViewController.h"

@class MPBeaconProfileSelectionViewController;

@protocol MPBeaconProfileSelectionViewControllerDelegate <NSObject>

@required
- (void)beaconProfileSelectionViewControllerDidCancel: (MPBeaconProfileSelectionViewController *)vc;
- (void)beaconProfileSelectionViewController: (MPBeaconProfileSelectionViewController *)vc didSelectProfile: (BeaconProfile *)profile;

@end

@interface MPBeaconProfileSelectionViewController : MPEntityListViewController

@property (nonatomic,weak) id<MPBeaconProfileSelectionViewControllerDelegate> delegate;

@end
