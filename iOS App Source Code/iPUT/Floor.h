//
//  Floor.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Building, Room;

@interface Floor : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) Building *building;
@property (nonatomic, retain) NSSet *rooms;
@end

@interface Floor (CoreDataGeneratedAccessors)

- (void)addRoomsObject:(Room *)value;
- (void)removeRoomsObject:(Room *)value;
- (void)addRooms:(NSSet *)values;
- (void)removeRooms:(NSSet *)values;

@end
