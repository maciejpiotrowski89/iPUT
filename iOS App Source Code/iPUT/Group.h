//
//  Group.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, Subject, YearOfStudies;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NSSet *subjects;
@property (nonatomic, retain) YearOfStudies *yearOfStudies;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

- (void)addSubjectsObject:(Subject *)value;
- (void)removeSubjectsObject:(Subject *)value;
- (void)addSubjects:(NSSet *)values;
- (void)removeSubjects:(NSSet *)values;

@end
