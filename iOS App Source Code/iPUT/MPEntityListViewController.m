//
//  MPEntityListViewController.m
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityListViewController.h"
#import "MPSynchronizationFacade.h"

@implementation MPEntityListViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.isAddButtonEnabled = YES;
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self initializeObjects];
    [self initializeRowTitles];
    [self initializeNavigationItemTitle];
    [self setupAddButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataAfterDatabaseSave:) name:kDatabaseListSavedNotificaiton object:nil];
    if(nil != self.propertyValue) {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:[self.objects indexOfObject:self.propertyValue] inSection:0];
        [self.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:ip];
    }
}

-(void)reloadDataAfterDatabaseSave:(NSNotification *)notification {
    [self reinitializeData];
    [[MPSynchronizationFacade sharedInstance]synchronizeDatabaseModifications];
}

- (void)initializeObjects {
    if (nil == self.parentEntity) {
        self.objects = [NSClassFromString(self.className) findByAttribute:@"db_deleted" withValue:@NO];
    } else {
        self.objects = [[[self.parentEntity valueForKey:self.propertyName]allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"db_deleted == 0"]];
    }
}

- (void)initializeRowTitles {
    self.rowTitles = self.objects;
}

- (void) reinitializeData {
    [self initializeObjects];
    [self initializeRowTitles];
    [self.tableView reloadData];
}

- (void)initializeNavigationItemTitle {
    if (nil != self.displayedClassName && ![self.displayedClassName isEqualToString:@""]) {
        self.navigationItem.title = self.displayedClassName;
    }
}

- (void)setupAddButton {
    self.addButton.enabled = self.isAddButtonEnabled;
}

#pragma mark - Modal Controller Delegate

-(IBAction)rightNavigationBarButtonPressed:(id)sender {
    id object = [self rowTitleForSelectedRow];
    if (nil != object) {
        [self.delegate selectEntityControllerDidRequestSaveObject:object forPropertyName:self.propertyName];
    }
}

-(IBAction)leftNavigationBarButtonPressed:(id)sender {
    [self.delegate modalControllerDidCancel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    if ([indexPath compare:selectedIndexPath] == NSOrderedSame) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nil != self.delegate) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nil != self.delegate) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isAddButtonEnabled;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [MPUtils displayAlertViewForMessage:[NSString stringWithFormat:@"Do you really want to remove %@ entity?", [self objectForIndexPath:indexPath]] andDelegate:self];
        alert.tag = indexPath.row;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {// ok
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:alertView.tag inSection:0];
        NSManagedObject *object = [self objectForIndexPath:indexPath];
        [MPUtils removeDatabaseNode:object];
        [MPUtils saveToContext:[object managedObjectContext]];
        [self.tableView beginUpdates];
        NSMutableArray *mutableObjects = [self.objects mutableCopy];
        [mutableObjects removeObjectAtIndex:indexPath.row];
        self.objects = mutableObjects;
        [self initializeRowTitles];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:kDatabaseListSavedNotificaiton object:nil]];
    }
}

#pragma mark - Create New Entity Controller Delegate

- (void)createNewEntityControllerDidRequestSaveObject:(id)object forClassName:(NSString *)name {
    if (nil != self.parentEntity) {
        if ([name isEqualToString:@"Room"] && ![MPUtils isRoomNumber:object uniqueAtFloor:self.parentEntity]) {//check room uniqueness or error
            [MPUtils displayAlertViewForMessage:[NSString stringWithFormat:@"Room number (%@) should be uniqe on the  %@.", [object valueForKey:@"number"], self.parentEntity]];
            return;
        
        } else if ([name isEqualToString:@"Floor"] && ![MPUtils isFloorNumber:object uniqueInBuilding:self.parentEntity]) { //check floor uniqueness or error
            [MPUtils displayAlertViewForMessage:[NSString stringWithFormat:@"Floor number (%@) should be uniqe in the building %@.", [object valueForKey:@"number"], self.parentEntity]];
            return;
        }
        [object setValue:@YES forKey:@"db_modified"];
        NSMutableArray *array = [self.objects mutableCopy];
        [array addObject:object];
        NSSet *set = [NSSet setWithArray:array];
        
        [self.parentEntity setValue:set forKey:self.propertyName];
        [self.parentEntity setValue:@YES forKey:@"db_modified"];
        if ([name isEqualToString:@"Room"]) {
            BeaconProfile *beacon = [MPUtils createBeaconProfileForRoom:object];
            [object setValue:beacon forKey:@"beacon"];
        }
    }
    if ([name isEqualToString:@"User"] && ![MPUtils isUserValid:object]) { //check floor uniqueness or error
        [MPUtils displayAlertViewForMessage:[NSString stringWithFormat:@"User data is invalid."]];
        return;
    }
    
    [MPUtils saveContextWithCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:kDatabaseListSavedNotificaiton object:nil]];
            [self dismissModalViewController];
        } else if (nil != error) {
            [MPUtils displayErrorAlertViewForMessage:[error description]];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"entityDetailsSegue"] || [segue.identifier isEqualToString:@"displayEntitySegue"]) {
        UIViewController *vc = segue.destinationViewController;
        id object = [self objectForCell:sender];
        [vc setValue:object forKey:@"object"];
        [vc setValue:NSStringFromClass([object class]) forKey:@"className"];
    } else if ([segue.identifier isEqualToString:@"addEntitySegue"]) {
        UIViewController *vc = [[segue.destinationViewController viewControllers] firstObject];
        [vc setValue:self forKey:@"delegate"];
        [vc setValue:self.parentEntity forKey:@"parentEntity"];
        [vc setValue:self.className forKey:@"className"];
        [vc setValue:@YES forKey:@"isCreatingNewEntity"];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
