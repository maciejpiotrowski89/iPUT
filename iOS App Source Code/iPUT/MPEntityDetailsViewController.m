//
//  MPEntityDetailsViewController.m
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityDetailsViewController.h"

@implementation MPEntityDetailsViewController

#pragma mark - Initialization & Setup
- (void)setupController {
    [self initializeRowTitles];
    [self initializeRowValues];
    [self initializeNavigationItemTitle];
}

- (void)initializeRowTitles {
    self.rowTitles = [[[self.object entity] propertiesByName] allKeys];
}

- (void)initializeRowValues {
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.rowTitles.count];
    for (NSString *key in self.rowTitles) {
        [array addObject: [NSString stringWithFormat:@"%@",[self.object valueForKey:key]]];
    }
    self.rowValues = array;
}

- (void)initializeNavigationItemTitle {
    self.navigationItem.title = NSStringFromClass([self.object class]);
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

@end
