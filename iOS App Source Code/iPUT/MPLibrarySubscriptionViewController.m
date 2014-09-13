//
//  MPLibrarySubscriptionViewController.m
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPLibrarySubscriptionViewController.h"

@implementation MPLibrarySubscriptionViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.className = kLibraryEntityName;
    [super initializeController];
}

- (void)setupController {
    [super setupController];
    self.objects = [self.objects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    self.rowTitles = self.objects;
    [self setupLibraries];
}

- (void)setupLibraries {
    for (Library *library in self.selectedLibraries) {
        NSInteger index = [self.objects indexOfObject:library];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - Navigation Bar Buttons Action

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if (indexPaths.count >20) {
        [MPUtils displayErrorAlertViewForMessage:[NSString stringWithFormat: @"Subscription is possible to at most 20 libraries. You selected %lul of them.", (unsigned long)indexPaths.count]];
        return;
    }
    NSMutableSet *libraries = [[NSMutableSet alloc]initWithCapacity:indexPaths.count];
    for (NSIndexPath *ip in indexPaths) {
        @autoreleasepool {
            Library *library = [self.objects objectAtIndex:ip.row];
            [libraries addObject:library];
        }
    }
    [self.delegate librarySubscriptionViewController:self didSelectLibraries:libraries];
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate librarySubscriptionViewControllerDidCancel:self];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (NSString *)tableViewHeaderImageName {
    return @"library2";
}

@end
