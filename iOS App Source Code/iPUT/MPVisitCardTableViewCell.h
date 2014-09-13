//
//  MPVisitCardTableViewCell.h
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPVisitCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end
