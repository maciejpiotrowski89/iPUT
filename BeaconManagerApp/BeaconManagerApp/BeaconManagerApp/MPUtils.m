//
//  MPUtils.m
//  BeaconManagerApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 08/09/14.
//  Copyright (c) 2014 Roche Polska Sp. z o.o. All rights reserved.
//

#import "MPUtils.h"

@implementation MPUtils

//display alerts
+ (UIAlertView *)displayErrorAlertViewForMessage:(NSString *)message {
    UIAlertView *alertView = nil;
    if (message != nil && ![message isEqualToString:@""]) {
        alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    return alertView;
}

+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message {
    UIAlertView *alertView = nil;
    if (message != nil && ![message isEqualToString:@""]) {
        alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    return alertView;
}

+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message andDelegate: (id<UIAlertViewDelegate>)delegate{
    UIAlertView *alertView = nil;
    if (message != nil && ![message isEqualToString:@""] && [delegate conformsToProtocol:@protocol(UIAlertViewDelegate)]) {
        alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK", nil];
        alertView.delegate = delegate;
        [alertView show];
    }
    return alertView;
}

//handling nil descriptions
+ (NSString *)stringValueForObject:(id)object {
    NSString *value = [object description];
    if ([value isEqualToString:@"(null)"] || nil == value || [value isEqualToString:@""]) {
        value = @"None";
    }
    return value;
}

//beacon context
+ (NSString *)contextForESTBeacon:(ESTBeacon *)beacon {
    
    NSString *uuid = [beacon.proximityUUID UUIDString];
    NSUInteger major = [beacon.major unsignedIntegerValue];
    NSUInteger minor = [beacon.minor unsignedIntegerValue];
    
    if ([uuid isEqualToString:[kEstimoteUUID UUIDString]]) {
        return @"Estimote Beacon";
    } else if ([uuid isEqualToString:[kBeaconADMDUUID UUIDString]] && major == kBeaconPlaceMajorNumber) {
        if (minor == kBeaconRegistrationMinorNumber) {
            return @"Registration Beacon";
        } else {
            return[NSString stringWithFormat:@"Speed Dating %zd", minor];
        }
    }
    return @"Unkown Beacon";
}

+ (NSArray *)contexts {
    static NSArray *contexts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contexts = @[
                     @"Registration BEACON",
                     @"Speed Dating 1 BEACON",
                     @"Speed Dating 2 BEACON",
                     @"Speed Dating 3 BEACON",
                     @"Speed Dating 4 BEACON",
                     @"Speed Dating 5 BEACON",
                     @"Speed Dating 6 BEACON",
                     @"Speed Dating 7 BEACON",
                     @"Speed Dating 8 BEACON"
                     ];
    });
    return contexts;
}

+ (NSDictionary *)contextNumbersForContextAtIndex: (NSUInteger)index {
    return @{
                kContextNumbersProximityUUID : [kBeaconADMDUUID UUIDString],
                kContextNumbersMajor : [NSNumber numberWithUnsignedInteger: kBeaconPlaceMajorNumber],
                kContextNumbersMinor : [NSNumber numberWithUnsignedInteger: index]
             };
}

@end
