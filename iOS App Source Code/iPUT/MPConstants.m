//
//  MPConstants.m
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPConstants.h"

NSString * const kEstimoteBeaconUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
NSString * const kiPUTPersonBeaconUUID = @"601E7E88-BE6E-4F9C-AADD-438BB38B5C31";
NSString * const kiPUTBuildingBeaconUUID = @"DF257517-138B-4FBA-8FA1-74D7191E52A8";

//Min StudentID Constraint
NSUInteger const kMinStudentIdNumber = 65536;
NSUInteger const kMaxLecturerIdNumber = 65535;

//Parse API
NSString * const kApplicationId = @"ypBmdhuOqRkYNW5o2UbRlz8YW78gRfx0H8uxmHZp";
NSString * const kClientKey = @"owmVY4SBji6fQstIHHk0T1MFNUvKSzmrhiWLCIq9";

//NSUserDefaults keys
NSString * const kDatabaseBootstrapped = @"WasDatabaseAlreadyBootstrapped";

//Notification Name
NSString * const kDatabaseSavedNotificaiton = @"DatabaseListSavedNotificaiton";
NSString * const kDatabaseListSavedNotificaiton = @"DatabaseListSavedNotificaiton";
NSString * const kDatabaseEntitySavedNotificaiton = @"DatabaseEntitySavedNotificaiton";
NSString * const kDatabaseNewEntityChangedNotificaiton = @"DatabaseNewEntityChangedNotificaiton";

//Blob keys
NSString * const kDefaultStudentBlobName = @"Default Student Picture";
NSString * const kDefaultLecturerBlobName = @"Default Lecturer Picture";
NSString * const kDefaultRoomBlobName = @"Default Room Picture";

//Entity names
NSString * const kUUIDEntityName = @"BeaconUUID";
NSString * const kBeaconProfileEntityName = @"BeaconProfile";
NSString * const kBlobEntityName = @"Blob";
NSString * const kBuildingEntityName = @"Building";
NSString * const kChairEntityName = @"Chair";
NSString * const kDateEntityName = @"Date";
NSString * const kFacultyEntityName = @"Faculty";
NSString * const kFieldEntityName = @"Field";
NSString * const kFloorEntityName = @"Floor";
NSString * const kGroupEntityName = @"Group";
NSString * const kLecturerEntityName = @"Lecturer";
NSString * const kLibraryEntityName = @"Library";
NSString * const kLibraryResourceEntityName = @"LibraryResource";
NSString * const kListOfPresenceEntityName = @"ListOfPresence";
NSString * const kRoomEntityName = @"Room";
NSString * const kSpecialtyEntityName = @"Specialty";
NSString * const kStudentEntityName = @"Student";
NSString * const kSubjectEntityName = @"Subject";
NSString * const kUniversityEntityName = @"University";
NSString * const kUserEntityName = @"User";
NSString * const kYearEntityName = @"YearOfStudies";

//Displayed Entity names
NSString * const kUUIDDisplayedEntityName = @"UUIDs";
NSString * const kUserDisplayedEntityName = @"Users";
NSString * const kLecturerDisplayedEntityName = @"Lecturers";
NSString * const kStudentDisplayedEntityName = @"Students";
NSString * const kBeaconProfileDisplayedEntityName = @"Beacon Profiles";
NSString * const kBlobDisplayedEntityName = @"Blobs";
NSString * const kChairDisplayedEntityName = @"Chairs";
NSString * const kSpecialtyDisplayedEntityName = @"Specialties";
NSString * const kGroupDisplayedEntityName = @"Groups";
NSString * const kYearDisplayedEntityName = @"Years";
NSString * const kFieldDisplayedEntityName = @"Fields";
NSString * const kFacultyDisplayedEntityName = @"Faculties";
NSString * const kUniversityDisplayedEntityName = @"Universities";
NSString * const kRoomDisplayedEntityName = @"Rooms";
NSString * const kFloorDisplayedEntityName = @"Floors";
NSString * const kBuildingDisplayedEntityName = @"Buildings";
NSString * const kLibraryResourceDisplayedEntityName = @"Books";
NSString * const kDateDisplayedEntityName = @"Class Dates";
NSString * const kListOfPresenceDisplayedEntityName = @"Presence Lists";
NSString * const kSubjectDisplayedEntityName = @"Subjects";
NSString * const kLibraryDisplayedEntityName = @"Libraries";

//Sync notifications
NSString * const kNotificationSyncStart = @"SynchronizationStart";
NSString * const kNotificationSyncEnd = @"SynchronizationEnd";
NSString * const kNotificationSyncFail = @"SynchronizationFail";
