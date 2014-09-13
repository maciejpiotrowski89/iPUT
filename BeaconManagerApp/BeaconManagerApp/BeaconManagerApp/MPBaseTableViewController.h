//
//  MPBaseTableViewController.h
//  iPUT
//
//  Created by Paciej on 24/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseViewController.h"

@interface MPBaseTableViewController : MPBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSArray *rowTitles; //strings to  be displayed in textLabel of cell
@property (nonatomic,strong) NSArray *rowValues; //strings to  be displayed in detailedTextLabel of cell
@property (nonatomic,strong) NSArray *objects; //vc-specific objects
@property (nonatomic,weak) IBOutlet UITableView *tableView; //vc-specific objects

- (BOOL)hasAnyRowData;
- (id)objectForCell:(UITableViewCell *)cell;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (id)objectForSelectedRow; //returns first element if subclass does not override - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; the default beahvior is to automatically deselect cell after user selects it
- (id)rowTitleForCell:(UITableViewCell *)cell;
- (id)rowTitleForIndexPath:(NSIndexPath *)indexPath;
- (id)rowTitleForSelectedRow; //returns first element if subclass does not override - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; the default beahvior is to automatically deselect cell after user selects it
- (id)rowValueForCell:(UITableViewCell *)cell;
- (id)rowValueForIndexPath:(NSIndexPath *)indexPath;
- (id)rowValueForSelectedRow;//returns first element if subclass does not override - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; the default beahvior is to automatically deselect cell after user selects it
- (NSString *)tableViewHeaderImageName;
@end
