//
//  MPUtils.h
//  BeaconManagerApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 08/09/14.
//  Copyright (c) 2014 Roche Polska Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EstimoteSDK/ESTBeacon.h>

@interface MPUtils : NSObject

//display alerts
+ (UIAlertView *)displayErrorAlertViewForMessage:(NSString *)message;
+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message;
+ (UIAlertView *)displayAlertViewForMessage:(NSString *)message andDelegate: (id<UIAlertViewDelegate>)delegate;

//handling nil descriptions
+ (NSString *)stringValueForObject:(id)object;

//beacon context

+ (NSString *)contextForESTBeacon:(ESTBeacon *)beacon;
+ (NSArray *)contexts;
+ (NSDictionary *)contextNumbersForContextAtIndex: (NSUInteger)index ;

@end
