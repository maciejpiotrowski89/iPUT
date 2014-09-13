//
//  ESTBeacon+Comparison.m
//  iPUT
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 13/09/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "ESTBeacon+Comparison.h"

@implementation ESTBeacon (Comparison)
- (BOOL)isEqual:(id)object {
    ESTBeacon *otherBeacon = object;
    return ([[self.proximityUUID UUIDString] isEqualToString:[otherBeacon.proximityUUID UUIDString]]) &&
    ([self.major isEqualToNumber:otherBeacon.major]) &&
    ([self.minor isEqualToNumber:otherBeacon.minor]);
}
@end
