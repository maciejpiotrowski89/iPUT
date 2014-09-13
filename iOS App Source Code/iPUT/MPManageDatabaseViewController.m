//
//  MPManageDatabaseViewController.m
//  iPUT
//
//  Created by Paciej on 17/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPManageDatabaseViewController.h"

@implementation MPManageDatabaseViewController

- (void)initializeController {
    self.rowTitles = @[kBuildingDisplayedEntityName, kFacultyDisplayedEntityName, kUserDisplayedEntityName];
    self.objects = @[kBuildingEntityName, kFacultyEntityName, kUserEntityName];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"entityListSegue"]) {
        UIViewController *vc = (UIViewController *)segue.destinationViewController;
        NSString *className = [self objectForCell:sender];
        [vc setValue:className forKey:@"className"];
        [vc setValue:[self rowTitleForCell:sender] forKey:@"displayedClassName"];
        if ([className isEqualToString:@"Faculty"] || [className isEqualToString:@"User"]) {
            [vc setValue:@NO forKey:@"isAddButtonEnabled"];
        }
    }
}

@end
