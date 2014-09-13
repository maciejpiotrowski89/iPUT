//
//  MPPresenceListViewController.m
//  iPUT
//
//  Created by Paciej on 24/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPPresenceListViewController.h"
#import "MPBadgeInformationViewController.h"
#import "MPStudentFinder.h"
#import "MPSynchronizationFacade.h"

@interface MPPresenceListViewController() <MPStudentFinderDelegate>

@property (nonatomic,strong) MPStudentFinder *finder;

@end

@implementation MPPresenceListViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self setupListOfStudents];
    [self setupStudentFinder];
}

- (void)setupListOfStudents {
    self.objects = [MPUtils listOfAllStudentsForPresenceList:self.list];
    self.rowTitles = self.objects;
}

- (void)setupStudentFinder {
    self.finder = [MPStudentFinder new];
    self.finder.delegate = self;
}

#pragma mark - Instance methods

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    [self.finder discoverStudentsProximity];
}

#pragma mark - Table View

- (Student *)studentForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.objects objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Student *student = [self studentForRowAtIndexPath:indexPath];
    if (![MPUtils student:student presentOnTheList:self.list]) {
        [MPUtils addStudent:student toList:self.list];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [[MPSynchronizationFacade sharedInstance]upsertListOfPresence:self.list];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Student *student = [self studentForRowAtIndexPath:indexPath];
    return [MPUtils student:student presentOnTheList:self.list];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *student = [self studentForRowAtIndexPath:indexPath];
        [MPUtils removeStudent:student fromList:self.list];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [[MPSynchronizationFacade sharedInstance]upsertListOfPresence:self.list];
    }
    [tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    Student *student = [self studentForRowAtIndexPath:indexPath];
    UIColor *color = [UIColor darkGrayColor];
    if ([MPUtils student:student presentOnTheList:self.list]) {
        color = [UIColor greenColor];
    }
    cell.textLabel.textColor = color;
    return cell;
}

#pragma mark - MPStudentFinderDelegate
- (void)studentFinderDidFindStudents:(NSArray *)studnets {
    if(nil != studnets && 0 != studnets.count) {
        [MPUtils addStudents:[NSSet setWithArray:studnets] toList:self.list];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [[MPSynchronizationFacade sharedInstance]upsertListOfPresence:self.list];
        
    }
}

- (void)studentFinderDidStartSearchingStudents {
    [self showLoadingIndicator];
}

- (void)studentFinderDidStopSearchingStudents {
    [self hideLoadingIndicator];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"studentInformationSegue"]) {
        MPBadgeInformationViewController *vc = (MPBadgeInformationViewController *)segue.destinationViewController;
        Student *student = [self objectForCell:sender];
        BeaconProfile *profile = student.beacon;
        [vc setValue:profile forKey:@"beaconProfile"];
        [vc setValue:@YES forKey:@"shouldEnableUserInteractionOnViewDidLoad"];
    }
}

@end
