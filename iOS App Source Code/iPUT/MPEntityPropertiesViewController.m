//
//  MPEntityPropertiesViewController.m
//  iPUT
//
//  Created by Paciej on 17/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityPropertiesViewController.h"
#import "MPDisplayableEntityPropertiesFacade.h"
#import "NSManagedObject+Utils.h"
#import "MPSynchronizationFacade.h"

@interface MPEntityPropertiesViewController()

@property (nonatomic,strong) MPDisplayableEntityProperties *displayableProperties;
@property (nonatomic) BOOL isEditModeEnabled;

@end

@implementation MPEntityPropertiesViewController

static NSString * _headerFooterReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";

#pragma mark - Initialization & Setup

- (void)initializeController {
    self.shouldSetupLoadingIndicatorAtSetup = YES;
}

- (void)setupController {
    [self initializeDisplayablePropertiesObject];
    [self initializeNavigationItemTitle];
    [self initializeEntityObject];
    self.isEditModeEnabled = NO;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:_headerFooterReuseIdentifier];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataAfterDatabaseSave:) name:kDatabaseEntitySavedNotificaiton object:nil];
}

- (void)initializeDisplayablePropertiesObject {
    self.displayableProperties = [MPDisplayableEntityPropertiesFacade propertiesForClassName:self.className];
}

- (void)initializeNavigationItemTitle {
    self.navigationItem.title = self.className;
}

- (void)initializeEntityObject {
    if(YES == self.isCreatingNewEntity) {
        self.object = [MPUtils createManagedObjectForClassName:self.className];
    }
}

-(void)reloadDataAfterDatabaseSave:(NSNotification *)notification {
    if (NO == self.isCreatingNewEntity) {
        [[MPSynchronizationFacade sharedInstance]synchronizeDatabaseModifications];
    }
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = self.displayableProperties.properties.count;
            break;
        case 1:
            count = self.displayableProperties.sets.count;
            break;
        case 2:
            count = self.displayableProperties.objects.count;
            break;
        default:
            break;
    }
    return count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isCreatingNewEntity) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Properties";
        case 1:
            return @"Sets of objects";
        case 2:
            return @"Object relationships";
    }
    return @"";
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:_headerFooterReuseIdentifier];
    view.textLabel.textColor = GLOBAL_TINT;
    view.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (self.displayableProperties.properties.count == 0) {
                return 30.0;
            }
        } break;
        case 1:
        {
            if (self.displayableProperties.sets.count == 0) {
                return 30.0;
            }
        } break;
        case 2:
        {
            if (self.displayableProperties.objects.count == 0) {
                return 30.0;
            }
        } break;
    }
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (self.displayableProperties.properties.count == 0) {
                return @"This entity has no properties.";
            }
        } break;
        case 1:
        {
            if (self.displayableProperties.sets.count == 0) {
                return @"This entity has no sets of objects.";
            }
        } break;
        case 2:
        {
            if (self.displayableProperties.objects.count == 0) {
                return @"This entity has no object relationships.";
            }
        } break;
    }
    return @"";
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:_headerFooterReuseIdentifier];
    view.textLabel.textColor = [UIColor darkGrayColor];
    view.textLabel.text = [self tableView:tableView titleForFooterInSection:section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = (self.isEditModeEnabled == YES)? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self rowTitleForIndexPath:indexPath]description];
    cell.detailTextLabel.text = [MPUtils stringValueForObject:[[self rowValueForIndexPath:indexPath]customDescription]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (NO == self.isEditModeEnabled && NO == self.isCreatingNewEntity) {
        switch (indexPath.section) {
            case 0:
                [self performSegueWithIdentifier:@"displayPropertySegue" sender:indexPath];
                break;
            case 1:
                [self performSegueWithIdentifier:@"displaySetSegue" sender:indexPath];
                break;
            case 2:
                if (nil != [self rowValueForIndexPath:indexPath]) {
                    [self performSegueWithIdentifier:@"displayEntitySegue" sender:indexPath];
                }
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
                if ([NSStringFromClass([self.object classOfPropertyNamed:[self rowPropertyNameForIndexPath:indexPath]])isEqualToString:@"NSDate"]) {
                    [self performSegueWithIdentifier:@"editDatePropertySegue" sender:indexPath];
                } else {
                    [self performSegueWithIdentifier:@"editPropertySegue" sender:indexPath];
                }
                break;
            case 1:
                if (0 == self.displayableProperties.setsAcceptableObjectTypes.count) {
                    [self performSegueWithIdentifier:@"displaySetSegue" sender:indexPath];
                } else {
                    if (nil != [self setPropertyTypeForIndexPath:indexPath]) {
                        [self performSegueWithIdentifier:@"editSetSegue" sender:indexPath];
                    }
                }
                break;
            case 2:
                [self performSegueWithIdentifier:@"selectEntitySegue" sender:indexPath];
                break;
        }
    }
}

- (id)rowTitleForIndexPath:(NSIndexPath *)indexPath {
    id key = @"";
    switch (indexPath.section) {
        case 0:
            key = [self.displayableProperties.propertiesNames objectAtIndex:indexPath.row];
            break;
        case 1:
            key = [self.displayableProperties.setsNames objectAtIndex:indexPath.row];
            break;
        case 2:
            key = [self.displayableProperties.objectsNames objectAtIndex:indexPath.row];
            break;
    }
    return key;
}

- (id)rowPropertyNameForIndexPath:(NSIndexPath *)indexPath {
    id key = @"";
    switch (indexPath.section) {
        case 0:
            key = [self.displayableProperties.properties objectAtIndex:indexPath.row];
            break;
        case 1:
            key = [self.displayableProperties.sets objectAtIndex:indexPath.row];
            break;
        case 2:
            key = [self.displayableProperties.objects objectAtIndex:indexPath.row];
            break;
    }
    return key;
}

- (id)setPropertyTypeForIndexPath:(NSIndexPath *)indexPath {
    id key = nil;
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            key = [self.displayableProperties.setsAcceptableObjectTypes objectAtIndex:indexPath.row];
            break;
        case 2:
            break;
    }
    return key;
}

- (id)rowValueForIndexPath:(NSIndexPath *)indexPath {
    id value = @"";
    switch (indexPath.section) {
        case 0:
            value = [self.object valueForKey:[self.displayableProperties.properties objectAtIndex:indexPath.row]];
            break;
        case 1:
            value = [self.object valueForKey:[self.displayableProperties.sets objectAtIndex:indexPath.row]];
            break;
        case 2:
            value = [self.object valueForKey:[self.displayableProperties.objects objectAtIndex:indexPath.row]];
            break;
    }
    return value;
}

#pragma mark - Modal Controller Delegate

- (void)editPropertyControllerDidRequestSaveObject:(id)object forPropertyName:(NSString *)name {
    if([self.object isKindOfClass:[Building class]] && [name isEqualToString:@"major"]) {
        //verify building
        if([MPUtils isBuildingMajorUnique:object] == NO) {
            [MPUtils displayErrorAlertViewForMessage:[NSString stringWithFormat:@"The %@ property should be uniqe amongst all entities of %@ type.", name, NSStringFromClass([self.object class])]];
            return;
        }
    } else if([self.object isKindOfClass:[Student class]] && [name isEqualToString:@"studentID"]) {
        //verify student
        if([MPUtils isStudentIDUnique:object] == NO) {
            [MPUtils displayErrorAlertViewForMessage:[NSString stringWithFormat:@"The %@ property should be uniqe amongst all entities of %@ type.", name, NSStringFromClass([self.object class])]];
            return;
        } else if (NO == [MPUtils isStudentIDValid:object]) {
            [MPUtils displayErrorAlertViewForMessage:[NSString stringWithFormat:@"The %@ property value is not valid. Should be at least %tu", name, kMinStudentIdNumber]];
            return;
        }
    } else if([self.object isKindOfClass:[Lecturer class]] && [name isEqualToString:@"lecturerID"]) {
        //verify lecturer
        if([MPUtils isLecturerIDUnique:object] == NO) {
            [MPUtils displayErrorAlertViewForMessage:[NSString stringWithFormat:@"The %@ property should be uniqe amongst all entities of %@ type.", name, NSStringFromClass([self.object class])]];
            return;
        } else if (NO == [MPUtils isLecturerIDValid:object]) {
            [MPUtils displayErrorAlertViewForMessage:[NSString stringWithFormat:@"The %@ property value is not valid. Should be at most %tu", name, kMaxLecturerIdNumber]];
            return;
        }
    }
    [self saveObject:object forPorpertyName:name];
    if (NO == self.isCreatingNewEntity) {
        [self dismissModalViewController];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)selectEntityControllerDidRequestSaveObject:(id)object forPropertyName:(NSString *)name {    
    [self saveObject:object forPorpertyName:name];
    [self dismissModalViewController];
}

- (void)saveObject:(id)object forPorpertyName:(NSString *)name{
    id oldObject = [self.object valueForKey:name];
    if (oldObject != object) {
        if ([self.object isKindOfClass:[User class]] && [object isKindOfClass:[Lecturer class]]) {
            Lecturer *lecturer = (Lecturer *)object;
            lecturer.user.db_modified = @YES;
            lecturer.user = nil;
            User *user = (User *) self.object;
            user.student = nil;
        } else if ([self.object isKindOfClass:[User class]] && [object isKindOfClass:[Student class]]) {
            Student *student = (Student *)object;
            student.user.db_modified = @YES;
            student.user = nil;
            User *user = (User *) self.object;
            user.lecturer = nil;
        } else if ([self.object isKindOfClass:[Chair class]] && [object isKindOfClass:[Lecturer class]]) {
            Lecturer *lecturer = (Lecturer *)object;
            lecturer.headOfChair.db_modified = @YES;
        } else if ([self.object isKindOfClass:[Lecturer class]] && [object isKindOfClass:[Room class]]) {
            Room *room = (Room *)object;
            room.lecturer.db_modified = @YES;
        }
        [self.object setValue:object forKey:name];
        if([self.object isKindOfClass:[Building class]] && [name isEqualToString:@"major"]) {
            [MPUtils updateBeaconProfilesForBuilding:(Building *)self.object];
        } else if ([self.object isKindOfClass:[Student class]] && [name isEqualToString:@"studentID"]){
            [MPUtils updateBeaconProfile:[self.object valueForKey:@"beacon"] forStudent:(Student *)self.object];
        } else if([self.object isKindOfClass:[Lecturer class]] && [name isEqualToString:@"lecturerID"]) {
            [MPUtils updateBeaconProfile:[self.object valueForKey:@"beacon"] forLecturer:(Lecturer *)self.object];
        } else if([self.object isKindOfClass:[Room class]] && [name isEqualToString:@"number"]) {
            [MPUtils updateBeaconProfile:[self.object valueForKey:@"beacon"] forRoom:(Room *)self.object];
        }
        if (NO == self.isCreatingNewEntity) {
        BOOL shouldInvertModifiedKey = ![[self.object valueForKey:@"db_modified"]boolValue];
        [self.object setValue:@YES forKey:@"db_modified"];

           [MPUtils saveContextWithCompletionBlock:^(BOOL success, NSError *error) {
            if (success) {
                [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:kDatabaseEntitySavedNotificaiton object:nil]];

            } else if (nil != error) {
                [MPUtils displayErrorAlertViewForMessage:[error description]];
                [self.object setValue:oldObject forKey:name];
                if (YES == shouldInvertModifiedKey) {
                    [self.object setValue:@NO forKey:@"db_modified"];
                }
            }
        }];
        } else {
            [self reloadDataAfterDatabaseSave:[NSNotification notificationWithName:kDatabaseNewEntityChangedNotificaiton object:nil]];
        }
    }
}
#pragma mark - Button actions

- (IBAction)rightNavigationBarButtonPressed:(UIBarButtonItem *)sender {
    if (YES == self.isCreatingNewEntity) {
        [self.delegate createNewEntityControllerDidRequestSaveObject:self.object forClassName:self.className];
    } else {
        self.isEditModeEnabled = !self.isEditModeEnabled;
        if(YES == self.isEditModeEnabled) {
            sender.title = @"Cancel";
        } else {
            sender.title = @"Edit";
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    if (YES == self.isCreatingNewEntity) {
        [self.object deleteEntity];
    }
    [self.delegate modalControllerDidCancel];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displayPropertySegue"]) {
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:[self rowTitleForIndexPath:sender] forKey:@"propertyDisplayedName"];
        [vc setValue:[self rowValueForIndexPath:sender] forKey:@"propertyValue"];
    } else if ([segue.identifier isEqualToString:@"displayEntitySegue"]) {
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:[self rowValueForIndexPath:sender] forKey:@"object"];
        [vc setValue:NSStringFromClass([self.object classOfPropertyNamed:[self rowPropertyNameForIndexPath:sender]]) forKey:@"className"];
    } else if ([segue.identifier isEqualToString:@"displaySetSegue"]) {
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:self.object forKey:@"parentEntity"];
        [vc setValue:[self rowPropertyNameForIndexPath:sender] forKey:@"propertyName"];
        [vc setValue:[self setPropertyTypeForIndexPath:sender] forKey:@"className"];
        [vc setValue:[self rowTitleForIndexPath:sender] forKey:@"displayedClassName"];
        [vc setValue:@NO forKey:@"isAddButtonEnabled"];
    } else if ([segue.identifier isEqualToString:@"editPropertySegue"]) {
        UIViewController *vc = nil;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            vc =[[segue.destinationViewController viewControllers] firstObject];
        } else {
            vc =segue.destinationViewController;
        }
        [vc setValue:self forKey:@"delegate"];
        [vc setValue:NSStringFromClass([self.object classOfPropertyNamed:[self rowPropertyNameForIndexPath:sender]]) forKey:@"className"];
        [vc setValue:[self rowPropertyNameForIndexPath:sender] forKey:@"propertyName"];
        [vc setValue:[self rowTitleForIndexPath:sender] forKey:@"propertyDisplayedName"];
        [vc setValue:[self rowValueForIndexPath:sender] forKey:@"propertyValue"];

    } else if ([segue.identifier isEqualToString:@"selectEntitySegue"]) {
         UIViewController *vc = [[segue.destinationViewController viewControllers] firstObject];
        [vc setValue:self forKey:@"delegate"];
        [self.object classOfPropertyNamed:[self rowPropertyNameForIndexPath:sender]];
        [vc setValue:NSStringFromClass([self.object classOfPropertyNamed:[self rowPropertyNameForIndexPath:sender]]) forKey:@"className"];
        [vc setValue:[self rowPropertyNameForIndexPath:sender] forKey:@"propertyName"];
        [vc setValue:[self rowValueForIndexPath:sender] forKey:@"propertyValue"];
    } else if ([segue.identifier isEqualToString:@"editSetSegue"]) {
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:self.object forKey:@"parentEntity"];
        [vc setValue:[self rowPropertyNameForIndexPath:sender] forKey:@"propertyName"];
        [vc setValue:[self setPropertyTypeForIndexPath:sender] forKey:@"className"];
    } else if ([segue.identifier isEqualToString:@"editDatePropertySegue"]) {
        UIViewController *vc = nil;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            vc =[[segue.destinationViewController viewControllers] firstObject];
        } else {
            vc =segue.destinationViewController;
        }
        [vc setValue:self forKey:@"delegate"];
        [vc setValue:NSStringFromClass([self.object classOfPropertyNamed:[self rowPropertyNameForIndexPath:sender]]) forKey:@"className"];
        [vc setValue:[self rowPropertyNameForIndexPath:sender] forKey:@"propertyName"];
        [vc setValue:[self rowTitleForIndexPath:sender] forKey:@"propertyDisplayedName"];
        [vc setValue:[self rowValueForIndexPath:sender] forKey:@"propertyValue"];
    }    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
