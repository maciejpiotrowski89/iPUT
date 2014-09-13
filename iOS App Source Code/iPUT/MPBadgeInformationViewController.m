//
//  MPPersonInformationViewController.m
//  iPUT
//
//  Created by Paciej on 23/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBadgeInformationViewController.h"
#import "MPVisitCardTableViewCell.h"
#import "MPKeyValueTableViewCell.h"

NSString * const kInfoCellIdentifier = @"infoCell";
NSString * const kHeaderCellIdentifier = @"headerCell";

@interface MPBadgeInformationViewController ()

@property (nonatomic,strong) NSManagedObject *object;
@property (nonatomic) MPBeaconProfileType profileType;

@end

@implementation MPBadgeInformationViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldEnableUserInteractionOnViewDidLoad = @NO;
}

- (void)setupController {
    [self initializeBeaconProfile];
    [self initializeBeaconContextObject];
    [self initializeRowTitles];
    [self initializeRowValues];
    [self setupUserInteraction];
}

- (void)initializeBeaconProfile {
    self.profileType = [MPUtils beaconProfileTypeForProfile:self.beaconProfile];
}

- (void)initializeBeaconContextObject {
    self.object = [MPUtils objectForBeaconProfile:self.beaconProfile];
}

- (void)initializeRowTitles {
    if ([self hasAnyRowData]) {
        switch (self.profileType) {
            case MPBeaconProfileTypeStudent:
                self.rowTitles = @[@"", @"ID", @"Field", @"Level", @"Degree", @"Group", @"Semester", @"Specialty"];
                break;
            case MPBeaconProfileTypeLecturer:
                self.rowTitles = @[@"", @"ID", @"Chair", @"Degree"];
                break;
            case MPBeaconProfileTypeRoom:
                self.rowTitles = @[@"", @"Name", @"Building", @"Floor", @"Number"];
                break;
        }
    }
}

- (void)initializeRowValues {
    if ([self hasAnyRowData]) {
        switch (self.profileType) {
            case MPBeaconProfileTypeStudent:
                self.rowValues = @[@"firstName, lastName", @"studentID", @"group.yearOfStudies.field", @"group.yearOfStudies.levelOfStudies", @"degree", @"group", @"group.yearOfStudies.semester", @"specialtyOfStudies"];
                break;
            case MPBeaconProfileTypeLecturer:
                self.rowValues = @[@"firstName, lastName", @"lecturerID", @"chair", @"degree"];
                break;
            case MPBeaconProfileTypeRoom:
                self.rowValues = @[@"description", @"name", @"floor.building", @"floor", @"number"];
                break;
        }
    }
}

- (BOOL)hasAnyRowData {
    return nil != self.object;
}

- (void)setupUserInteraction {
    if([self.shouldEnableUserInteractionOnViewDidLoad boolValue]) {
        [self enableUserInteraction];
    }
}

#pragma mark - User Interaction

- (void)enableUserInteraction {
    self.tableView.userInteractionEnabled = YES;
}

- (void)disableUserInteraction {
    if ([self hasAnyRowData]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    self.tableView.userInteractionEnabled = NO;
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160.0;
    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = [self cellIndetifierForRow:row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        NSString *className = [self cellClassNameForForRow:row];
        cell = [[NSClassFromString(className)
                             alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [self setupCell:cell forRow:row];
    return cell;
}

- (NSString *)cellIndetifierForRow:(NSInteger)row {
    switch (row) {
        case 0:
            return kHeaderCellIdentifier;
        default:
            return kInfoCellIdentifier;
    }
}

- (NSString *)cellClassNameForForRow:(NSInteger)row {
    switch (row) {
        case 0:
            return @"MPVisitCardTableViewCell";
        default:
            return @"MPKeyValueTableViewCell";
    }
}

- (NSString *)stringForRowValueAtIndex:(NSInteger)row {
    NSString *string = @"";
    NSArray *valueKeys = [[self.rowValues objectAtIndex:row]componentsSeparatedByString:@", "];
    for (int i = 0; i < valueKeys.count; i++) {
        @autoreleasepool {
            NSString *key = [valueKeys objectAtIndex:i];
            NSString *value = [MPUtils stringValueForObject:[self.object valueForKeyPath:key]];
            string = [NSString stringWithFormat:@"%@ %@", string, value];
        }
    }
    return [string stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
}

- (NSString *)stringForRowTitleAtIndex:(NSInteger)row {
    return [self.rowTitles objectAtIndex:row];
}

- (void)setupCell:(UITableViewCell *)cell forRow:(NSInteger)row {
    switch (row) {
        case 0:
            [cell setValue:[self stringForRowValueAtIndex:row] forKeyPath:@"mainTextLabel.text"];
            [cell setValue:[MPUtils beaconProfileTypeNameForBeaconProfileType:self.profileType] forKeyPath:@"subTextLabel.text"];
            [cell setValue:[MPUtils imageForBeaconProfileObject:self.object beaconProfileType:self.profileType] forKeyPath:@"photoView.image"];
            break;
        default:
            [cell setValue:[self stringForRowTitleAtIndex:row] forKeyPath:@"keyLabel.text"];
            [cell setValue:[self stringForRowValueAtIndex:row] forKeyPath:@"valueLabel.text"];
            break;
    }
}

@end
