//
//  MPStudentTimetableViewController.m
//  iPUT
//
//  Created by Paciej on 23/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPStudentTimetableViewController.h"
#import "MPSynchronizationFacade.h"

NSString *const kAdvertiseBadgeSegue = @"advertiseBadgeSegue";

@implementation MPStudentTimetableViewController

#pragma mark - Lifecycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MPSynchronizationFacade sharedInstance] fetchPresenceInfoForStudent:(Student *)self.person];
}

- (void)synchronizationEnded:(NSNotification *)notification {
    [super synchronizationEnded:notification];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)synchronizationFailed:(NSNotification *)notification {
    [super synchronizationFailed:notification];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark - Table View

- (UIView *)accessoryViewForDateTerm:(MPDateTerm)dateTerm andList:(ListOfPresence *)list{
    switch (dateTerm) {
        case MPDateTermFuture:
            return [MPUtils imageViewWithImageNamed:@"listLocked"];
        case MPDateTermPresent:
            if ([self isStudentPresentOnTheList:list]) {
                return [MPUtils imageViewWithImageNamed:@"present"];
            }
            return [MPUtils imageViewWithImageNamed:@"badge"];
        case MPDateTermPast:
            if ([self isStudentPresentOnTheList:list]) {
                return [MPUtils imageViewWithImageNamed:@"present"];
            }
            return [MPUtils imageViewWithImageNamed:@"absent"];
    }
    return nil;
}

- (BOOL)isStudentPresentOnTheList:(ListOfPresence *)list {
    return [list.presentStudents containsObject: self.person];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (MPDateTermPresent == [[self.dateTerms objectAtIndex:indexPath.row] unsignedIntegerValue]) {
        return YES;
//    }
//    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (MPDateTermPresent == [[self.dateTerms objectAtIndex:indexPath.row] unsignedIntegerValue]) {
        [self performSegueWithIdentifier:kAdvertiseBadgeSegue sender:self];
//    }
}

@end
