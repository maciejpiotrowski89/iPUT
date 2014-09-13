//
//  MPBaseObject.m
//  iPUT
//
//  Created by Paciej on 13/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"

@implementation MPBaseObject

#pragma mark - Initializaiton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeObject];
    }
    return self;
}

- (void)initializeObject {
    
}

@end
