//
//  Field.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faculty, YearOfStudies;

@interface Field : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Faculty *faculty;
@property (nonatomic, retain) NSSet *yearsOfStudies;
@end

@interface Field (CoreDataGeneratedAccessors)

- (void)addYearsOfStudiesObject:(YearOfStudies *)value;
- (void)removeYearsOfStudiesObject:(YearOfStudies *)value;
- (void)addYearsOfStudies:(NSSet *)values;
- (void)removeYearsOfStudies:(NSSet *)values;

@end
