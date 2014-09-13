//
//  MPEntityTypesViewController.m
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityTypesViewController.h"

@implementation MPEntityTypesViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    NSDictionary *mapping = @{kUUIDDisplayedEntityName : kUUIDEntityName,
                              kBeaconProfileDisplayedEntityName : kBeaconProfileEntityName,
                              kBlobDisplayedEntityName : kBlobEntityName,
                              kBuildingDisplayedEntityName : kBuildingEntityName,
                              kChairDisplayedEntityName : kChairEntityName,
                              kDateDisplayedEntityName : kDateEntityName,
                              kFacultyDisplayedEntityName : kFacultyEntityName,
                              kFieldDisplayedEntityName : kFieldEntityName,
                              kFloorDisplayedEntityName : kFloorEntityName,
                              kGroupDisplayedEntityName : kGroupEntityName,
                              kLecturerDisplayedEntityName : kLecturerEntityName,
                              kLibraryDisplayedEntityName : kLibraryEntityName,
                              kLibraryResourceDisplayedEntityName : kLibraryResourceEntityName,
                              kListOfPresenceDisplayedEntityName : kListOfPresenceEntityName,
                              kRoomDisplayedEntityName : kRoomEntityName,
                              kSpecialtyDisplayedEntityName : kSpecialtyEntityName,
                              kStudentDisplayedEntityName : kStudentEntityName,
                              kSubjectDisplayedEntityName : kSubjectEntityName,
                              kUniversityDisplayedEntityName : kUniversityEntityName,
                              kUserDisplayedEntityName : kUserEntityName,
                              kYearDisplayedEntityName : kYearEntityName};
    self.rowTitles = [[mapping allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.rowTitles.count];
    for (NSString *string in self.rowTitles) {
        [array addObject:[mapping objectForKey:string]];
    }
    self.objects = array;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"entityListSegue"]) {
        UIViewController *vc = (UIViewController *)segue.destinationViewController;
        [vc setValue:[self objectForCell:sender] forKey:@"className"];
        [vc setValue:[self rowTitleForCell:sender] forKey:@"displayedClassName"];
    }
}

@end
