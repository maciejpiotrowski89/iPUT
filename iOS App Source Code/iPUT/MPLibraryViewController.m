//
//  MPLibraryViewController.m
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPLibraryViewController.h"
#import "MPLibrarySubscriptionViewController.h"
#import "MPLibraryMonitor.h"
#import "MPSynchronizationFacade.h"

@interface MPLibraryViewController() <MPLibrarySubscriptionViewControllerDelegate, MPLibraryMonitorDelegate>

@property (nonatomic,strong) MPLibraryMonitor *monitor;
@property (nonatomic,strong) NSSet *libraries;

@end

@implementation MPLibraryViewController

#pragma mark - Initializaiton & Setup

- (void)initializeController {
    [self initializeObjects];
    [self initializeTitlesAndValues];
    [self initializeLibraryMonitor];
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)initializeObjects {
    NSMutableSet *objects = [[NSMutableSet alloc]initWithArray:[LibraryResource findAllWithPredicate:[NSPredicate predicateWithFormat:@"libraries.@count == 0 && db_deleted == 0"]]];
    
    for (Library *library in self.libraries) {
        @autoreleasepool {
            NSSet *books = library.resources;
            [objects unionSet: books];
        }
    }
    self.objects = [[objects allObjects]sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
}

- (void)initializeLibraryMonitor {
    self.monitor = [MPLibraryMonitor new];
    self.monitor.delegate = self;
}

- (void)initializeTitlesAndValues {
    NSMutableArray *titles = [[NSMutableArray alloc]initWithCapacity:self.objects.count];
    NSMutableArray *values = [[NSMutableArray alloc]initWithCapacity:self.objects.count];
    for (LibraryResource *book in self.objects) {
        [titles addObject:book.author];
        [values addObject:book.title];
    }
    self.rowTitles = titles;
    self.rowValues = values;
}

- (void)setupController {
    [self.monitor startMonitoringLibrariesForCurrentUser];
}

- (void)dealloc {
    [self.monitor stopMonitoringLibrariesForCurrentUser];
}

#pragma mark - Instance methods

- (void)reinitializeTableData {
    [self initializeObjects];
    [self initializeTitlesAndValues];
}

-  (void)reloadTableViewData {
    [self reinitializeTableData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)closeBookIfLibraryNotAvailable {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc respondsToSelector:NSSelectorFromString(@"book")]) {
            LibraryResource *book = [vc valueForKeyPath:@"book.resource"];
            if (nil != book && ![book.libraries intersectsSet:self.libraries]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        }
    }
}

- (NSString *)tableViewHeaderImageName {
    return @"library";
}

#pragma mark - MPLibrarySubscriptionViewControllerDelegate

- (void)librarySubscriptionViewControllerDidCancel: (MPLibrarySubscriptionViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)librarySubscriptionViewController: (MPLibrarySubscriptionViewController *)vc didSelectLibraries: (NSSet *)libraries {
    [MPUtils subscribeLibrariesForCurrentUser:libraries withCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            [self.monitor reinitialize];
            [self reloadTableViewData];
            NSString *message = [NSString stringWithFormat:@"You changed your library subscription. Some of the resources can be no longer available."];
            [MPUtils displayAlertViewForMessage: message];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MPLibraryMonitorDelegate

- (void)currentLibrariesChanged:(NSSet *)libraries {
    self.libraries = libraries;
    [self reloadTableViewData];
    [self closeBookIfLibraryNotAvailable];
    [[MPSynchronizationFacade sharedInstance]synchronizeDatabaseModifications];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loadBookSegue"]) {
        UIViewController *vc = (UIViewController *)segue.destinationViewController;
        LibraryResource *book = [self objectForCell:sender];
        [vc setValue:book.blob forKey:@"book"];
    } else if([segue.identifier isEqualToString:@"subscribeLibrariesSegue"]) {
        UIViewController *vc = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
        [vc setValue:self forKeyPath:@"delegate"];
        [vc setValue:[MPUtils subscribedLibrariesForCurrentUser] forKeyPath:@"selectedLibraries"];
    }
}

@end
