//
//  Room.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconProfile, Floor, Lecturer;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BeaconProfile *beacon;
@property (nonatomic, retain) Floor *floor;
@property (nonatomic, retain) Lecturer *lecturer;

@end
