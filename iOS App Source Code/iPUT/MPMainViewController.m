 //
//  MPSelectedMenuItemViewController.m
//  iPUT
//
//  Created by Paciej on 04/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPMainViewController.h"

NSInteger kHiddenMenuConstraintConstant = 0;
NSInteger kRevealedMenuLeadingConstraintConstant = 200;
NSInteger kRevealedMenuTrailingConstraintConstant = -200;

@interface MPMainViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingContentViewConstraint;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *hideTapGestureRecognizer;

@end

@implementation MPMainViewController

#pragma mark - Initialization & Setup

- (void)setupController {
    [self performSegueWithIdentifier:@"Profile" sender:self];
}

#pragma mark - Instance methods

- (void)showMenu {
    self.leadingContentViewConstraint.constant = kRevealedMenuLeadingConstraintConstant;
    self.trailingContentViewConstraint.constant = kRevealedMenuTrailingConstraintConstant;
    [self animateContentContainerMovement];
    self.hideTapGestureRecognizer.enabled = YES;
}

- (void)hideMenu {
    self.leadingContentViewConstraint.constant = kHiddenMenuConstraintConstant;
    self.trailingContentViewConstraint.constant = kHiddenMenuConstraintConstant;
    [self animateContentContainerMovement];
    self.hideTapGestureRecognizer.enabled = NO;
}

- (void)animateContentContainerMovement {
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)hideTapRecognized:(UITapGestureRecognizer *)gestureRecognizer {
    [self hideMenu];
}

#pragma mark - MPMenuViewControllerDelegate

- (void)menuViewControllerDidSelectMenuItem:(NSString *)item  {
    [self performSegueWithIdentifier:item sender:self];
    [self hideMenu];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedMenuSegue"]) {
        UIViewController *vc = (UIViewController *)segue.destinationViewController;
        [vc setValue:self forKey:@"delegate"];
    }
}

@end
