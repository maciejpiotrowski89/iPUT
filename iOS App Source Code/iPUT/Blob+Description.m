//
//  Blob+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "Blob+Description.h"

@implementation Blob (Description)

- (NSString *)description {
    if (nil != self.student) {
        return [NSString stringWithFormat:@"%@ %@", self.student.lastName, self.student.firstName];
    }
    if (nil != self.lecturer) {
        return [NSString stringWithFormat:@"%@ %@", self.lecturer.lastName, self.lecturer.firstName];
    }
    if (nil != self.resource) {
        return [NSString stringWithFormat:@"%@, %@", self.resource.title, self.resource.author];
    }
    return @"";
}

@end
