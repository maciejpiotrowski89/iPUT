//
//  BeaconUUID.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Building, User;

@interface BeaconUUID : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * uuidString;
@property (nonatomic, retain) NSSet *building;
@property (nonatomic, retain) NSSet *user;
@end

@interface BeaconUUID (CoreDataGeneratedAccessors)

- (void)addBuildingObject:(Building *)value;
- (void)removeBuildingObject:(Building *)value;
- (void)addBuilding:(NSSet *)values;
- (void)removeBuilding:(NSSet *)values;

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
