//
//  Building+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "Building+Description.h"

@implementation Building (Description)

- (NSString *)description {
    return self.name;//[NSString stringWithFormat:@"%@, %@", self.name, self.address];
}

@end
