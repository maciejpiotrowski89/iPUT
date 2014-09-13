//
//  User.m
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "User.h"
#import "BeaconUUID.h"
#import "Lecturer.h"
#import "Student.h"


@implementation User

@dynamic db_deleted;
@dynamic db_description;
@dynamic db_id;
@dynamic db_modified;
@dynamic isAdmin;
@dynamic username;
@dynamic password;
@dynamic beaconUUID;
@dynamic lecturer;
@dynamic student;

@end
