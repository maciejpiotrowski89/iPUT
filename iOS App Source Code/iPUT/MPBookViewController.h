//
//  MPBookViewController.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseViewController.h"

@interface MPBookViewController : MPBaseViewController

@property (nonatomic,strong) Blob *book;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
