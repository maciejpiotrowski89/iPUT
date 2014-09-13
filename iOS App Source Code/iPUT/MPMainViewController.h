//
//  MPSelectedMenuItemViewController.h
//  iPUT
//
//  Created by Paciej on 04/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPMenuViewController.h"

@interface MPMainViewController : MPBaseViewController <MPMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (nonatomic, strong) UIViewController *contentViewController;

- (void)showMenu;
- (void)hideMenu;

@end
