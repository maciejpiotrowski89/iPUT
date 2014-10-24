//
//  MPBaseTableViewController.m
//  iPUT
//
//  Created by Paciej on 24/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@implementation MPBaseTableViewController

#pragma mark - Initializaiton & Setup

- (void)MP_setupTableView { // called by super
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
}

#pragma mark - Instance methods

- (BOOL)hasAnyRowData {
    return self.rowTitles.count;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (![[self tableViewHeaderImageName] isEqualToString:@""]) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            return 300.0;

        } else return 150.0;
    }
    return 0.0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 1.0;
//}

- (NSString *)tableViewHeaderImageName {
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[self.rowTitles objectAtIndex:row] description];
    if (self.rowValues.count) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.rowValues objectAtIndex:row] ];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *name = [self tableViewHeaderImageName];
    if (![name isEqualToString:@""]) {
        return [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor lightGrayColor];
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (id)objectForCell:(UITableViewCell *)cell {
    return [self objectForIndexPath:[self.tableView indexPathForCell:cell]];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    return [self.objects objectAtIndex:indexPath.row];
}
      
- (id)objectForSelectedRow {
    return [self objectForIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (id)rowTitleForCell:(UITableViewCell *)cell {
    return [self rowTitleForIndexPath:[self.tableView indexPathForCell:cell]];
}

- (id)rowTitleForIndexPath:(NSIndexPath *)indexPath {
    return [self.rowTitles objectAtIndex:indexPath.row];
}

- (id)rowTitleForSelectedRow {
    return [self rowTitleForIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (id)rowValueForCell:(UITableViewCell *)cell {
    return [self rowValueForIndexPath:[self.tableView indexPathForCell:cell]];
}

- (id)rowValueForIndexPath:(NSIndexPath *)indexPath {
    return [self.rowValues objectAtIndex:indexPath.row];
}

- (id)rowValueForSelectedRow {
    return [self rowValueForIndexPath:[self.tableView indexPathForSelectedRow]];
}

@end
