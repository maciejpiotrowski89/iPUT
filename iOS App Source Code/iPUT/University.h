//
//  University.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faculty;

@interface University : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *faculties;
@end

@interface University (CoreDataGeneratedAccessors)

- (void)addFacultiesObject:(Faculty *)value;
- (void)removeFacultiesObject:(Faculty *)value;
- (void)addFaculties:(NSSet *)values;
- (void)removeFaculties:(NSSet *)values;

@end
