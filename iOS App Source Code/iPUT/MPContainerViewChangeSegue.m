//
//  MPContainerViewChangeSegue.m
//  iPUT
//
//  Created by Paciej on 04/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPContainerViewChangeSegue.h"
#import "MPMainViewController.h"

@implementation MPContainerViewChangeSegue
- (void) perform {
    
    MPMainViewController *src = (MPMainViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
  
    [src addChildViewController:dst];
    [src.contentViewController willMoveToParentViewController:nil];
    

    [UIView animateWithDuration:0.25 delay:0.0 options:0 animations:^{
        src.contentViewController.view.alpha = 0.0;
        [src.contentContainer addSubview:dst.view];
    } completion:^(BOOL finished) {
        [src.contentViewController.view removeFromSuperview];
        [src.contentViewController removeFromParentViewController];
        [dst didMoveToParentViewController:src];
        src.contentViewController = dst;
    }];
    
    //    [src transitionFromViewController:src.contentViewController toViewController:dst duration:0.25 options:0 animations:nil completion:^(BOOL finished) {
    //        [src.contentViewController removeFromParentViewController];
    //        [dst didMoveToParentViewController:src];
    //        src.contentViewController = dst;
    //    }];
}

@end
