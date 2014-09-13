//
//  MPAdministrationMenuViewController.m
//  iPUT
//
//  Created by Paciej on 04/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPAdministrationMenuViewController.h"

@implementation MPAdministrationMenuViewController

- (void)initializeController {
    self.rowTitles = @[/*@"View Database",*/ @"Manage Database", @"Transmit iBeacon signal", @"Set context to iBeacon device"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:[self rowTitleForIndexPath:indexPath] sender:self];
}

@end
