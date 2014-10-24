//
//  MPLoadingView.m
//  iPUT
//
//  Created by Paciej on 02/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPLoadingView.h"

@interface MPLoadingView()

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIView *roundedBackground;

@end

@implementation MPLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    self.backgroundColor = [UIColor clearColor];
    self.roundedBackground = [[UIView alloc] initWithFrame:self.bounds];
    self.roundedBackground.alpha = 0.7;
    self.roundedBackground.backgroundColor = [UIColor grayColor];
    self.roundedBackground.layer.cornerRadius = 10.0;
    self.roundedBackground.layer.masksToBounds = YES;
    self.roundedBackground.layer.borderWidth = 0.0;
    self.roundedBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.roundedBackground];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityIndicator startAnimating];
    [self addSubview:self.activityIndicator];
}

- (void)updateConstraints {
    [super updateConstraints];
    UIView *roundedBackground = self.roundedBackground;
    NSArray *roundedBackgroundH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[roundedBackground]|" options:NSLayoutFormatAlignAllCenterX & NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(roundedBackground)];
    NSArray *roundedBackgroundV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[roundedBackground]|" options:NSLayoutFormatAlignAllCenterX & NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(roundedBackground)];
    [self.roundedBackground.superview addConstraints:roundedBackgroundH];
    [self.roundedBackground.superview addConstraints:roundedBackgroundV];
    
    NSLayoutConstraint *activityIndicatorConstraintX = [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *activityIndicatorConstraintY = [NSLayoutConstraint constraintWithItem:self.activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.activityIndicator.superview addConstraints:@[activityIndicatorConstraintX, activityIndicatorConstraintY]];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
