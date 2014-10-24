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
#import "MPAdvertisingIntervalSelectionVC.h"
#import "MPPowerSelectionViewController.h"

NSString * const kSetContext = @"Set context";
NSString * const kResetContext = @"Reset context";
NSString * const kSetPower = @"Set power";
NSString * const kSetAdvInterval = @"Set advertising interval";

typedef NS_ENUM(NSUInteger, MPiBeaconDetailsKeys) {
    MPiBeaconDetailsKeyCurrentContext,
    MPiBeaconDetailsKeysProximityUUID,
    MPiBeaconDetailsKeysMajorValue,
    MPiBeaconDetailsKeysMinorValue,
    MPiBeaconDetailsKeysBatteryLevel,
    MPiBeaconDetailsKeysAdvInterval,
    MPiBeaconDetailsKeysPower,
    MPiBeaconDetailsKeysConnected,
    MPiBeaconDetailsKeysActionResetContext,
    MPiBeaconDetailsKeysActionSetContext,
    MPiBeaconDetailsKeysActionSetAdvInterval,
    MPiBeaconDetailsKeysActionSetPower,
    MPiBeaconDetailsKeysAll
};

@interface MPiBeaconDetailsViewController () <MPBeaconManagerDelegate, MPBeaconProfileSelectionViewControllerDelegate, MPAdvertisingIntervalSelectionProtocol, MPPowerSelectionProtocol>

@property (nonatomic,strong) MPBeaconManager *beaconManager;
@property (nonatomic,strong) ESTBeacon *beacon;
@property (nonatomic,strong) NSString *context;
@end

@implementation MPiBeaconDetailsViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self initializeBeaconManager];
    [self initializeBeacon];
    [self initializeBeaconContext];
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

- (void)initializeBeaconContext {
    if (nil == self.beaconManager) {
        NSLog(@"Cannot bootstrap BeaconProfile property from nil ESTBeacon instance.");
        return;
    }
    self.context = [MPUtils contextForESTBeacon:self.beacon];
}

- (void)initializeRowTitles {
    self.rowTitles = @[@"Current context",
                       @"Proximity UUID",
                       @"Major value",
                       @"Minor value",
                       @"Battery level",
                       @"Advertising Interval",
                       @"Power level",
                       @"Connected",
                       @"Action",
                       @"Action",
                       @"Action",
                       @"Action"];
}

- (void)initializeRowValues {
   self.rowValues = @[  self.context,
                        [MPUtils stringValueForObject:[self.beacon.proximityUUID UUIDString]],
                        [MPUtils stringValueForObject:self.beacon.major],
                        [MPUtils stringValueForObject:self.beacon.minor],
                        self.beacon.batteryLevel? [NSString stringWithFormat:@"%@%%",self.beacon.batteryLevel] : @"Unknown",
                        self.beacon.advInterval? [NSString stringWithFormat:@"%@ ms",self.beacon.advInterval] : @"Unknown",
                        self.beacon.power? [NSString stringWithFormat:@"%@ dBm", self.beacon.power]  : @"Unknown",
                        self.beacon.isConnected? @"Yes" : @"No",
                        kResetContext,
                        kSetContext,
                        kSetAdvInterval,
                        kSetPower];
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

- (void)setAdvertisingInterval {
    [self performSegueWithIdentifier:@"setAdvIntSegue" sender:self];
}

- (void)setPower {
    [self performSegueWithIdentifier:@"setPowerSegue" sender:self];
}
#pragma mark - Table View

- (void)reloadTableViewData {
    [self initializeBeaconContext];
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
        case MPiBeaconDetailsKeysActionSetAdvInterval:
            if (self.beacon.isConnected) {
                [self setAdvertisingInterval];
            }
            break;
        case MPiBeaconDetailsKeysActionSetPower:
            if (self.beacon.isConnected) {
                [self setPower];
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
        case MPiBeaconDetailsKeysActionSetAdvInterval:
        case MPiBeaconDetailsKeysActionSetPower:
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
    NSString *message = [NSString stringWithFormat:@"Manager failed connecting beacon: %@. Error: %@.", beacon, [error debugDescription]];
    NSLog(@"%@", message);
}

- (void)manager:(MPBeaconManager*)manager didConnectToBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did connect beacon: %@.",beacon);
    [self reloadTableViewData];
    [self hideLoadingIndicator];
    [beacon readBeaconPowerWithCompletion:^(ESTBeaconPower value, NSError *error) {
        [self reloadTableViewData];
    }];
}

- (void)manager:(MPBeaconManager*)manager didDisconnectBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did disconnect beacon: %@.",beacon);
    [self reloadTableViewData];
    if (nil != self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSString *message = @"Beacon was disconnected :(";
        [MPUtils displayAlertViewForMessage:message];
    }
}

- (void)manager:(MPBeaconManager*)manager didResetContextToBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did reset context to beacon: %@.",beacon);
    [self reloadTableViewData];
}

- (void)manager:(MPBeaconManager*)manager didFailResettingContextToBeacon:(ESTBeacon *)beacon withError:(NSError*)error {
    NSString *message = [NSString stringWithFormat:@"Manager failed resetting context to beacon: %@. Error: %@.", beacon, [error debugDescription]];
    NSLog(@"%@", message);
    [MPUtils displayAlertViewForMessage:message];
}


- (void)manager:(MPBeaconManager*)manager didSetContext:(id)context toBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did set context: %@ to beacon: %@.", context, beacon);
    [self reloadTableViewData];
}

- (void)manager:(MPBeaconManager*)manager didFailSettingContext:(id)context toBeacon:(ESTBeacon *)beacon  withError:(NSError*)error {
    NSString *message = [NSString stringWithFormat:@"Manager failed setting context: %@ to beacon: %@. Error: %@.", context, beacon, [error debugDescription]];
    NSLog(@"%@", message);
    [MPUtils displayAlertViewForMessage:message];
}

//Setting power to ESTBeacon
- (void)manager:(MPBeaconManager*)manager didSetPower:(ESTBeaconPower)value toBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did set power: %@ to beacon: %@.", [NSNumber numberWithChar:value], beacon);
    [self reloadTableViewData];
}

- (void)manager:(MPBeaconManager*)manager didFailSettingPower:(ESTBeaconPower)value toBeacon:(ESTBeacon *)beacon withError:(NSError*)error {
    NSString *message = [NSString stringWithFormat:@"Manager failed setting power: %@ to beacon: %@. Error: %@.", [NSNumber numberWithChar:value], beacon, [error debugDescription]];
    [MPUtils displayAlertViewForMessage:message];
}

//Setting adv interval to ESTBeacon
- (void)manager:(MPBeaconManager*)manager didSetInterval:(unsigned short)value toBeacon:(ESTBeacon *)beacon {
    NSLog(@"Manager did set advertising interval: %@ to beacon: %@.", [NSNumber numberWithUnsignedShort:value], beacon);
    [self reloadTableViewData];
}

- (void)manager:(MPBeaconManager*)manager didFailSettingInterval:(unsigned short)value toBeacon:(ESTBeacon *)beacon withError:(NSError*)error {
    NSString *message = [NSString stringWithFormat:@"Manager failed setting advertising interval: %@ to beacon: %@. Error: %@.", [NSNumber numberWithUnsignedShort:value], beacon, [error debugDescription]];
    [MPUtils displayAlertViewForMessage:message];
}


#pragma mark - MPBeaconProfileSelectionViewControllerDelegate

- (void)beaconProfileSelectionViewController: (MPBeaconProfileSelectionViewController *)vc didSelectProfile: (id)profile {
    [self.beaconManager setContext:profile];
    [self dismissModalViewController];
}

#pragma mark - MPPowerSelectionViewControllerDelegate

- (void)powerSelectionViewController:(MPPowerSelectionViewController *)vc didSelectPower:(NSNumber *)power {
    NSLog(@"Selected power: %d", [power intValue]);
    [self.beaconManager setPower:power];
    [self dismissModalViewController];
}

#pragma mark - MPAdvertisingIntervalSelectionVCDelegate

- (void)advertisingIntervalSelectionViewController: (MPAdvertisingIntervalSelectionVC *)vc didSelectInterval:(NSNumber *)interval {
    NSLog(@"Selected interval: %d", [interval intValue]);
    [self.beaconManager setAdvertisingInterval:interval];
    [self dismissModalViewController];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"setContextSegue"] || [segue.identifier isEqualToString:@"setAdvIntSegue"] || [segue.identifier isEqualToString:@"setPowerSegue"]) {
        UIViewController *vc = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
        [vc setValue:self forKeyPath:@"delegate"];
    }
}

@end
