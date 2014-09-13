//
//  MPSynchronizationFacade.m
//  iPUT
//
//  Created by Paciej on 24/07/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPSynchronizationFacade.h"
#import "MPDisplayableEntityPropertiesFacade.h"

#import <Parse/PFQuery.h>
#import <Parse/PFObject.h>
#import <Parse/PFRelation.h>
#import <Parse/PFCloud.h>

@interface MPSynchronizationFacade ()
@property (readonly, nonatomic,strong) dispatch_queue_t synchronizationQueue;
@property (nonatomic,strong) NSManagedObjectContext *syncContext;
@end

@implementation MPSynchronizationFacade

#pragma mark - Initialization
+ (instancetype)sharedInstance {
    static MPSynchronizationFacade *facade = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        facade = [MPSynchronizationFacade new];
    });
    return facade;
}

- (void)initializeObject {
    _synchronizationQueue = dispatch_queue_create("SynchronizationQueue", DISPATCH_QUEUE_SERIAL);
    _syncContext = [NSManagedObjectContext contextWithParent:[NSManagedObjectContext defaultContext]];
    [[_syncContext userInfo]setObject:@"*Synchronization Queue Context*" forKey:@"kNSManagedObjectContextWorkingName"];
}

#pragma mark - login user in background
- (void)loginUser:(NSString *)user password:(NSString *)password {
    [PFUser logInWithUsernameInBackground:user password:password
                                    block:^(PFUser *user, NSError *error){
                                        if (nil != user) {
                                            dispatch_async(self.synchronizationQueue, ^{
                                                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncStart object:nil];
                                                [self fetchPersonData];
                                                if([[user objectForKey:@"isAdmin"] isEqualToNumber:@NO]){
                                                    [self fetchListOfLibraries];
                                                    [self fetchResourcesWithoutLibraries];
                                                }
                                                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncEnd object:nil];
                                            });
                                        } else {
                                            [MPUtils displayAlertViewForMessage:@"Authentication error. Please, try again."];
                                            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncFail object:nil];
                                        }
                                    }];
}

#pragma mark - Dispatchend on main queue
//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchEntireDatabase {
    BOOL success = YES;
    success = success & [self fetchAndSaveEntitiesForClassName:kUUIDEntityName];
    success = success & [self fetchAndSaveEntitiesForClassName:kBeaconProfileEntityName];
    success = success & [self fetchAndSaveEntitiesForClassName:kUniversityEntityName];
    success = success & [self fetchResourcesWithoutLibraries];
    
    return success;
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchAndSaveEntitiesForClassName:(NSString *)className {
    if (nil == className || [className isEqualToString:@""]) {
        return NO;
    }
    NSError *error = nil;
    PFQuery *query = nil;
    NSArray *objects = nil;
    
    query = [PFQuery queryWithClassName:className];
    objects = [query findObjects:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    for (PFObject *pfobject in objects) {
        [self coreDataEntityForParseObject:pfobject];
    }
    return YES;
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchAndSaveEntitiesForBlankUsers {
    NSError *error = nil;
    PFQuery *query = nil;
    NSArray *objects = nil;
    
    query = [PFUser query];
    [query whereKeyDoesNotExist:@"lecturer"];
    [query whereKeyDoesNotExist:@"student"];
    objects = [query findObjects:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    for (PFObject *pfobject in objects) {
        [self coreDataEntityForParseObject:pfobject];
    }
    return YES;
    
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchPersonData {
    PFUser *user = [PFUser currentUser];
    if([[user objectForKey:@"isAdmin"] isEqualToNumber:@YES]) {
        return [self fetchEntireDatabase];
    } else if ([user objectForKey:@"student"] != nil && [user objectForKey:@"student"] != [NSNull null]) {
        return [self fetchStudentDataForCurrentUser];
    } else if ([user objectForKey:@"lecturer"] != nil && [user objectForKey:@"lecturer"] != [NSNull null]) {
        return [self fetchLecturerDataForCurrentUser];
    }
    return NO;
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchStudentDataForCurrentUser {
    PFUser *user = [PFUser currentUser];
    [self coreDataEntityForParseObject:user];
    
    PFObject *student = [user objectForKey:@"student"];
    
    NSError *error = nil;
    PFQuery *query = nil;
    
    //Fetch beacon profile of student
    query = [PFQuery queryWithClassName:@"BeaconProfile" predicate:[NSPredicate predicateWithFormat:@"student == %@", student]];
    PFObject *beaconProfile = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:beaconProfile];
    
    //Fetch BeaconUUID for user
    query = [PFQuery queryWithClassName:@"BeaconUUID" predicate:[NSPredicate predicateWithFormat:@"%@ IN user", user]];
    PFObject *beaconUUID = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:beaconUUID];

    //Fetch branch of database tree from university root
    query = [PFQuery queryWithClassName:@"University"];
    PFObject *university = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:university];
    
    return YES;
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchLecturerDataForCurrentUser {
    PFUser *user = [PFUser currentUser];
    [self coreDataEntityForParseObject:user];
    
    PFObject *lecturer = [user objectForKey:@"lecturer"];
    
    NSError *error = nil;
    PFQuery *query = nil;
    
    //Fetch beacon profile of lecturer
    query = [PFQuery queryWithClassName:@"BeaconProfile" predicate:[NSPredicate predicateWithFormat:@"lecturer == %@", lecturer]];
    PFObject *beaconProfile = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:beaconProfile];
    
    //Fetch BeaconUUID for user
    query = [PFQuery queryWithClassName:@"BeaconUUID" predicate:[NSPredicate predicateWithFormat:@"%@ IN user", user]];
    PFObject *beaconUUID = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:beaconUUID];
    
    //Fetch branch of database tree from university root
    query = [PFQuery queryWithClassName:@"University"];
    PFObject *university = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:university];

    //Fetch beacon profiles of students
    query = [PFQuery queryWithClassName:@"BeaconProfile"];
    [query whereKeyExists:@"student"];
    NSArray *beaconProfiles = [query findObjects:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    for (PFObject *pfBeaconProfile in beaconProfiles) {
        [self coreDataEntityForParseObject:pfBeaconProfile];
    }
    
    return YES;
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchListOfLibraries {
    NSError *error = nil;
    PFQuery *query = nil;
    
    //Fetch BeaconUUID for building
    query = [PFQuery queryWithClassName:@"BeaconUUID"];
    [query whereKey:@"building" matchesQuery:[PFQuery queryWithClassName:@"Building"]];
    PFObject *beaconUUID = [query getFirstObject:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    [self coreDataEntityForParseObject:beaconUUID];

    //Fetch beacon profiles for rooms
    query = [PFQuery queryWithClassName:@"BeaconProfile"];
    [query whereKeyExists:@"room"];
    NSArray *beaconProfiles = [query findObjects:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    };
    for (PFObject *pfBeaconProfile in beaconProfiles) {
        [self coreDataEntityForParseObject:pfBeaconProfile];
    }

    return YES;
}

//fetchEntireDatabase invoked manually is performed on main thread
- (BOOL)fetchResourcesWithoutLibraries {
    NSArray *resourcesFromLibs = [MPUtils allLibraryResourcesInContext:self.syncContext];
    if (resourcesFromLibs.count == 0) {
        [self fetchListOfLibraries];
    }
    NSMutableArray *objectIDsOfResourcesFromLibs = [[NSMutableArray alloc]initWithCapacity:resourcesFromLibs.count];
    for (NSManagedObject *managedObject in resourcesFromLibs) {
        [objectIDsOfResourcesFromLibs addObject:[managedObject valueForKey:kDatabaseObjectId]];
    }
    //lib resources where does not match room resources
    PFQuery *query = [PFQuery queryWithClassName:@"LibraryResource"];
    [query whereKey:kObjectId notContainedIn:objectIDsOfResourcesFromLibs];
    NSError *error = nil;
    NSArray *resources = [query findObjects:&error];
    if ([self logErrorIfNeeded:error]) {
        return NO;
    }
    
    for (PFObject *pfobject in resources) {
        [self coreDataEntityForParseObject:pfobject];
    }

    return YES;
}

#pragma mark - Dispatchend on background queue
- (BOOL)fetchBlobFileForBlob:(Blob *)blob {
    if (![blob isKindOfClass:[Blob class]]) {
        return NO;
    }
    dispatch_async(self.synchronizationQueue, ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncStart object:nil];
        Blob *currentBlob = [Blob findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kDatabaseObjectId, blob.db_id] inContext:self.syncContext];
        PFQuery *query = [PFQuery queryWithClassName:@"Blob" predicate:[NSPredicate predicateWithFormat:@"%K == %@", kObjectId, currentBlob.db_id]];
        NSError *error = nil;
        PFObject *pfobject = [query getFirstObject:&error];
        if ([self logErrorIfNeeded:error]) {
            return;
        }
        PFFile *file = [pfobject objectForKey:@"file"];
        NSData *data = [file getData:&error];
        if ([self logErrorIfNeeded:error]) {
            return;
        }
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/blob_%@.pdf", documentsDirectory, blob.db_id];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if ([self logErrorIfNeeded:error]) {
                return;
            }
        }
        [data writeToFile:filePath atomically:YES];
        currentBlob.filePath = filePath;
        [MPUtils saveToContext:[currentBlob managedObjectContext]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncEnd object:nil];
    });
    return YES;
}

- (BOOL)fetchPresenceInfoForStudent:(Student *)student {
    if (![student isKindOfClass:[Student class]]) {
        return NO;
    }
    dispatch_async(self.synchronizationQueue, ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncStart object:nil];
        Student *currentStudent = [Student findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kDatabaseObjectId, student.db_id] inContext:self.syncContext];
        PFQuery *query = [PFQuery queryWithClassName:@"ListOfPresence" predicate:[NSPredicate predicateWithFormat:@"%@ IN presentStudents", [self parseObjectForCoreDataEntity:currentStudent]]];
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        if ([self logErrorIfNeeded:error]) {
            return;
        } else {
            NSSet *oldLists = [NSSet setWithSet:currentStudent.listsOfPresence];
            for (ListOfPresence *list in oldLists) { //remove old lists
                [currentStudent removeListsOfPresenceObject:list];
            }
            for (PFObject *pfobject in objects) { //add new lists
                [self coreDataEntityForParseObject:pfobject];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncEnd object:nil];
    });
    return YES;
}

- (BOOL)upsertListOfPresence:(ListOfPresence *)list {
    [self.syncContext reset];
    if (![list isKindOfClass:[ListOfPresence class]]) {
        return NO;
    }
    dispatch_async(self.synchronizationQueue, ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncStart object:nil];
        NSError *error = nil;

        ListOfPresence *currentList = [ListOfPresence findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", kDatabaseObjectId, list.db_id] inContext:self.syncContext];
        PFObject *object = [self parseObjectForCoreDataEntity:currentList];
        [object save:&error];
        if ([self logErrorIfNeeded:error]) {
            return;
        }
        currentList.db_modified = @NO;
        [MPUtils saveToContext:[currentList managedObjectContext]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncEnd object:nil];
    });
    return YES;
}

- (void)synchronizeDatabaseModifications {
    dispatch_async(self.synchronizationQueue, ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncStart object:nil];
        [self deleteRemovedEntities];
        [self upsertModifiedEntities];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncEnd object:nil];
    });
}

- (void)logoutCurrentUser {
    dispatch_async(self.synchronizationQueue, ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncStart object:nil];
        [PFUser logOut];
        [MPUtils deleteDatabaseInContext:self.syncContext];
        [MPUtils deleteFilesInDocumentsDirectory];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncEnd object:nil];
    });
}

#pragma mark - Helper methods - performed on main queue
- (void)deleteRemovedEntities {
    [self.syncContext reset];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedListsOfPresenceInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedDatesInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedSubjectsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedStudentsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedGroupsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedYearsOfStudiesInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedFieldsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedLecturersInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedSpecialtiesInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedChairsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedFacultiesInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedUniversitiesInContext:self.syncContext]];
//    [self deleteManagedObjectsFromParse:[MPUtils allDeletedBlobsInContext:self.syncContext]];
//    [self deleteManagedObjectsFromParse:[MPUtils allDeletedLibraryResourcesInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedLibrariesInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedRoomsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedFloorsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedBuildingsInContext:self.syncContext]];
    [self deleteManagedObjectsFromParse:[MPUtils allDeletedBeaconProfilesInContext:self.syncContext]];
//    [self deleteManagedObjectsFromParse:[MPUtils allDeletedBeaconUUIDsInContext:self.syncContext]];
}

- (void)deleteManagedObjectsFromParse:(NSArray *)managedObjects {
    if (managedObjects.count >0) {
        NSLog(@"Deleted objects: %@",managedObjects);
    }
    for (NSManagedObject *managedObject in managedObjects) {
        @autoreleasepool {
            PFObject *pfobject = [self parseObjectForCoreDataEntity:managedObject];
            NSError *error = nil;
            [pfobject delete:&error];
            if(![self logErrorIfNeeded:error]) {
                [managedObject deleteEntity];
                [MPUtils saveToContext:[managedObject managedObjectContext]];
            }
        }
    }
}

- (void)upsertModifiedEntities {
    [self.syncContext reset];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedBeaconProfilesInContext:self.syncContext]];
//    [self upsertManagedObjectsToParse:[MPUtils allModifiedBeaconUUIDsInContext:self.syncContext]];
//    [self upsertManagedObjectsToParse:[MPUtils allModifiedBlobsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedBuildingsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedChairsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedDatesInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedFacultiesInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedFieldsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedFloorsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedGroupsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedLecturersInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedLibrariesInContext:self.syncContext]];
//    [self upsertManagedObjectsToParse:[MPUtils allModifiedLibraryResourcesInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedListsOfPresenceInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedRoomsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedSpecialtiesInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedStudentsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedSubjectsInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedUniversitiesInContext:self.syncContext]];
    [self upsertUserObjectsToParse:[MPUtils allModifiedUsersInContext:self.syncContext]];
    [self upsertManagedObjectsToParse:[MPUtils allModifiedYearsOfStudiesInContext:self.syncContext]];
}

- (void)upsertManagedObjectsToParse:(NSArray *)managedObjects {
    if (managedObjects.count >0) {
        NSLog(@"Upserted objects: %@",managedObjects);
    }
    for (NSManagedObject *managedObject in managedObjects) {
        @autoreleasepool {
            PFObject *pfobject = [self parseObjectForCoreDataEntity:managedObject];
            NSError *error = nil;
            [pfobject save:&error];
            if(![self logErrorIfNeeded:error]) {
                [managedObject setValue:pfobject.objectId forKey:kDatabaseObjectId];
                [managedObject setValue:@NO forKey:@"db_modified"];
                [MPUtils saveToContext:[managedObject managedObjectContext]];
            }
        }
    }
}

- (void)upsertUserObjectsToParse:(NSArray *)managedObjects {
    for (User *managedObject in managedObjects) {
        @autoreleasepool {
            NSString *objectIdKey = nil;
            NSString *objectId = nil;
            NSDictionary *dict = nil;
            NSError *error = nil;

            //reset person
            dict = @{@"userId":managedObject.db_id};
            [PFCloud callFunction:@"setRelationToPersonForUser" withParameters:dict error:&error];
            if([self logErrorIfNeeded:error]) {
            }
            
            dict = nil;
            
            PFUser *pfobject = (PFUser *)[self parseObjectForCoreDataEntity:managedObject];
            if ([pfobject objectForKey:@"student"] != nil && ![[pfobject objectForKey:@"student"] isKindOfClass:[NSNull class]]) {
                objectIdKey = @"studentId";
                objectId = ((PFObject *)[pfobject objectForKey:@"student"]).objectId;
                dict = @{@"userId":pfobject.objectId, objectIdKey : objectId};
            }
            if ([pfobject objectForKey:@"lecturer"] != nil && ![[pfobject objectForKey:@"lecturer"] isKindOfClass:[NSNull class]]) {
                objectIdKey = @"lecturerId";
                objectId = ((PFObject *)[pfobject objectForKey:@"lecturer"]).objectId;
                dict = @{@"userId":pfobject.objectId, objectIdKey : objectId};
            }
            if (nil != dict) {
                [PFCloud callFunction:@"setRelationToPersonForUser" withParameters:dict error:&error];
                if(![self logErrorIfNeeded:error]) {
                    [managedObject setValue:@NO forKey:@"db_modified"];
                    [MPUtils saveToContext:[managedObject managedObjectContext]];
                }
            } else {
                [managedObject setValue:@NO forKey:@"db_modified"];
                [MPUtils saveToContext:[managedObject managedObjectContext]];
            }
            
        }
    }
}

#pragma mark - Entity 2 Parse, Parse 2 Entity conversion
- (PFObject *)parseObjectForCoreDataEntity:(NSManagedObject *)entity {
    NSString *className = NSStringFromClass([entity class]);
    
    PFObject *(^parseObjectBlock)(NSString *) = ^(NSString *className) {
        id object = nil;
        if ([className isEqualToString:@"User"]) {
            object = [PFUser user];
        } else if ([className isEqualToString:@"Library"]) {
            object = [PFObject objectWithClassName:@"Room"];
            [object setObject:@YES forKey:@"isLibrary"];
        } else {
            object = [PFObject objectWithClassName:className];
        }
        return object;
    };
    
    PFObject *object = parseObjectBlock(className);
    
    if (nil != [entity valueForKey:kDatabaseObjectId]) {
        object.objectId = [entity valueForKey:kDatabaseObjectId];
    }

    MPDisplayableEntityProperties *properties = [MPDisplayableEntityPropertiesFacade propertiesForClassName:className];
    
    //properties:
    for (NSString *key in properties.properties) {
        id value = [entity valueForKey:key];
        if (nil == value) {
            value = [NSNull null];
        }
        [object setObject:value forKey:key];
    }
    
    //relations to single object:
    for (NSString *key in properties.objects) {
        NSManagedObject *cdEntity = [entity valueForKey:key];
        id pfobject = nil;
        if (nil != cdEntity) {
            pfobject = [self parseObjectForCoreDataEntity:cdEntity];
        } else {
            pfobject = [NSNull null];
        }
        [object setObject:pfobject forKey:key];
    }
    NSError *error = nil;

    //relations to multiple objects:
    if (object.objectId != nil) {
        for (NSString *key in properties.sets) {
            PFRelation *relation = [object relationForKey:key];
            NSArray *currentRelationObjects = [[relation query]findObjects:&error];
            for (PFObject *relationObject in currentRelationObjects) {
                [relation removeObject:relationObject];
            }
            NSSet *set = [[entity valueForKey:key] copy];
            for (NSManagedObject *item in set) {
                PFObject *pfobject = [self parseObjectForCoreDataEntity:item];
                [relation addObject:pfobject];
            }
        }
    }

    
    if ([object isKindOfClass:[PFUser class]]) {
        PFUser *user = (PFUser *)object;
        [user removeObjectForKey:@"password"];
        [user removeObjectForKey:@"isAdmin"];
        [user setObject:[entity valueForKey:@"isAdmin"] forKey:@"isAdmin"];
        user.password = [entity valueForKey:@"password"];
        
        if (object.objectId == nil) {
            [user signUp:&error];
        }
    } else {
        if (object.objectId == nil) {
            [object save:&error];
        }
    }
    
    if (nil != error) {
        NSLog(@"Error: %@",[error debugDescription]);
    }
    
    if (nil == [entity valueForKey:kDatabaseObjectId] || [[entity valueForKey:kDatabaseObjectId] isEqualToString:@""]) {
        [entity setValue:object.objectId forKey:kDatabaseObjectId];
        [MPUtils saveToContext:[entity managedObjectContext]];
    }

    return object;
}

- (NSManagedObject *)coreDataEntityForParseObject:(PFObject *)object {
    if (nil == object) {
        return nil;
    }
    __block NSString *className = object.parseClassName;
    NSString *objectID = object.objectId;
    
    NSManagedObject *(^managedObjectBlock)(NSString *) = ^(NSString *objectID) {
        NSManagedObject *managedObject = nil;
        if ([className isEqualToString:@"_User"]) {
            className = @"User";
        } else if ([className isEqualToString:@"ListOfPresence"]) {
            [object fetchIfNeeded];
        } else if ([className isEqualToString:@"Room"]) {
            [object fetchIfNeeded];
            if([[object objectForKey:@"isLibrary"]isEqualToNumber:@YES]) {
                className = @"Library";
            }
        }
        managedObject = [NSClassFromString(className) findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K MATCHES %@", kDatabaseObjectId, objectID] inContext:self.syncContext];
        if (nil == managedObject) {
            managedObject = [NSClassFromString(className) createInContext:self.syncContext];
            [managedObject setValue:objectID forKeyPath:kDatabaseObjectId];
        }
        return managedObject;
    };
    
    NSManagedObject *entity = managedObjectBlock(objectID);
    
    MPDisplayableEntityProperties *properties = [MPDisplayableEntityPropertiesFacade propertiesForClassName:className];
    
    if (YES == [object isDataAvailable]){
        //properties:
        for (NSString *key in properties.properties) {
            id property = [object objectForKey:key];
            if (nil != property && ![property isKindOfClass:[NSNull class]]) {
                [entity setValue:property forKey:key];
            }
        }
    
        //relations to single object:
        for (NSString *key in properties.objects) {
            PFObject *pfobject = [object objectForKey:key];
            if (nil != pfobject && ![pfobject isKindOfClass:[NSNull class]]) {
                NSManagedObject *cdEntity = [self coreDataEntityForParseObject:pfobject];
                [entity setValue:cdEntity forKey:key];
            }
        }
    
        //relations to multiple objects:
        for (NSString *key in properties.sets) {
            PFRelation *relation = [object relationForKey:key];
            if (nil != relation) {
                PFQuery *query = [relation query];
                NSError *error = nil;
                NSArray *items = [query findObjects:&error];
                [self logErrorIfNeeded:error];
                if (nil == error && items.count > 0) {
                    NSString *firstKeyLetter = [[key stringByReplacingCharactersInRange:NSMakeRange(1, [key length] - 1) withString:@""] uppercaseString];
                    NSString *otherKeyLetters = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"add%@%@Object:", firstKeyLetter, otherKeyLetters]);
                    
                    for (PFObject *item in items) {
                        NSManagedObject *cdEntity = [self coreDataEntityForParseObject:item];
                        [entity performSelector:selector withObject:cdEntity];
                    }
                }
            }
        }
    }
    [MPUtils saveToContext:[entity managedObjectContext]];
    return entity;
}

#pragma mark - Error logging and failure notification if needed
- (BOOL)logErrorIfNeeded:(NSError *)error {
    if (nil != error) {
        NSLog(@"%@",[error debugDescription]);
        error = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSyncFail object:nil];
        return YES;
    }
    return NO;
}

@end
