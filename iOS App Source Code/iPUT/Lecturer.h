//
//  Lecturer.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconProfile, Blob, Chair, Library, Room, Subject, User;

@interface Lecturer : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * lecturerID;
@property (nonatomic, retain) BeaconProfile *beacon;
@property (nonatomic, retain) Chair *chair;
@property (nonatomic, retain) Chair *headOfChair;
@property (nonatomic, retain) Blob *photo;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *subjects;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *subscribedLibraries;
@end

@interface Lecturer (CoreDataGeneratedAccessors)

- (void)addSubjectsObject:(Subject *)value;
- (void)removeSubjectsObject:(Subject *)value;
- (void)addSubjects:(NSSet *)values;
- (void)removeSubjects:(NSSet *)values;

- (void)addSubscribedLibrariesObject:(Library *)value;
- (void)removeSubscribedLibrariesObject:(Library *)value;
- (void)addSubscribedLibraries:(NSSet *)values;
- (void)removeSubscribedLibraries:(NSSet *)values;

@end
