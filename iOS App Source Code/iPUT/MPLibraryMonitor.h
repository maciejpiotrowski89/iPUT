//
//  MPLibraryMonitor.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"

@protocol MPLibraryMonitorDelegate <NSObject>

@required
- (void)currentLibrariesChanged:(NSSet *)libraries;

@end

@interface MPLibraryMonitor : MPBaseObject

@property (nonatomic,weak) id <MPLibraryMonitorDelegate> delegate;

- (void)startMonitoringLibrariesForCurrentUser;
- (void)stopMonitoringLibrariesForCurrentUser;
- (void)reinitialize;

@end
