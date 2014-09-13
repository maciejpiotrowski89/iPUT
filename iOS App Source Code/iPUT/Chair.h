//
//  Chair.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faculty, Lecturer, Specialty;

@interface Chair : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Faculty *faculty;
@property (nonatomic, retain) Lecturer *head;
@property (nonatomic, retain) NSSet *lecturers;
@property (nonatomic, retain) NSSet *specialties;
@end

@interface Chair (CoreDataGeneratedAccessors)

- (void)addLecturersObject:(Lecturer *)value;
- (void)removeLecturersObject:(Lecturer *)value;
- (void)addLecturers:(NSSet *)values;
- (void)removeLecturers:(NSSet *)values;

- (void)addSpecialtiesObject:(Specialty *)value;
- (void)removeSpecialtiesObject:(Specialty *)value;
- (void)addSpecialties:(NSSet *)values;
- (void)removeSpecialties:(NSSet *)values;

@end
