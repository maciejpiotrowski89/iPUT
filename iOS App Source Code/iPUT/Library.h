//
//  Library.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Room.h"

@class Lecturer, LibraryResource, Student;

@interface Library : Room

@property (nonatomic, retain) NSSet *resources;
@property (nonatomic, retain) NSSet *subscribedLecturers;
@property (nonatomic, retain) NSSet *subscribedStudents;
@end

@interface Library (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(LibraryResource *)value;
- (void)removeResourcesObject:(LibraryResource *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

- (void)addSubscribedLecturersObject:(Lecturer *)value;
- (void)removeSubscribedLecturersObject:(Lecturer *)value;
- (void)addSubscribedLecturers:(NSSet *)values;
- (void)removeSubscribedLecturers:(NSSet *)values;

- (void)addSubscribedStudentsObject:(Student *)value;
- (void)removeSubscribedStudentsObject:(Student *)value;
- (void)addSubscribedStudents:(NSSet *)values;
- (void)removeSubscribedStudents:(NSSet *)values;

@end
