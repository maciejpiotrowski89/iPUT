//
//  Room+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "Room+Description.h"

@implementation Room (Description)

- (NSString *)description {
    NSString *name = nil;
    if(nil != self.name) {
        name = [NSString stringWithFormat:@", %@", self.name];
    }
    return [NSString stringWithFormat:@"Room %@%@", self.number, name];
}

@end
