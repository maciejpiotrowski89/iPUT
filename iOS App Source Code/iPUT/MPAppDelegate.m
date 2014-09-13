//
//  MPAppDelegate.m
//  iPUT
//
//  Created by Maciej Piotrowski on 05/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPAppDelegate.h"
#import "MPDatabaseBootstrapper.h"
#import "MPLoginViewController.h"
#import "MPSynchronizationFacade.h"

@implementation MPAppDelegate

#pragma mark - App Delegate methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model"];

    [Parse setApplicationId:kApplicationId clientKey:kClientKey];
    [Parse offlineMessagesEnabled:YES];
    [Parse errorMessagesEnabled:YES];
    if (nil != [PFUser currentUser]) {
        
        NSString *storyboardName =  ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )? @"Main_iPhone" : @"Main_iPad";
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        
        id vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainStoryboardViewController"];
        self.mainViewController = vc;
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showMenu {
    [self.mainViewController showMenu];
}

- (void)hideMenu {
    [self.mainViewController hideMenu];
}

#pragma mark - Parse Login Delegate Methods
- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    SEL performLogin = @selector(performLoginSegue);
    if ([controller respondsToSelector:performLogin]) {
        [(MPLoginViewController *)controller performLoginSegue];
    }
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationIsPortrait(UIInterfaceOrientationMaskPortrait|| UIInterfaceOrientationMaskPortraitUpsideDown);
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationIsPortrait(UIInterfaceOrientationPortrait|| UIInterfaceOrientationPortraitUpsideDown);
    
}

@end
