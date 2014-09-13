//
//  MPClosestiBeaconViewController.m
//  iPUT
//
//  Created by Paciej on 08/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPiBeaconDetailsViewController.h"
#import "MPBeaconProfileSelectionViewController.h"
#import "MPBeaconManager.h"

NSString * const kSetContext = @"Set context";
NSString * const kResetContext = @"Reset context";

typedef NS_ENUM(NSUInteger, MPiBeaconDetailsKeys) {
    MPiBeaconDetailsKeyCurrentContext,
    MPiBeaconDetailsKeysProximityUUID,
    MPiBeaconDetailsKeysMajorValue,
    MPiBeaconDetailsKeysMinorValue,
    MPiBeaconDetailsKeysBatteryLevel,
    MPiBeaconDetailsKeysConnected,
    MPiBeaconDetailsKeysActionResetContext,
    MPiBeaconDetailsKeysActionSetContext,
    MPiBeaconDetailsKeysAll
};

@interface MPiBeaconDetailsViewController () <MPBeaconManagerDelegate, MPBeaconProfileSelectionViewControllerDelegate>

@property (nonatomic,strong) BeaconProfile *beaconProfile;
@property (nonatomic,strong) MPBeaconManager *beaconManager;
@property (nonatomic,strong) ESTBeacon *beacon;

@end

@implementation MPiBeaconDetailsViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self initializeBeaconManager];
    [self initializeBeacon];
    [self initializeBeaconProfile];
    [self initializeRowTitles];
    [self initializeRowValues];
}

- (void)initializeBeaconManager {
    self.beaconManager = [MPBeaconManager sharedManager];
    self.beaconManager.delegate = self;
}

- (void)initializeBeacon {
    if (nil == self.beaconManager) {
        NSLog(@"Cannot bootstrap ESTBeacon property from nil MPBeaconManager instance.");
        return;
    }
    self.beacon = [self.beaconManager getBeacon];
}

- (void)initializeBeaconProfile {
    if (nil == self.beaconManager) {
        NSLog(@"Cannot bootstrap BeaconProfile property from nil ESTBeacon instance.");
        return;
    }
    self.beaconProfile = [MPUtils beaconProfileForESTBeacon:self.beacon];
}

- (void)initializeRowTitles {
    self.rowTitles = @[@"Current context",
                       @"Proximity UUID",
                       @"Major value",
                       @"Minor value",
                       @"Battery level",
                       @"Connected",
                       @"Action",
                       @"Action"];
}

- (void)initializeRowValues {
    self.rowValues = @[[MPUtils beaconProfileDescriptionForBeaconProfile:self.beaconProfile],
                       [MPUtils stringValueForObject:[self.beacon.proximityUUID UUIDString]],
                       [MPUtils stringValueForObject:self.beacon.major],
                       [MPUtils stringValueForObject:self.beacon.minor],
                       self.beacon.batteryLevel? [NSString stringWithFormat:@"%@%%",self.beacon.batteryLevel] : @"Unknown",
                       self.beacon.isConnected? @"Yes" : @"No",
                       kResetContext,
                       kSetContext];
}

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self connectToBeacon];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(nil == self.presentedViewController) {
        [self disconnectBeacon];
    }
}

#pragma mark - Instance methods

- (void)connectToBeacon {
    [self.beaconManager connectToBeacon];
}

- (void)disconnectBeacon {
    [self.beaconManager disconnectBeacon];
}

- (void)setContext {
    [self performSegueWithIdentifier:@"setContextSegue" sender:self];
}

- (void)resetContext {
    [self.beaconManager resetContext];
}

#pragma mark - Table View

- (void)reloadTableViewData {
    [self initializeBeaconProfile];
    [self initializeRowValues];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case MPiBeaconDetailsKeysActionResetContext:
            if (self.beacon.isConnected) {
                [self resetContext];
            }
            break;
        case MPiBeaconDetailsKeysActionSetContext:
            if (self.beacon.isConnected) {
                [self setContext];
            }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case MPiBeaconDetailsKeysActionResetContext:
        case MPiBeaconDetailsKeysActionSetContext:
                cell.accessoryType = self.beacon.isConnected? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            //no break statement - set (green color) for those three rows if beacon is connected
        case MPiBeaconDetailsKeysConnected:
            cell.detailTextLabel.textColor = self.beacon.isConnected? [UIColor greenColor] : [UIColor lightGrayColor];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - MPBeaconManagerDelegate

- (void)manager:(MPBeaconManager*)manager didStartConnectingToBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did start connecting beacon: %@.",beacon);
    [self showLoadingIndicator];
}

- (void)manager:(MPBeaconManager*)manager didFailConnectingBeacon:(ESTBeacon *)beacon withError:(NSError*)error {
    [self hideLoadingIndicator];
    NSString *message = [NSString stringWithFormat:@"Manager failed connecting beacon: %@. Error: %@.", beacon, [error localizedDescription]];
    [MPUtils displayErrorAlertViewForMessage:message];
    NSLog(@"%@", message);
}

- (void)manager:(MPBeaconManager*)manager didConnectToBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did connect beacon: %@.",beacon);
    [self reloadTableViewData];
    [self hideLoadingIndicator];
}

- (void)manager:(MPBeaconManager*)manager didDisconnectBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did disconnect beacon: %@.",beacon);
    [self reloadTableViewData];
    if (nil != self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSString *message = @"Beacon was disconnected :(";
        [MPUtils displayErrorAlertViewForMessage:message];
    }
}

- (void)manager:(MPBeaconManager*)manager didResetContextToBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did reset context to beacon: %@.",beacon);
    [self reloadTableViewData];
}

- (void)manager:(MPBeaconManager*)manager didFailResettingContextToBeacon:(ESTBeacon *)beacon withError:(NSError*)error {
    NSString *message = [NSString stringWithFormat:@"Manager failed resetting context to beacon: %@. Error: %@.", beacon, [error localizedDescription]];
    [MPUtils displayErrorAlertViewForMessage:message];
    NSLog(@"%@", message);
}


- (void)manager:(MPBeaconManager*)manager didSetContext:(BeaconProfile *)context toBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did set context: %@ to beacon: %@.", context, beacon);
    [self reloadTableViewData];
}

- (void)manager:(MPBeaconManager*)manager didFailSettingContext:(BeaconProfile *)context toBeacon:(ESTBeacon *)beacon  withError:(NSError*)error {
    NSString *message = [NSString stringWithFormat:@"Manager failed setting context: %@ to beacon: %@. Error: %@.", context, beacon, [error localizedDescription]];
    [MPUtils displayErrorAlertViewForMessage:message];
    NSLog(@"%@", message);
}

#pragma mark - MPBeaconProfileSelectionViewControllerDelegate

- (void)beaconProfileSelectionViewControllerDidCancel: (MPBeaconProfileSelectionViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)beaconProfileSelectionViewController: (MPBeaconProfileSelectionViewController *)vc didSelectProfile: (BeaconProfile *)profile {
    [self.beaconManager setContext:profile];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"setContextSegue"]) {
        UIViewController *vc = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
        [vc setValue:self forKeyPath:@"delegate"];
    }
}

@end
