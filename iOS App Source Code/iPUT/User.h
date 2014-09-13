//
//  User.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconUUID, Lecturer, Student;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSNumber * isAdmin;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) BeaconUUID *beaconUUID;
@property (nonatomic, retain) Lecturer *lecturer;
@property (nonatomic, retain) Student *student;

@end
