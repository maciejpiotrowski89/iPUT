//
//  MPEntityDetailsViewController.h
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@interface MPEntityDetailsViewController : MPBaseTableViewController

@property (nonatomic,strong) NSManagedObject *object;
- (void)initializeNavigationItemTitle;

@end
