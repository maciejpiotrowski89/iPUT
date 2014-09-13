//
//  MPBaseViewController.h
//  iPUT
//
//  Created by Paciej on 24/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseProtocols.h"

typedef NS_ENUM(NSInteger, HelpViewType) {
    HelpViewTypeOverlay = 0, //default
    HelpViewTypeAlert
};

@interface MPBaseViewController : UIViewController <MPModalControllerDelegateProtocol>

@property (nonatomic) BOOL shouldSetupLoadingIndicatorAtSetup;//default - NO, set to YES if loading indicator is used
- (IBAction)rightNavigationBarButtonPressed:(id)sender; //vc-specific actions to be performed when right nav button is pressed
- (IBAction)leftNavigationBarButtonPressed:(id)sender; //vc-specific actions to be performed when right nav button is pressed
- (NSString *)helpOverlayPictureName;
- (NSString *)helpMessage;
- (IBAction)MP_showMenu;
- (IBAction)MP_showHelp;
- (HelpViewType)helpType;
- (void)initializeController; //called in init* method; no need to call super in subclass
- (void)setupController; //called in viewDidLoad; no need to call super in subclass
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;
- (void)modalControllerDidCancel;
- (void)dismissModalViewController;

//subclass to perform custom logic on sync notifications
- (void)synchronizationFailed:(NSNotification *)notification;
- (void)synchronizationEnded:(NSNotification *)notification;
- (void)synchronizationStarted:(NSNotification *)notification;

@end
