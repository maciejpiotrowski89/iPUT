//
//  MPBeaconView.m
//  iPUT
//
//  Created by Paciej on 23/03/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBeaconView.h"
#import "PulsingHaloLayer.h"

@interface MPBeaconView()
@property (nonatomic, strong) PulsingHaloLayer *pulsingLayer;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end

@implementation MPBeaconView

- (void)setupPulsingLayer {
    self.pulsingLayer = [PulsingHaloLayer layer];
    self.pulsingLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    self.pulsingLayer.radius = 100.0;
    [self.layer insertSublayer:self.pulsingLayer below:self.imageView.layer];
}

- (void)trashPulsingLayer {
    [self.pulsingLayer removeFromSuperlayer];
    self.pulsingLayer = nil;
}

@end
