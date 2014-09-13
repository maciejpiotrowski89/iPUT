//
//  MPBeaconProfile+Description.m
//  iPUT
//
//  Created by Paciej on 08/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "BeaconProfile+Description.h"

@implementation BeaconProfile (Description)

- (NSString *)description {
    if (nil != self.student) {
        return [NSString stringWithFormat:@"%@ %@", self.student.lastName, self.student.firstName];
    }
    if (nil != self.lecturer) {
        return [NSString stringWithFormat:@"%@ %@", self.lecturer.lastName, self.lecturer.firstName];
    }
    if (nil != self.room) {
        return [NSString stringWithFormat:@"%@, floor %@, room %@", self.room.floor.building.name, self.room.floor.number, self.room.number];
    }
    return @"";
}

@end
