//
//  MPTimetableViewController.h
//  iPUT
//
//  Created by Paciej on 23/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@interface MPTimetableViewController : MPBaseTableViewController

@property (nonatomic,strong) Subject *subject;
@property (nonatomic,strong) NSArray *dateTerms;
@property (nonatomic,strong) NSManagedObject *person;
@property (nonatomic) MPPersonType personType;

- (UIView *)accessoryViewForDateTerm:(MPDateTerm)dateTerm andList:(ListOfPresence *)list;

@end
