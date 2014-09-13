//
//  MPStudentFinder.m
//  iPUT
//
//  Created by Paciej on 24/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPStudentFinder.h"

@interface MPStudentFinder()

@property (nonatomic,strong) MPStudentBeaconFinder *finder;

@end

@implementation MPStudentFinder

- (void)initializeObject {
    [super initializeObject];
    [self setupStudentBeaconFinder];
}

- (void)setupStudentBeaconFinder {
    self.finder = [MPStudentBeaconFinder new];
    self.finder.delegate = self;
}

- (void)discoverStudentsProximity {
    [self.finder discoverStudentBeaconsInProximity];
}

#pragma mark - MPiBeaconFinderDelegate

- (void)iBeaconFinderDidStartRangingBeacons {
    if ([self.delegate respondsToSelector:@selector(studentFinderDidStartSearchingStudents)]) {
        [self.delegate studentFinderDidStartSearchingStudents];
    }    
}

- (void)iBeaconFinderDidFailRangingBeacons:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"There was a problem ..." message:[error localizedDescription]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    if ([self.delegate respondsToSelector:@selector(studentFinderDidFailFindingStudents:)]) {
        [self.delegate studentFinderDidFailFindingStudents:error];
    }
}

- (void)iBeaconFinderDidFindBeacons:(NSArray *)beacons {
    NSArray *students = [self studentsForBeacons:beacons];
    if ([self.delegate respondsToSelector:@selector(studentFinderDidFindStudents:)]) {
        [self.delegate studentFinderDidFindStudents:students];
    }
}

- (NSArray *)studentsForBeacons:(NSArray *)beacons {
    NSMutableArray *students = nil;
    if(0 != beacons.count) {
        students = [NSMutableArray new];
        for (ESTBeacon *beacon in beacons) {
            if ([MPUtils beaconIsInProximity:beacon.proximity]) {
                BeaconProfile *profile = [MPUtils beaconProfileForESTBeacon:beacon];
                if (nil != profile && nil != profile.student) {
                    [students addObject:profile.student];
                }
            }
        }
    }
    return students;
}

- (void)iBeaconFinderDidStopRangingBeacons {
    if ([self.delegate respondsToSelector:@selector(studentFinderDidStopSearchingStudents)]) {
        [self.delegate studentFinderDidStopSearchingStudents];
    }
}

@end
