//
//  Lecturer+Description.m
//  iPUT
//
//  Created by Paciej on 08/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "Lecturer+Description.h"

@implementation Lecturer (Description)

- (NSString *)description {
    NSString *degree = nil;
    if(nil != self.degree) {
        degree = [NSString stringWithFormat:@"%@ ", self.degree];
    }
    return [NSString stringWithFormat:@"%@%@ %@", degree, self.lastName, self.firstName];
}

@end
