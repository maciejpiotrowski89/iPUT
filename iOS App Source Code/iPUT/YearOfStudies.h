//
//  YearOfStudies.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Field, Group;

@interface YearOfStudies : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * levelOfStudies;
@property (nonatomic, retain) NSNumber * semester;
@property (nonatomic, retain) NSDate * yearEnd;
@property (nonatomic, retain) NSDate * yearStart;
@property (nonatomic, retain) Field *field;
@property (nonatomic, retain) NSSet *groups;
@end

@interface YearOfStudies (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
