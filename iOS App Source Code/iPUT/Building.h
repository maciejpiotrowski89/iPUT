//
//  Building.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconUUID, Floor;

@interface Building : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BeaconUUID *beaconUUID;
@property (nonatomic, retain) NSSet *floors;
@end

@interface Building (CoreDataGeneratedAccessors)

- (void)addFloorsObject:(Floor *)value;
- (void)removeFloorsObject:(Floor *)value;
- (void)addFloors:(NSSet *)values;
- (void)removeFloors:(NSSet *)values;

@end
