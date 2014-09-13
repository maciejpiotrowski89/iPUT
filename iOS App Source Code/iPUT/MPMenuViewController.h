//
//  MPMenuViewController.h
//  iPUT
//
//  Created by Paciej on 04/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"

@class MPMenuViewController;

@protocol MPMenuViewControllerDelegate <NSObject>

- (void)menuViewControllerDidSelectMenuItem:(NSString *)item;

@end

@interface MPMenuViewController : MPBaseTableViewController

@property (nonatomic, weak) id <MPMenuViewControllerDelegate>delegate;

@end
