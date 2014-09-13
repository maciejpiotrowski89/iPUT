//
//  MPDatabaseBootstrapper.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPDatabaseBootstrapper : NSObject
+ (instancetype)sharedInstance;
- (void)bootstrapDatabase;
@end
