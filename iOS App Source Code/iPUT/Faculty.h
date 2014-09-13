//
//  Faculty.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chair, Field, University;

@interface Faculty : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *chairs;
@property (nonatomic, retain) NSSet *fields;
@property (nonatomic, retain) University *university;
@end

@interface Faculty (CoreDataGeneratedAccessors)

- (void)addChairsObject:(Chair *)value;
- (void)removeChairsObject:(Chair *)value;
- (void)addChairs:(NSSet *)values;
- (void)removeChairs:(NSSet *)values;

- (void)addFieldsObject:(Field *)value;
- (void)removeFieldsObject:(Field *)value;
- (void)addFields:(NSSet *)values;
- (void)removeFields:(NSSet *)values;

@end
