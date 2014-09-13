//
//  LibraryResource+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "LibraryResource+Description.h"

@implementation LibraryResource (Description)

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@", self.title, self.author];
}

@end
