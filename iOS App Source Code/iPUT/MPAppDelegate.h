//
//  MPAppDelegate.h
//  iPUT
//
//  Created by Maciej Piotrowski on 05/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MPMainViewController.h"

@interface MPAppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) MPMainViewController *mainViewController;

- (void)showMenu;
- (void)hideMenu;

@end
