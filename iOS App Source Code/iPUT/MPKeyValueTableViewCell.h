//
//  MPKeyValueTableViewCell.h
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPKeyValueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
