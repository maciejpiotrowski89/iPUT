//
//  MPTimetableViewController.m
//  iPUT
//
//  Created by Paciej on 23/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPTimetableViewController.h"

NSString * const kFutureClass = @"Future Class";
NSString * const kOngoingClass = @"Ongoing Class";
NSString * const kPastClass = @"Past Class";

@implementation MPTimetableViewController

#pragma mark - Initialization & Setup
- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self setupPerson];
    [self setupObjects];
    [self setupDateTerms];
    [self setupNavigationItemTitle];
}

- (void)setupPerson {
    self.person = [MPUtils personForCurrentUser];
}

- (void)setupObjects {
    self.objects = [[self.subject.dates allObjects]sortedArrayUsingComparator:^NSComparisonResult(Date *date1, Date *date2) {
        return [date1.dateStart compare:date2.dateStart];
    }];
}

- (void)setupDateTerms {
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.objects.count];
    for (Date *date in self.objects) {
        [array addObject:[NSNumber numberWithUnsignedInteger:[MPUtils dateTermForDate:date]]];
    }
    self.dateTerms = [array copy];
}

- (void)setupNavigationItemTitle {
    self.navigationItem.title = [self.subject description];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    Date *date = [self.objects objectAtIndex:indexPath.row];
    MPDateTerm dateTerm = [[self.dateTerms objectAtIndex:indexPath.row]unsignedIntegerValue];
    UIColor *color = nil;
    NSString * title = nil;
    switch (dateTerm) {
        case MPDateTermPast:
            color = [UIColor lightGrayColor];
            title = kPastClass;
            break;
        case MPDateTermPresent:
            color = [UIColor grayColor];
            title = kOngoingClass;
            break;
        case MPDateTermFuture:
        default:
            title = kFutureClass;
            color = [UIColor darkGrayColor];
            break;
    }
    cell.accessoryView = [self accessoryViewForDateTerm:dateTerm andList:date.list];
    cell.textLabel.text = title;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = [date description];
    return cell;
}

- (UIView *)accessoryViewForDateTerm:(MPDateTerm)dateTerm andList:(ListOfPresence *)list{
    return nil;
}

- (NSString *)tableViewHeaderImageName {
    return @"presence";
}
@end
