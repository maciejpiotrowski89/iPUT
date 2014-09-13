//
//  MPMenuViewController.m
//  iPUT
//
//  Created by Paciej on 04/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPMenuViewController.h"

typedef NS_ENUM(NSUInteger, MPMenuItem) {
    MPMenuItemElectronicId,
    MPMenuItemLibrary,
    MPMenuItemListOfPresence,
    MPMenuItemSettings,
    MPMenuItemAdministration,
    MPMenuItemCount
};

@implementation MPMenuViewController

- (void)initializeController {
    [self initializeRowTitles];
}

- (void)initializeRowTitles { //row title is storyboard  identifier
    NSMutableArray *array = [@[@"Profile",
                               @"Classes",
                               @"Library",
                               @"Settings"] mutableCopy];
 
    if (YES == [[[PFUser currentUser]objectForKey:@"isAdmin"]boolValue]) {
        [array addObject:@"Administration"];
    }
    self.rowTitles = array;
}

- (void)setupController {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(menuViewControllerDidSelectMenuItem:)]) {
        NSString *item = [self rowTitleForIndexPath:indexPath];
        [self.delegate menuViewControllerDidSelectMenuItem:item];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

@end
