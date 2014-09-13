//
//  MPLecturerTimeTableViewController.m
//  iPUT
//
//  Created by Paciej on 23/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPLecturerTimeTableViewController.h"

@implementation MPLecturerTimeTableViewController

#pragma mark - Table View

- (UIView *)accessoryViewForDateTerm:(MPDateTerm)dateTerm andList:(ListOfPresence *)list{
    switch (dateTerm) {
        case MPDateTermPast:
            return [MPUtils imageViewWithImageNamed:@"showList"];
        case MPDateTermPresent:
            return [MPUtils imageViewWithImageNamed:@"editList"];
        case MPDateTermFuture:
            return [MPUtils imageViewWithImageNamed:@"listLocked"];
    }
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"lecturerPresenceListSegue"]) {
        UIViewController *vc = (UIViewController *)segue.destinationViewController;
        ListOfPresence *list = [[self objectForCell:sender] valueForKey:@"list"];
        [vc setValue:list forKey:@"list"];
    }
}

@end
