//
//  MPPersonInformationViewController.h
//  iPUT
//
//  Created by Paciej on 23/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@interface MPPersonInformationViewController : MPBaseTableViewController

@property (nonatomic,strong) NSManagedObject *person;
@property (nonatomic) MPPersonType personType;

- (void)enableUserInteraction;
- (void)disableUserInteraction;

@end
