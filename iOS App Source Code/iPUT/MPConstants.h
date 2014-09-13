//
//  MPConstants.h
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>

//Beacons
extern NSString * const kEstimoteBeaconUUID;
extern NSString * const kiPUTPersonBeaconUUID;
extern NSString * const kiPUTBuildingBeaconUUID;

typedef NS_ENUM(NSUInteger, MPPersonType) {
    MPPersonTypeStudent = 512,
    MPPersonTypeLecturer = 1024
};

typedef NS_ENUM(NSUInteger, MPPersonalBeaconMajorType) {
    MPPersonalBeaconMajorTypeStudent = 1<<9,
    MPPersonalBeaconMajorTypeLecturer = 1<<10
};

typedef NS_ENUM(NSUInteger, MPDateTerm) {
    MPDateTermPast,
    MPDateTermPresent,
    MPDateTermFuture
};

typedef NS_ENUM(NSUInteger, MPBeaconProfileType) {
    MPBeaconProfileTypeStudent = 1<<9,
    MPBeaconProfileTypeLecturer = 1<<10,
    MPBeaconProfileTypeRoom = 1<<11
};

//Min StudentID Constraint
extern NSUInteger const kMinStudentIdNumber;
extern NSUInteger const kMaxLecturerIdNumber;

//Parse API
extern NSString * const kApplicationId;
extern NSString * const kClientKey;

//NSUserDefaults keys
extern NSString * const kDatabaseBootstrapped;

//Notification Names
extern NSString * const kDatabaseSavedNotificaiton;
extern NSString * const kDatabaseListSavedNotificaiton;
extern NSString * const kDatabaseEntitySavedNotificaiton;
extern NSString * const kDatabaseNewEntityChangedNotificaiton;

//Blob keys
extern NSString * const kDefaultStudentBlobName;
extern NSString * const kDefaultLecturerBlobName;
extern NSString * const kDefaultRoomBlobName;

//Entity names
extern NSString * const kUUIDEntityName;
extern NSString * const kUserEntityName;
extern NSString * const kLecturerEntityName;
extern NSString * const kStudentEntityName;
extern NSString * const kBeaconProfileEntityName;
extern NSString * const kBlobEntityName;
extern NSString * const kChairEntityName;
extern NSString * const kSpecialtyEntityName;
extern NSString * const kGroupEntityName;
extern NSString * const kYearEntityName;
extern NSString * const kFieldEntityName;
extern NSString * const kFacultyEntityName;
extern NSString * const kUniversityEntityName;
extern NSString * const kRoomEntityName;
extern NSString * const kFloorEntityName;
extern NSString * const kBuildingEntityName;
extern NSString * const kLibraryEntityName;
extern NSString * const kLibraryResourceEntityName;
extern NSString * const kDateEntityName;
extern NSString * const kListOfPresenceEntityName;
extern NSString * const kSubjectEntityName;

//Displayed Entity names
extern NSString * const kUUIDDisplayedEntityName;
extern NSString * const kUserDisplayedEntityName;
extern NSString * const kLecturerDisplayedEntityName;
extern NSString * const kStudentDisplayedEntityName;
extern NSString * const kBeaconProfileDisplayedEntityName;
extern NSString * const kBlobDisplayedEntityName;
extern NSString * const kChairDisplayedEntityName;
extern NSString * const kSpecialtyDisplayedEntityName;
extern NSString * const kGroupDisplayedEntityName;
extern NSString * const kYearDisplayedEntityName;
extern NSString * const kFieldDisplayedEntityName;
extern NSString * const kFacultyDisplayedEntityName;
extern NSString * const kUniversityDisplayedEntityName;
extern NSString * const kRoomDisplayedEntityName;
extern NSString * const kFloorDisplayedEntityName;
extern NSString * const kBuildingDisplayedEntityName;
extern NSString * const kLibraryResourceDisplayedEntityName;
extern NSString * const kDateDisplayedEntityName;
extern NSString * const kListOfPresenceDisplayedEntityName;
extern NSString * const kSubjectDisplayedEntityName;
extern NSString * const kLibraryDisplayedEntityName;

//Sync notifications
extern NSString * const kNotificationSyncStart;
extern NSString * const kNotificationSyncEnd;
extern NSString * const kNotificationSyncFail;
