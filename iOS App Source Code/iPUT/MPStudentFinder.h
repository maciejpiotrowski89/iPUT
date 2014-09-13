//
//  MPStudentFinder.h
//  iPUT
//
//  Created by Paciej on 24/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import "MPStudentBeaconFinder.h"

@protocol MPStudentFinderDelegate <NSObject>

@required
- (void)studentFinderDidFindStudents:(NSArray *)studnets;

@optional
- (void)studentFinderDidFailFindingStudents:(NSError *)error;
- (void)studentFinderDidStartSearchingStudents;
- (void)studentFinderDidStopSearchingStudents;

@end

@interface MPStudentFinder : MPBaseObject <MPiBeaconFinderDelegate>

@property (nonatomic,weak) id <MPStudentFinderDelegate> delegate;

- (void)discoverStudentsProximity;

@end
