//
//  MPPersonInformationViewController.m
//  iPUT
//
//  Created by Paciej on 23/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPPersonInformationViewController.h"
#import "MPVisitCardTableViewCell.h"
#import "MPKeyValueTableViewCell.h"

@interface MPPersonInformationViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MPPersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPerson];
    [self setupRowTitles];
    [self setupRowValues];
}

- (void)setupPerson {
    self.personType = [MPUtils personTypeForPerson:self.person];
}

- (void)setupRowTitles {
    switch (self.personType) {
        case MPPersonTypeStudent:
            self.rowTitles = @[@"firstName lastName", @"ID", @"Field", @"Level", @"Degree", @"Group", @"Semester", @"Specialty"];
            break;
        case MPPersonTypeLecturer:
            self.rowTitles = @[@"firstName, lastName", @"ID", @"Chair", @"Degree"];
            break;
    }
}

- (void)setupRowValues {
    switch (self.personType) {
        case MPPersonTypeStudent:
            self.rowValues = @[@"firstName, lastName", @"studentID", @"group.yearOfStudies.field.name", @"group.yearOfStudies.levelOfStudies", @"degree", @"group.name", @"group.yearOfStudies.semester", @"specialtyOfStudies"];
            break;
        case MPPersonTypeLecturer:
            self.rowValues = @[@"firstName, lastName", @"lecturerID", @"chair.name", @"degree"];
            break;
    }
}

#pragma mark - User Interaction

- (void)enableUserInteraction {
    self.tableView.userInteractionEnabled = YES;
}

- (void)disableUserInteraction {
    if ([self hasAnyRowData]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    self.tableView.userInteractionEnabled = NO;
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 160.0;
    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *infoCellIdentifier = @"infoCell";
    static NSString *headerCellIdentifier = @"headerCell";
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = (row == 0)? headerCellIdentifier : infoCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = (row == 0)? [[MPVisitCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] : [[MPKeyValueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (row == 0) {
        ((MPVisitCardTableViewCell*)cell).mainTextLabel.text = [NSString stringWithFormat:@"%@ %@",[self.person valueForKeyPath:@"firstName"], [self.person valueForKeyPath:@"lastName"]];
        ((MPVisitCardTableViewCell*)cell).subTextLabel.text = NSStringFromClass([self.person class]);
        ((MPVisitCardTableViewCell*)cell).photoView.image = [UIImage imageNamed:@"Glamour.JPG"];
    } else {
        ((MPKeyValueTableViewCell*)cell).keyLabel.text = [self.rowTitles objectAtIndex:row];
        NSString *value = [NSString stringWithFormat:@"%@",[self.person valueForKeyPath:[self.rowValues objectAtIndex:row]]];
        if ([value isEqualToString:@"(null)"]) {
            value = @"None";
        }
        ((MPKeyValueTableViewCell*)cell).valueLabel.text = value;
    }
    return cell;
}

@end
