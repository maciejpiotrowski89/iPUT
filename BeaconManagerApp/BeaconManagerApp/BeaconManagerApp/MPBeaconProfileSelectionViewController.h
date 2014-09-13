//
//  MPBeaconProfileSelectionViewController.h
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@class MPBeaconProfileSelectionViewController;

@protocol MPBeaconProfileSelectionViewControllerDelegate <MPModalControllerDelegateProtocol>

@required

- (void)beaconProfileSelectionViewController: (MPBeaconProfileSelectionViewController *)vc didSelectProfile: (id)profile;

@end

@interface MPBeaconProfileSelectionViewController : MPBaseTableViewController

@property (nonatomic,weak) id<MPBeaconProfileSelectionViewControllerDelegate> delegate;

@end
