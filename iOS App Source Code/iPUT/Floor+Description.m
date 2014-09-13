//
//  Floor+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "Floor+Description.h"

@implementation Floor (Description)

- (NSString *)description {
    return [NSString stringWithFormat:@"Floor %@", self.number];
}

@end
