//
//  MPUtils.m
//  iPUT
//
//  Created by Paciej on 22/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPUtils.h"
#import <DateTools/DateTools.h>
#import "MPDisplayableEntityPropertiesFacade.h"

@implementation NSManagedObject(MPUndefinedKey)
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end

@implementation MPUtils

+ (void)setCircularShapeForView:(UIView*)view {
    [self setCornerRadius:view.frame.size.height/2.0 forView:view];
}

+ (void)setCornerRadius:(CGFloat)radius forView:(UIView*)view {
    CALayer *layer = view.layer;
    [layer setCornerRadius:radius];
    [layer setBorderWidth:0.0];
    [layer setMasksToBounds:YES];
}

+ (UIImageView *)imageViewWithImageNamed:(NSString *)name {
    return [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
}

#define kDuration 0.1
#define kDelay 0.0

+ (AnimationBlock)createAnimationForView:(UIView*)view constraint:(NSLayoutConstraint *)constraint constant:(CGFloat)constant offsets:(NSMutableArray *)offsets {
    if (offsets.count == 0) {
        return ^(void){
            constraint.constant = constant;
            [UIView animateKeyframesWithDuration:kDuration delay:kDelay options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
                [view.superview layoutIfNeeded];
            } completion:nil];
        };
    }
    CGFloat offset = [[offsets firstObject]floatValue];
    [offsets removeObjectAtIndex:0];
    return ^(void){
        constraint.constant = constant + offset;
        [UIView animateKeyframesWithDuration:kDuration delay:kDelay options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            [view.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [MPUtils createAnimationForView:view constraint:constraint constant:constant offsets:offsets]();
        }];
    };
}

+ (AnimationBlock)createShakeAnimationForView:(UIView*)view withConstraint: (NSLayoutConstraint *)constraint {
    NSMutableArray *offsets = [NSMutableArray arrayWithArray: @[@30,@(-30),@20,@(-20),@10,@(-10)]];
    return [MPUtils createAnimationForView:view constraint:constraint constant:constraint.constant offsets:offsets];
}

+ (NSString *)iBeaconTypeForESTBeacon: (ESTBeacon *)beacon {
    NSString *type =  @"Unknown";
    NSString *uuid = [beacon.proximityUUID UUIDString];
    if([uuid isEqualToString:kEstimoteBeaconUUID]) {
        type = @"Estimote Beacon";
    }
    else if([uuid isEqualToString:kiPUTPersonBeaconUUID]) {
        switch ([beacon.major unsignedIntegerValue]) {
            case MPPersonalBeaconMajorTypeStudent:
                type = @"Student";
                break;
            case MPPersonalBeaconMajorTypeLecturer:
                type = @"Lecturer";
                break;
        }
    } else if ([uuid isEqualToString:kiPUTBuildingBeaconUUID]) {
        type = @"Room";
    }
    return type;
}

+ (BeaconProfile *)beaconProfileForESTBeacon: (ESTBeacon *)beacon {
    BeaconProfile *profile =  nil;
    profile = [[BeaconProfile findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"proximityUUID MATCHES '%@' AND major MATCHES '%@' AND minor MATCHES '%@' AND db_deleted == 0", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor]]]firstObject];
    return profile;
}

+ (NSString *)beaconProfileDescriptionForBeaconProfile: (BeaconProfile *)beaconProfile {
    return ([beaconProfile description] == nil)? @"None" : [beaconProfile description];
}

+ (NSString *)stringValueForObject:(id)object {
//    if (nil == object) {
//        return @"";
//    }
    NSString *value = [object description];
    if ([value isEqualToString:@"(null)"] || nil == value || [value isEqualToString:@""]) {
        value = @"None";
    }
    return value;
}

+ (UIAlertView *)displayErrorAlertViewForMessage:(NSString *)message {
    UIAlertView *alertView = nil;
    if (message != nil && ![message isEqualToString:@""]) {
        alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    return alertView;
}

+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message {
    UIAlertView *alertView = nil;
    if (message != nil && ![message isEqualToString:@""]) {
        alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    return alertView;
}

+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message andDelegate: (id<UIAlertViewDelegate>)delegate{
    UIAlertView *alertView = nil;
    if (message != nil && ![message isEqualToString:@""] && [delegate conformsToProtocol:@protocol(UIAlertViewDelegate)]) {
        alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
        alertView.delegate = delegate;
        [alertView show];
    }
    return alertView;
}

+ (BeaconProfile *)beaconProfileForCurrentUser {
    BeaconProfile *profile = nil;
    User *user = [MPUtils currentUser];
    if (nil != user.student) {
        profile = user.student.beacon;
    } else if (nil != user.lecturer) {
        profile = user.lecturer.beacon;
    }
    return profile;
}

+ (BOOL)beaconIsInProximity:(CLProximity)proximity {
//    if (CLProximityImmediate == proximity || CLProximityNear == proximity || CLProximityFar == proximity)
    if(CLProximityUnknown != proximity) {
        return YES;
    }
    return NO;
}

+ (MPBeaconProfileType)beaconProfileTypeForProfile:(BeaconProfile *)beaconProfile {
    if (nil != beaconProfile.student) {
        return MPBeaconProfileTypeStudent;
    } else if (nil != beaconProfile.lecturer) {
        return MPBeaconProfileTypeLecturer;
    }
    return MPBeaconProfileTypeRoom;
}

+ (NSString *)beaconProfileTypeNameForBeaconProfileType:(MPBeaconProfileType)beaconProfileType {
    switch (beaconProfileType) {
        case MPBeaconProfileTypeStudent:
            return kStudentEntityName;
        case MPBeaconProfileTypeLecturer:
            return kLecturerEntityName;
        case MPBeaconProfileTypeRoom:
            return kRoomEntityName;
        default:
            return @"";
    }
}

+ (NSManagedObject *)objectForBeaconProfile:(BeaconProfile *)beaconProfile {
    switch ([MPUtils beaconProfileTypeForProfile:beaconProfile]) {
        case MPBeaconProfileTypeStudent:
            return beaconProfile.student;
        case MPBeaconProfileTypeLecturer:
            return beaconProfile.lecturer;
        case MPBeaconProfileTypeRoom:
            return beaconProfile.room;
        default:
            return nil;
    }
}

+ (UIImage *)imageForBeaconProfileObject:(NSManagedObject *)beaconProfileObject beaconProfileType:(MPBeaconProfileType)beaconProfileType {
    Blob *blob = nil;
    UIImage *image = nil;
    switch (beaconProfileType) {
        case MPBeaconProfileTypeRoom:
            return [UIImage imageNamed:@"roomBig"];
        case MPBeaconProfileTypeStudent:
            blob = [beaconProfileObject valueForKeyPath:@"photo"];
            image = [UIImage imageWithContentsOfFile:blob.filePath];
            return (nil != image)? image : [UIImage imageNamed:@"studentBig"];
        case MPBeaconProfileTypeLecturer:
            blob = [beaconProfileObject valueForKeyPath:@"photo"];
            image = [UIImage imageWithContentsOfFile:blob.filePath];
            return (nil != image)? image : [UIImage imageNamed:@"lecturerBig"];
        default:
            return [UIImage imageNamed:@"unknownBig"];
    }
}

+ (ESTBeaconRegion *)beaconRegionForBeaconProfile:(BeaconProfile *)beaconProfile {
    return [[ESTBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:beaconProfile.proximityUUID] major:[[beaconProfile major]unsignedShortValue] minor:[[beaconProfile minor]unsignedShortValue] identifier:beaconProfile.proximityUUID];
}

+ (Library *)libraryForBeaconRegion:(BeaconProfile *)profile {
    Library *library = nil;
    library = [[Library findAllWithPredicate:[NSPredicate predicateWithFormat:@"beacon MATCHES '%@' AND db_deleted == 0", profile]]firstObject];
    return library;
}

+ (BeaconProfile *)beaconProfileForBeaconRegion:(ESTBeaconRegion *)region {
    BeaconProfile *profile =  nil;
    profile = [[BeaconProfile findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"proximityUUID MATCHES '%@' AND major MATCHES '%@' AND minor MATCHES '%@' AND db_deleted == 0", [region.proximityUUID UUIDString], region.major, region.minor]]]firstObject];
    return profile;

}

+ (User *)currentUser {
    return [[User findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"username MATCHES '%@' AND db_deleted == 0", [[PFUser currentUser] username]]]]firstObject];
}

+ (NSManagedObject *)personForCurrentUser {
    User *currentUser = [MPUtils currentUser];
    return [MPUtils personForUser:currentUser];
}

+ (NSManagedObject *)personForUser:(User *)user {
    if (nil != user.student) {
        return user.student;
    } else if (nil != user.lecturer) {
        return user.lecturer;
    }
    return nil;
}

+ (NSArray *)subjectsForCurrentUser {
    return [MPUtils subjectsForUser:[MPUtils currentUser]];
}

+ (NSArray *)subjectsForUser:(User *)user {
    NSManagedObject *person = [MPUtils personForUser:user];
    MPPersonType personType = [MPUtils personTypeForPerson:person];
    NSArray *subjects = nil;
    NSSortDescriptor *descriptorName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    if (MPPersonTypeStudent == personType) {
        Student *student = (Student *)person;
        subjects = [student.group.subjects allObjects];
    } else if (MPPersonTypeLecturer == personType) {
        Lecturer *lecturer = (Lecturer *)person;
        subjects = [lecturer.subjects allObjects];
    }
    return [subjects sortedArrayUsingDescriptors:@[descriptorName]];
}

+ (MPPersonType)personTypeForUser:(User *)user {
    NSManagedObject *person = [MPUtils personForUser:user];
    return [MPUtils personTypeForPerson:person];
}

+ (MPPersonType)personTypeForPerson:(NSManagedObject *)person {
    if ([person isKindOfClass:[Student class]]) {
        return MPPersonTypeStudent;
    } else if ([person isKindOfClass:[Lecturer class]]) {
        return MPPersonTypeLecturer;
    }
    return 0;
}

+ (BeaconUUID *)beaconUUIDForPerson {
    return [[BeaconUUID findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"uuidString MATCHES '%@' AND db_deleted == 0", kiPUTPersonBeaconUUID]]]firstObject];
}

+ (BeaconUUID *)beaconUUIDForRoom {
    return [[BeaconUUID findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"uuidString MATCHES '%@' AND db_deleted == 0", kiPUTBuildingBeaconUUID]]]firstObject];
}

+ (MPDateTerm)dateTermForDate:(Date *)date {
    NSDate *now = [NSDate date];
    if ([date.dateStart isEarlierThanOrEqualTo:now] && [date.dateEnd isLaterThan:now]) { //ongoing
        return MPDateTermPresent;
    } else if ([date.dateEnd isEarlierThanOrEqualTo:now]) {
        return MPDateTermPast;
    }
    return MPDateTermFuture; // [now isEarlierThan:date.dateStart];
}

+ (NSSet *)subscribedLibrariesForCurrentUser {
    NSManagedObject *object = [MPUtils personForCurrentUser];
    return [object valueForKeyPath:@"subscribedLibraries"];
}

+ (void)subscribeLibrariesForCurrentUser:(NSSet *)libraries withCompletionBlock:(MRSaveCompletionHandler)completion{
    NSManagedObject *object = [MPUtils personForCurrentUser];
    [object setValue:libraries forKeyPath:@"subscribedLibraries"];
    [object setValue:@YES forKeyPath:@"db_modified"];

    [MPUtils saveContextWithCompletionBlock:completion];
}

+ (NSArray *)listOfAllStudentsForPresenceList:(ListOfPresence *)list {
    NSArray *students = [list.date.subject.group.students allObjects];
    NSSortDescriptor *descriptorLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *descriptorFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedStandardCompare:)];
    
    return [students sortedArrayUsingDescriptors:@[descriptorLastName, descriptorFirstName]];
}

+ (void)addStudent:(Student *)student toList:(ListOfPresence *)list {
    [list addPresentStudentsObject:student];
    list.db_modified = @YES;
    [MPUtils saveContext];
}

+ (void)addStudents:(NSSet *)students toList:(ListOfPresence *)list {
    NSSet *studentsInGroup = list.date.subject.group.students;
    NSMutableSet *intersection = [students mutableCopy];
    [intersection intersectSet:studentsInGroup];
    [list addPresentStudents:intersection];
    list.db_modified = @YES;
    [MPUtils saveContext];
}

+ (void)removeStudent:(Student *)student fromList:(ListOfPresence *)list {
    [list removePresentStudentsObject:student];
    list.db_modified = @YES;
    [MPUtils saveContext];
}

+ (BOOL)student:(Student *)student presentOnTheList:(ListOfPresence *)list {
    return [list.presentStudents containsObject:student];
}

+ (void)saveToContext:(NSManagedObjectContext *)context {
    [context saveToPersistentStoreAndWait];
}

+ (void)saveContext {
    [[NSManagedObjectContext defaultContext]saveToPersistentStoreAndWait];
}

+ (void)saveContextWithCompletionBlock:(MRSaveCompletionHandler)completion {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:completion];
}

+ (BOOL)isStudentIDUnique:(NSNumber *)identifier {
    NSArray *fetch = [Student findAllWithPredicate:[NSPredicate predicateWithFormat:@"studentID == %@ AND db_deleted == 0", identifier]];
    if (fetch.count == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isStudentIDValid:(NSNumber *)identifier {
    return [identifier unsignedIntegerValue] >= kMinStudentIdNumber;
}

+ (BOOL)isLecturerIDUnique:(NSNumber *)identifier {
    NSArray *fetch = [Lecturer findAllWithPredicate:[NSPredicate predicateWithFormat:@"lecturerID == %@ AND db_deleted == 0", identifier]];
    if (fetch.count == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLecturerIDValid:(NSNumber *)identifier {
    return [identifier unsignedIntegerValue] <= kMaxLecturerIdNumber;
}

+ (BOOL)isBuildingMajorUnique:(NSNumber *)identifier {
    NSArray *fetch = [Building findAllWithPredicate:[NSPredicate predicateWithFormat:@"major == %@ AND db_deleted == 0", identifier]];
    if (fetch.count == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isFloorNumber:(Floor *)floor uniqueInBuilding:(Building *)building {
    NSSet *floors = building.floors;
    BOOL isUnique = YES;
    for (Floor *f in floors) {
        if ([f.number isEqualToNumber:floor.number]) {
            isUnique = NO;
        }
    }
    return isUnique;
}

+ (BOOL)isRoomNumber:(Room*)room uniqueAtFloor:(Floor *)floor{
    NSSet *rooms = floor.rooms;
    BOOL isUnique = YES;
    for (Room *r in rooms) {
        if ([r.number isEqualToNumber:room.number]) {
            isUnique = NO;
        }
    }
    return isUnique;
}

+ (BOOL)isUserValid:(User *)user {
    NSArray *fetch = [User findAllWithPredicate:[NSPredicate predicateWithFormat:@"username == %@ AND db_deleted == 0", user.username]];
    BOOL isValid = YES;
    if (fetch.count != 1 || (nil != user.lecturer && nil != user.student)) {//beacuse the existing user from fetch is equal the argument of this function
        isValid = NO;
    }
    return isValid;
}

+ (NSManagedObject *)createManagedObjectForClassName:(NSString *)name {
    NSManagedObject *object = nil;
    if (nil != name && ![name isEqualToString:@""]) {
        object = [NSClassFromString(name) createEntity];
        [object setValue:@YES forKey:@"db_modified"];
        if([name isEqualToString:@"Student"]) {
            id beacon = [MPUtils createBeaconProfileForStudent:(Student *)object];
            [object setValue:beacon forKey:@"beacon"];
        } else if([name isEqualToString:@"Lecturer"]) {
            id beacon = [MPUtils createBeaconProfileForLecturer:(Lecturer *)object];
            [object setValue:beacon forKey:@"beacon"];
        } else if([name isEqualToString:@"Building"]) {
            [object setValue:[MPUtils beaconUUIDForRoom] forKey:@"beaconUUID"];
        } else if([name isEqualToString:@"Date"]) {
            [object setValue:[ListOfPresence createEntity] forKey:@"list"];
        } else if ([name isEqualToString:@"User"]) {
            [object setValue:[MPUtils beaconUUIDForPerson] forKey:@"beaconUUID"];
        }
    }
    return object;
}

+ (BeaconProfile *)createBeaconProfileForRoom:(Room *)room {
    BeaconProfile *beacon = [BeaconProfile createEntity];
    return [self updateBeaconProfile:beacon forRoom:room];
}

+ (BeaconProfile *)createBeaconProfileForLecturer:(Lecturer *)lecturer {
    BeaconProfile *beacon = [BeaconProfile createEntity];
    return [self updateBeaconProfile:beacon forLecturer:lecturer];
}

+ (BeaconProfile *)createBeaconProfileForStudent:(Student *)student {
    BeaconProfile *beacon = [BeaconProfile createEntity];
    return [self updateBeaconProfile:beacon forStudent:student];
}

+ (BeaconProfile *)updateBeaconProfile:(BeaconProfile*)beacon forRoom:(Room *)room {
    beacon.proximityUUID = kiPUTBuildingBeaconUUID;
    beacon.major = room.floor.building.major;
    beacon.minor = room.number;
    beacon.db_modified = @YES;
    
    return beacon;
}

+ (BeaconProfile *)updateBeaconProfile:(BeaconProfile*)beacon forLecturer:(Lecturer *)lecturer {
    beacon.proximityUUID = kiPUTPersonBeaconUUID;
    beacon.major = [NSNumber numberWithUnsignedInteger: MPPersonalBeaconMajorTypeLecturer];
    beacon.minor = lecturer.lecturerID;
    beacon.db_modified = @YES;

    return beacon;
}

+ (BeaconProfile *)updateBeaconProfile:(BeaconProfile*)beacon forStudent:(Student *)student {
    beacon.proximityUUID = kiPUTPersonBeaconUUID;
    beacon.major = [NSNumber numberWithUnsignedInteger: MPPersonalBeaconMajorTypeStudent];
    beacon.minor = student.studentID;
    beacon.db_modified = @YES;

    return beacon;
}

+ (void)updateBeaconProfilesForBuilding:(Building *)building {
    for (Floor *floor in building.floors) {
        for (Room *room in floor.rooms) {
            [MPUtils updateBeaconProfile:room.beacon forRoom:room];
        }
    }
}

+ (User *)createUser {
    User *user = [User createEntity];
    user.beaconUUID = [MPUtils beaconUUIDForPerson];
    return user;
}

+ (void)removeDatabaseNode:(NSManagedObject *)object {
    [object setValue:@YES forKey:@"db_deleted"];
    if (nil != [object valueForKey:@"beacon"]) {
        [object setValue:@YES forKeyPath:@"beacon.db_deleted"];
    }
    if (nil != [object valueForKey:@"list"]) {
        [object setValue:@YES forKeyPath:@"list.db_deleted"];
    }
    NSMutableArray *sets =[[[MPDisplayableEntityPropertiesFacade propertiesForClassName: NSStringFromClass([object class])] sets] mutableCopy];
    [sets removeObjectsInArray:@[@"presentStudents", @"subscribedLibraries", @"subjects", @"resources"]];
    for (NSString *setName in sets) {
        NSSet *relation = [object valueForKeyPath:setName];
        for (NSManagedObject *managedObject in relation) {
            [MPUtils removeDatabaseNode:managedObject];
        }
    }
    [MPUtils saveToContext:[object managedObjectContext]];
}

+ (NSArray *)allBeaconProfilesInContext:(NSManagedObjectContext *)context {
    return [BeaconProfile findAllInContext:context];
}

+ (NSArray *)allBeaconUUIDsInContext:(NSManagedObjectContext *)context {
    return [BeaconUUID findAllInContext:context];
}

+ (NSArray *)allBlobsInContext:(NSManagedObjectContext *)context {
    return [Blob findAllInContext:context];
}

+ (NSArray *)allBuildingsInContext:(NSManagedObjectContext *)context {
    return [Building findAllInContext:context];
}

+ (NSArray *)allChairsInContext:(NSManagedObjectContext *)context {
    return [Chair findAllInContext:context];
}

+ (NSArray *)allDatesInContext:(NSManagedObjectContext *)context {
    return [Date findAllInContext:context];
}

+ (NSArray *)allFacultiesInContext:(NSManagedObjectContext *)context {
    return [Faculty findAllInContext:context];
}

+ (NSArray *)allFieldsInContext:(NSManagedObjectContext *)context {
    return [Field findAllInContext:context];
}

+ (NSArray *)allFloorsInContext:(NSManagedObjectContext *)context {
    return [Floor findAllInContext:context];
}

+ (NSArray *)allGroupsInContext:(NSManagedObjectContext *)context {
    return [Group findAllInContext:context];
}

+ (NSArray *)allLecturersInContext:(NSManagedObjectContext *)context {
    return [Lecturer findAllInContext:context];
}

+ (NSArray *)allLibrariesInContext:(NSManagedObjectContext *)context {
    return [Library findAllInContext:context];
}

+ (NSArray *)allLibraryResourcesInContext:(NSManagedObjectContext *)context {
    return [LibraryResource findAllInContext:context];
}

+ (NSArray *)allListsOfPresenceInContext:(NSManagedObjectContext *)context {
    return [ListOfPresence findAllInContext:context];
}

+ (NSArray *)allRoomsInContext:(NSManagedObjectContext *)context {
    return [Room findAllInContext:context];
}

+ (NSArray *)allSpecialtiesInContext:(NSManagedObjectContext *)context {
    return [Specialty findAllInContext:context];
}

+ (NSArray *)allStudentsInContext:(NSManagedObjectContext *)context {
    return [Student findAllInContext:context];
}

+ (NSArray *)allSubjectsInContext:(NSManagedObjectContext *)context {
    return [Subject findAllInContext:context];
}

+ (NSArray *)allUniversitiesInContext:(NSManagedObjectContext *)context {
    return [University findAllInContext:context];
}

+ (NSArray *)allUsersInContext:(NSManagedObjectContext *)context {
    return [User findAllInContext:context];
}

+ (NSArray *)allYearsOfStudiesInContext:(NSManagedObjectContext *)context {
    return [YearOfStudies findAllInContext:context];
}

+ (NSArray *)allModifiedBeaconProfilesInContext:(NSManagedObjectContext *)context {
    return [BeaconProfile findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedBeaconUUIDsInContext:(NSManagedObjectContext *)context {
    return [BeaconUUID findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedBlobsInContext:(NSManagedObjectContext *)context {
    return [Blob findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedBuildingsInContext:(NSManagedObjectContext *)context {
    return [Building findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedChairsInContext:(NSManagedObjectContext *)context {
    return [Chair findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedDatesInContext:(NSManagedObjectContext *)context {
    return [Date findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedFacultiesInContext:(NSManagedObjectContext *)context {
    return [Faculty findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedFieldsInContext:(NSManagedObjectContext *)context {
    return [Field findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedFloorsInContext:(NSManagedObjectContext *)context {
    return [Floor findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedGroupsInContext:(NSManagedObjectContext *)context {
    return [Group findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedLecturersInContext:(NSManagedObjectContext *)context {
    return [Lecturer findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedLibrariesInContext:(NSManagedObjectContext *)context {
    return [Library findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedLibraryResourcesInContext:(NSManagedObjectContext *)context {
    return [LibraryResource findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedListsOfPresenceInContext:(NSManagedObjectContext *)context {
    return [ListOfPresence findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedRoomsInContext:(NSManagedObjectContext *)context {
    return [Room findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedSpecialtiesInContext:(NSManagedObjectContext *)context {
    return [Specialty findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedStudentsInContext:(NSManagedObjectContext *)context {
    return [Student findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedSubjectsInContext:(NSManagedObjectContext *)context {
    return [Subject findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedUniversitiesInContext:(NSManagedObjectContext *)context {
    return [University findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedUsersInContext:(NSManagedObjectContext *)context {
    return [User findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allModifiedYearsOfStudiesInContext:(NSManagedObjectContext *)context {
    return [YearOfStudies findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_modified == YES"] inContext:context];
}

+ (NSArray *)allDeletedBeaconProfilesInContext:(NSManagedObjectContext *)context {
    return [BeaconProfile findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedBeaconUUIDsInContext:(NSManagedObjectContext *)context {
    return [BeaconUUID findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedBlobsInContext:(NSManagedObjectContext *)context {
    return [Blob findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedBuildingsInContext:(NSManagedObjectContext *)context {
    return [Building findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}
+ (NSArray *)allDeletedChairsInContext:(NSManagedObjectContext *)context {
    return [Chair findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedDatesInContext:(NSManagedObjectContext *)context {
    return [Date findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedFacultiesInContext:(NSManagedObjectContext *)context {
    return [Faculty findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedFieldsInContext:(NSManagedObjectContext *)context {
    return [Field findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedFloorsInContext:(NSManagedObjectContext *)context {
    return [Floor findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedGroupsInContext:(NSManagedObjectContext *)context {
    return [Group findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedLecturersInContext:(NSManagedObjectContext *)context {
    return [Lecturer findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedLibrariesInContext:(NSManagedObjectContext *)context {
    return [Library findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedLibraryResourcesInContext:(NSManagedObjectContext *)context {
    return [LibraryResource findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedListsOfPresenceInContext:(NSManagedObjectContext *)context {
    return [ListOfPresence findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedRoomsInContext:(NSManagedObjectContext *)context {
    return [Room findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedSpecialtiesInContext:(NSManagedObjectContext *)context {
    return [Specialty findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedStudentsInContext:(NSManagedObjectContext *)context {
    return [Student findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedSubjectsInContext:(NSManagedObjectContext *)context {
    return [Subject findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}
+ (NSArray *)allDeletedUniversitiesInContext:(NSManagedObjectContext *)context {
    return [University findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedUsersInContext:(NSManagedObjectContext *)context {
    return [YearOfStudies findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (NSArray *)allDeletedYearsOfStudiesInContext:(NSManagedObjectContext *)context {
    return [YearOfStudies findAllWithPredicate:[NSPredicate predicateWithFormat:@"db_deleted == YES"] inContext:context];
}

+ (void)deleteDatabaseInContext:(NSManagedObjectContext *)context {
    [University truncateAllInContext:context];
    [User truncateAllInContext:context];
    [BeaconUUID truncateAllInContext:context];
    [BeaconProfile truncateAllInContext:context];
    [LibraryResource truncateAllInContext:context];

/*
 //The following calls are not necessary, since in Model.xcdatamodel 'cascade' delete rule is set for aforementioned entities.
    [Blob truncateAll];
    [Building truncateAll];
    [Chair truncateAll];
    [Date truncateAll];
    [Faculty truncateAll];
    [Field truncateAll];
    [Floor truncateAll];
    [Group truncateAll];
    [Lecturer truncateAll];
    [Library truncateAll];
    [ListOfPresence truncateAll];
    [Room truncateAll];
    [Specialty truncateAll];
    [Student truncateAll];
    [Subject truncateAll];
    [YearOfStudies truncateAll];
    */
    [MPUtils saveToContext:context];
}

+ (void)deleteFilesInDocumentsDirectory {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (nil != error) {
        NSLog(@"%@",[error debugDescription]);
        error = nil;
    }
    for (NSString *fileName in files) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName] error:&error];
        if (nil != error) {
            NSLog(@"%@",[error debugDescription]);
            error = nil;
        }
    }
}

@end

@implementation NSObject(Description)

- (NSString *)customDescription {
    return [self description];
}

@end

@implementation NSSet(Description)

- (NSString *)customDescription {
    if (0 < self.count) {
        return @"Set of objects";
    } else {
        return @"Empty set";
    }
}

@end
