//
//  MPBadgeViewController.m
//  iPUT
//
//  Created by Maciej Piotrowski on 16/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBadgeViewController.h"
#import "MPBadgeInformationViewController.h"
#import "MPBadgeController.h"
#import "MPBeaconView.h"

CGFloat const badgeAtNormalPositionConstant = 0.0;
CGFloat const badgeAtHiddenPositionConstant = 700;
CGFloat const badgeCollapsedHeight = 160.0;
CGFloat const badgeExpandedHeight = 356.0;
CGFloat const beaconAtNormalPositionConstant = 0.0;
CGFloat const beaconAtHiddenPositionConstant = -700;

@interface MPBadgeViewController() <MPBadgeControllerDelegate, UIAlertViewDelegate>

#pragma mark - Controllers
@property (nonatomic, strong) MPBadgeController *badgeController;
@property (nonatomic, weak) MPBadgeInformationViewController *badgeInformationViewController;

#pragma  mark - Recognizers
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *beaconSwipeRecognizer;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *badgeSwipeRecognizer;

#pragma mark - Views
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UIView *badgeBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeVerticalPositionConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeHeightConstraint;

@property (weak, nonatomic) IBOutlet MPBeaconView *beaconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beaconVerticalPositionConstraint;

@property (nonatomic,strong) NSTimer *shakeTimer;
@property (nonatomic,strong) AnimationBlock animations;
@end

@implementation MPBadgeViewController

#pragma mark - Initialization & Setup

- (void)initializeController {
    [self initializeBeaconProfile];
}

- (void)setupController {
    [self setupBadgeController];
    [self setupBadgeCard];
    [self setupBeaconCard];
}

- (void)initializeBeaconProfile {
    if (nil == self.beaconProfile) {
        self.beaconProfile = [MPUtils beaconProfileForCurrentUser];
    }
}

- (void)setupBadgeController {
    self.badgeController = [MPBadgeController new];
    self.badgeController.delegate = self;
    [self.badgeController setBeaconProfile:self.beaconProfile];
}

- (void)setupBadgeCard {
    [MPUtils setCornerRadius:10.0 forView:self.badgeView];
    [MPUtils setCornerRadius:10.0 forView:self.badgeBackgroundView];
    
    [self setupShakeForView:self.badgeView withConstraint:self.badgeVerticalPositionConstraint];
}

- (void)setupBeaconCard {
    [MPUtils setCornerRadius:10.0 forView:self.beaconView];
}

#pragma mark - Instance methods

- (IBAction)expand:(UIButton *)sender {
    static BOOL expand = YES;
    if (expand) {
        [self cancelShakeAnimation];
        self.badgeHeightConstraint.constant = badgeExpandedHeight;
        [self.badgeInformationViewController enableUserInteraction];
    } else {
        [self.badgeInformationViewController disableUserInteraction];
        self.badgeHeightConstraint.constant = badgeCollapsedHeight;
    }
    expand = !expand; //toggle for next invokation of method;
    [self.badgeSwipeRecognizer setEnabled:expand]; //if epxanding the view, disable recognizer
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)badgeSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    [self moveBadgeToPosition:badgeAtHiddenPositionConstant];
    [self.badgeController startEmittingBeaconIdentifier];
}

- (IBAction)beaconSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    [self moveBeaconToPosition:beaconAtHiddenPositionConstant];
    [self.badgeController stopEmittingBeaconIdentifier];
}

#pragma mark - Animations

- (void)moveBadgeToPosition:(CGFloat)constant {
    [self cancelShakeAnimation];
    self.badgeVerticalPositionConstraint.constant = constant;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (constant == badgeAtHiddenPositionConstant) {
            [self moveBeaconToPosition:beaconAtNormalPositionConstant];
            self.navigationItem.title = @"Swipe down to stop sending";
        }
    }];
}

- (void)moveBeaconToPosition:(CGFloat)constant {
    [self cancelShakeAnimation];
    self.beaconVerticalPositionConstraint.constant = constant;
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (constant == beaconAtHiddenPositionConstant) {
            [self.beaconView trashPulsingLayer];
            [self moveBadgeToPosition:badgeAtNormalPositionConstant];
            self.navigationItem.title = @"Swipe up to start sending";
        }
        else if (constant == beaconAtNormalPositionConstant) {
            [self setupShakeForView:self.beaconView withConstraint:self.beaconVerticalPositionConstraint];
        }
    }];
}

- (void)setupShakeForView:(UIView *)view withConstraint:(NSLayoutConstraint *)constraint{
    [self.shakeTimer invalidate];
    self.animations = [MPUtils createShakeAnimationForView:view withConstraint:constraint];
    self.shakeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

- (void)timerFired:(NSTimer *)timer {
    self.animations();
}

- (void)cancelShakeAnimation {
    [self.shakeTimer invalidate];
}

#pragma mark - MPBadgeControllerDelegate

- (void)badgeControllerDidStartEmittingBeaconIdentifier {
    //show pulsing view
    [self.beaconView setupPulsingLayer];
}

- (void)badgeControllerDidFailEmittingBeaconIdentifier:(NSError *)error {
    //hide pulsing view
    [self.beaconView trashPulsingLayer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Something went wrong ..." message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)badgeControllerDidStopEmittingBeaconIdentifier {
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self moveBeaconToPosition:beaconAtHiddenPositionConstant];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedPersonalInformationInContainer"]) {
        self.badgeInformationViewController = segue.destinationViewController;
        self.badgeInformationViewController.beaconProfile = self.beaconProfile;
    }
}

@end
