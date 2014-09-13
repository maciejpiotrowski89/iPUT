//
//  MPVisitCardTableViewCell.m
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPVisitCardTableViewCell.h"

@implementation MPVisitCardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupPhotoView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupPhotoView];
}

- (void)setupPhotoView {
    [MPUtils setCircularShapeForView:self.photoView];
    
}

@end
