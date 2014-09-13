//
//  ListOfPresence.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date, Student;

@interface ListOfPresence : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) Date *date;
@property (nonatomic, retain) NSSet *presentStudents;
@end

@interface ListOfPresence (CoreDataGeneratedAccessors)

- (void)addPresentStudentsObject:(Student *)value;
- (void)removePresentStudentsObject:(Student *)value;
- (void)addPresentStudents:(NSSet *)values;
- (void)removePresentStudents:(NSSet *)values;

@end
