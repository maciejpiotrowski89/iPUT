//
//  Subject.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date, Group, Lecturer;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Lecturer *lecturer;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addDatesObject:(Date *)value;
- (void)removeDatesObject:(Date *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;

@end
