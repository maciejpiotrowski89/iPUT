//
//  MPBeaconProfileListViewController.m
//  iPUT
//
//  Created by Paciej on 24/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBeaconProfileListViewController.h"

@implementation MPBeaconProfileListViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.className = @"BeaconProfile";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"transmitBeaconSignalSegue"]) {
        UIViewController *vc = (UIViewController *)segue.destinationViewController;
        BeaconProfile *profile = [self objectForCell:sender];
        [vc setValue:profile forKeyPath:@"beaconProfile"];
    }
}

@end
