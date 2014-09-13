//
//  MPMySubjectsViewController.m
//  iPUT
//
//  Created by Paciej on 23/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPMySubjectsViewController.h"

NSString *const kStudentTimetableSegueIdentifier = @"studentTimetableSegue";
NSString *const kLecturerTimetableSegueIdentifier = @"lecturerTimetableSegue";

@implementation MPMySubjectsViewController

- (void)initializeController {
    User *currentUser = [MPUtils currentUser];
    self.personType = [MPUtils personTypeForUser:currentUser];
    self.objects = [MPUtils subjectsForUser:currentUser];
    self.rowTitles = self.objects;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *segueIdentifier = nil;
    switch (self.personType) {
        case MPPersonTypeStudent:
            segueIdentifier = kStudentTimetableSegueIdentifier;
            break;
        case MPPersonTypeLecturer:
            segueIdentifier = kLecturerTimetableSegueIdentifier;
            break;
    }
    [self performSegueWithIdentifier:segueIdentifier sender:indexPath];
}



- (NSString *)tableViewHeaderImageName {
    return @"class";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [vc setValue:[self objectForIndexPath:sender] forKey:@"subject"];
}

@end
