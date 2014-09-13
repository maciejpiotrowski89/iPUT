//
//  MPUtils.h
//  iPUT
//
//  Created by Paciej on 22/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EstimoteSDK/ESTBeacon.h>
#import <EstimoteSDK/ESTBeaconRegion.h>

typedef void (^AnimationBlock)(void);

@interface MPUtils : NSObject

//uiview
+ (UIImageView *)imageViewWithImageNamed:(NSString *)name;
+ (void)setCircularShapeForView:(UIView*)view;
+ (void)setCornerRadius:(CGFloat)radius forView:(UIView*)view;
+ (AnimationBlock)createShakeAnimationForView:(UIView*)view withConstraint: (NSLayoutConstraint *)constraint;

//handling nil descriptions
+ (NSString *)stringValueForObject:(id)object;

//display alerts
+ (UIAlertView *)displayErrorAlertViewForMessage:(NSString *)message;
+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message;
+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message andDelegate: (id<UIAlertViewDelegate>)delegate;

//iBeacons
+ (NSString *)iBeaconTypeForESTBeacon:(ESTBeacon *)beacon;
+ (BeaconProfile *)beaconProfileForESTBeacon:(ESTBeacon *)beacon;
+ (NSString *)beaconProfileDescriptionForBeaconProfile:(BeaconProfile *)beaconProfile;
+ (BeaconProfile *)beaconProfileForCurrentUser;
+ (BOOL)beaconIsInProximity:(CLProximity)proximity;
+ (MPBeaconProfileType)beaconProfileTypeForProfile:(BeaconProfile *)beaconProfile;
+ (NSString *)beaconProfileTypeNameForBeaconProfileType:(MPBeaconProfileType)beaconProfileType;
+ (NSManagedObject *)objectForBeaconProfile:(BeaconProfile *)beaconProfile;
+ (UIImage *)imageForBeaconProfileObject:(NSManagedObject *)beaconProfileObject beaconProfileType:(MPBeaconProfileType)beaconProfileType;
+ (ESTBeaconRegion *)beaconRegionForBeaconProfile:(BeaconProfile *)beaconProfile;
+ (Library *)libraryForBeaconRegion:(BeaconProfile *)profile;
+ (BeaconProfile *)beaconProfileForBeaconRegion:(ESTBeaconRegion *)region;

//User
+ (User *)currentUser;
+ (NSManagedObject *)personForCurrentUser;
+ (NSManagedObject *)personForUser:(User *)user;
+ (NSArray *)subjectsForCurrentUser;
+ (NSArray *)subjectsForUser:(User *)user;
+ (MPPersonType)personTypeForUser:(User *)user;
+ (MPPersonType)personTypeForPerson:(NSManagedObject *)person;
+ (BeaconUUID *)beaconUUIDForPerson;
+ (MPDateTerm)dateTermForDate:(Date *)date;
+ (NSSet *)subscribedLibrariesForCurrentUser;
+ (void)subscribeLibrariesForCurrentUser:(NSSet *)libraries withCompletionBlock:(MRSaveCompletionHandler)completion;

//Students
+ (NSArray *)listOfAllStudentsForPresenceList:(ListOfPresence *)list;
+ (void)addStudent:(Student *)student toList:(ListOfPresence *)list;
+ (void)addStudents:(NSSet *)students toList:(ListOfPresence *)list;
+ (void)removeStudent:(Student *)student fromList:(ListOfPresence *)list;
+ (BOOL)student:(Student *)student presentOnTheList:(ListOfPresence *)list;

//Room
+ (BeaconUUID *)beaconUUIDForRoom;

//Core Data
+ (void)saveToContext:(NSManagedObjectContext *)context;
+ (void)saveContext;
+ (void)saveContextWithCompletionBlock:(MRSaveCompletionHandler)completion;
+ (BOOL)isStudentIDUnique:(NSNumber *)identifier;
+ (BOOL)isStudentIDValid:(NSNumber *)identifier;
+ (BOOL)isLecturerIDUnique:(NSNumber *)identifier;
+ (BOOL)isLecturerIDValid:(NSNumber *)identifier;
+ (BOOL)isBuildingMajorUnique:(NSNumber *)identifier;
+ (BOOL)isFloorNumber:(Floor *)floor uniqueInBuilding:(Building *)building;
+ (BOOL)isRoomNumber:(Room *)room uniqueAtFloor:(Floor *)floor;
+ (BOOL)isUserValid:(User *)user;
+ (NSManagedObject *)createManagedObjectForClassName:(NSString *)name;
+ (BeaconProfile *)createBeaconProfileForRoom:(Room *)room;
+ (BeaconProfile *)createBeaconProfileForLecturer:(Lecturer *)lecturer;
+ (BeaconProfile *)createBeaconProfileForStudent:(Student *)student;
+ (BeaconProfile *)updateBeaconProfile:(BeaconProfile*)beacon forRoom:(Room *)room;
+ (BeaconProfile *)updateBeaconProfile:(BeaconProfile*)beacon forLecturer:(Lecturer *)lecturer;
+ (BeaconProfile *)updateBeaconProfile:(BeaconProfile*)beacon forStudent:(Student *)student;
+ (void)updateBeaconProfilesForBuilding:(Building *)building;
+ (User *)createUser;
+ (void)removeDatabaseNode:(NSManagedObject *)object;

+ (NSArray *)allBeaconProfilesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allBeaconUUIDsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allBlobsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allBuildingsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allChairsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDatesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allFacultiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allFieldsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allFloorsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allGroupsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allLecturersInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allLibrariesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allLibraryResourcesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allListsOfPresenceInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allRoomsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allSpecialtiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allStudentsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allSubjectsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allUniversitiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allUsersInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allYearsOfStudiesInContext:(NSManagedObjectContext *)context;

+ (NSArray *)allModifiedBeaconProfilesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedBeaconUUIDsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedBlobsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedBuildingsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedChairsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedDatesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedFacultiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedFieldsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedFloorsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedGroupsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedLecturersInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedLibrariesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedLibraryResourcesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedListsOfPresenceInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedRoomsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedSpecialtiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedStudentsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedSubjectsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedUniversitiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedUsersInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allModifiedYearsOfStudiesInContext:(NSManagedObjectContext *)context;

+ (NSArray *)allDeletedBeaconProfilesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedBeaconUUIDsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedBlobsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedBuildingsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedChairsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedDatesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedFacultiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedFieldsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedFloorsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedGroupsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedLecturersInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedLibrariesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedLibraryResourcesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedListsOfPresenceInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedRoomsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedSpecialtiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedStudentsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedSubjectsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedUniversitiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedUsersInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allDeletedYearsOfStudiesInContext:(NSManagedObjectContext *)context;

+ (void)deleteDatabaseInContext:(NSManagedObjectContext *)context;
+ (void)deleteFilesInDocumentsDirectory;

@end

@interface NSObject(Description)

- (NSString *)customDescription;

@end

@interface NSSet(Description)

- (NSString *)customDescription;

@end
