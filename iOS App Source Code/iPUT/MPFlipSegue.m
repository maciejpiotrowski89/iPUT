//
//  MPFlipSegue.m
//  iPUT
//
//  Created by Paciej on 24/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPFlipSegue.h"
#import "MPAppDelegate.h"

@implementation MPFlipSegue

- (void) perform {
    MPAppDelegate *delegate = (MPAppDelegate *)([UIApplication sharedApplication].delegate);
    UIWindow *window = delegate.window;
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [window insertSubview:dst.view aboveSubview:src.view];
    
    [UIView transitionWithView:window duration:0.4
                       options:[self animationType]
                    animations:^{
                        
                    }
                    completion:^(BOOL finished) {
                        [src.view removeFromSuperview];
                        delegate.window.rootViewController = dst;
                        if ([dst isKindOfClass:[MPMainViewController class]]) {
                            delegate.mainViewController = (MPMainViewController *) dst;
                        }
                    }];
}

- (UIViewAnimationOptions) animationType {
    return UIViewAnimationOptionTransitionCurlUp;
}

@end
