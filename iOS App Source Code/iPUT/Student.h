//
//  Student.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconProfile, Blob, Group, Library, ListOfPresence, Specialty, User;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) NSSet *subscribedLibraries;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Specialty *specialtyOfStudies;
@property (nonatomic, retain) Blob *photo;
@property (nonatomic, retain) NSSet *listsOfPresence;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) BeaconProfile *beacon;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addSubscribedLibrariesObject:(Library *)value;
- (void)removeSubscribedLibrariesObject:(Library *)value;
- (void)addSubscribedLibraries:(NSSet *)values;
- (void)removeSubscribedLibraries:(NSSet *)values;

- (void)addListsOfPresenceObject:(ListOfPresence *)value;
- (void)removeListsOfPresenceObject:(ListOfPresence *)value;
- (void)addListsOfPresence:(NSSet *)values;
- (void)removeListsOfPresence:(NSSet *)values;

@end
