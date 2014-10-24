//
//  MPBaseViewController.m
//  iPUT
//
//  Created by Paciej on 24/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPLoadingView.h"

@interface MPBaseViewController()

@property (nonatomic,strong) UIImageView *helpOverlay;
@property (nonatomic,strong) MPLoadingView *loadingView;

@end

@implementation MPBaseViewController

#pragma mark - Initializaiton & Setup

- (instancetype)init {
    self = [super init];
    if (self) {
        [self superclassInitializeController];
        [self initializeController];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self superclassInitializeController];
        [self initializeController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self superclassInitializeController];
        [self initializeController];
    }
    return self;
}

- (void)superclassInitializeController {
    self.shouldSetupLoadingIndicatorAtSetup = NO;
    self.navigationItem.backBarButtonItem = [UIBarButtonItem new];
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)initializeController {
    //implemented by subclass
}

- (void)superclassSetup {
//    [self MP_setupHelpButton];
//    [self MP_setupMenuButton];
    [self MP_setupTableView];
    [self MP_setupHelpOverlay];
    [self MP_setupLoadingIndicator];
    [self MP_setupObservingNotifications];
}

- (void)setupController {
    //implemented by subclass
}

- (void)MP_setupMenuButton {
    NSMutableArray * buttons = [self.navigationItem.leftBarButtonItems mutableCopy];
    if (nil == buttons) {
        buttons = [[NSMutableArray alloc]initWithCapacity:1];
    }
    [buttons addObject:[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(MP_showMenu)]];
    self.navigationItem.leftBarButtonItems = buttons;
}

- (void)MP_setupHelpButton {
    NSMutableArray * buttons = [self.navigationItem.rightBarButtonItems mutableCopy];
    if (nil == buttons) {
        buttons = [[NSMutableArray alloc]initWithCapacity:1];
    }
    [buttons addObject:[[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(MP_showHelp)]];
    self.navigationItem.leftBarButtonItems = buttons;
}

- (void)MP_setupTableView {
    //implemented by subclass
}

- (void)MP_setupHelpOverlay {
    if (![[self helpOverlayPictureName]isEqualToString:@""] && nil != [self helpOverlayPictureName]) {
        self.helpOverlay = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self helpOverlayPictureName]]];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpOverlayPictureTapped:)];
        [self.helpOverlay addGestureRecognizer:tapRecognizer];
    }
}

- (void)MP_setupLoadingIndicator {
    if (YES == self.shouldSetupLoadingIndicatorAtSetup) {
        self.loadingView = [[MPLoadingView alloc]initWithFrame:CGRectZero];
        self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        self.loadingView.alpha = 0.0f;
        [self.view addSubview:self.loadingView];
    }
}

- (void)MP_setupObservingNotifications {
   /* [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(synchronizationFailed:) name:kNotificationSyncFail object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(synchronizationEnded:) name:kNotificationSyncEnd object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(synchronizationStarted:) name:kNotificationSyncStart object:nil];
    */
}

- (void)synchronizationFailed:(NSNotification *)notification {
    NSLog(@"Sync failed");
    [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:NO];
}

- (void)synchronizationEnded:(NSNotification *)notification {
    NSLog(@"Sync ended");
    [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:NO];
}

- (void)synchronizationStarted:(NSNotification *)notification {
    NSLog(@"Sync started");
    [self performSelectorOnMainThread:@selector(showLoadingIndicator) withObject:nil waitUntilDone:NO];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self superclassSetup];
    [self setupController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Instance methods

- (NSString *)helpOverlayPictureName {
    return @"";
}

- (NSString *)helpMessage {
    return @"";
}

- (void)helpOverlayPictureTapped:(UITapGestureRecognizer *)recognizer {
    [recognizer.view removeFromSuperview];
}

- (void)MP_showHelp {
    switch ([self helpType]) {
        case HelpViewTypeOverlay: {
            [self.view addSubview:self.helpOverlay];
        }
            break;
        case HelpViewTypeAlert: {
        }
            break;
    }
}

- (IBAction)MP_showMenu {
}

- (IBAction)MP_hideMenu {
}

- (HelpViewType)helpType {
    return HelpViewTypeOverlay;
}

- (IBAction)rightNavigationBarButtonPressed:(id)sender {
    
}

- (IBAction)leftNavigationBarButtonPressed:(id)sender {
    
}

- (void)showLoadingIndicator {
    if (YES == self.shouldSetupLoadingIndicatorAtSetup) {
        [self.view setUserInteractionEnabled:NO];
        [self.loadingView setNeedsDisplay];
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.10];
		self.loadingView.alpha = 1.0f;
		[UIView commitAnimations];
    } else {
        NSLog(@"Loading indicator was not set up during initialization - shouldSetupLoadingIndicatorAtSetup set to NO.");
    }
}

- (void)hideLoadingIndicator {
    if (YES == self.shouldSetupLoadingIndicatorAtSetup) {
        [self.loadingView setNeedsDisplay];
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.10];
		self.loadingView.alpha = 0.0f;
		[UIView commitAnimations];
        [self.view setUserInteractionEnabled:YES];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (YES == self.shouldSetupLoadingIndicatorAtSetup) {
        
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.loadingView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.loadingView.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    UIView *loadingView = self.loadingView;
    NSArray *width = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[loadingView(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingView)];
    NSArray *height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadingView(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingView)];
        
    [self.loadingView.superview addConstraints:@[centerX,centerY]];
    [self.loadingView.superview addConstraints:width];
    [self.loadingView.superview addConstraints:height];
    }
}

#pragma mark - MPModalControllerDelegateProtocol

- (void)modalControllerDidCancel {
    [self dismissModalViewController];
}

- (void)dismissModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
