//
//  MPLibrarySubscriptionViewController.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityListViewController.h"

@class MPLibrarySubscriptionViewController;

@protocol MPLibrarySubscriptionViewControllerDelegate <NSObject>

@required
- (void)librarySubscriptionViewControllerDidCancel: (MPLibrarySubscriptionViewController *)vc;
- (void)librarySubscriptionViewController: (MPLibrarySubscriptionViewController *)vc didSelectLibraries: (NSSet *)libraries; //Libarary objects

@end

@interface MPLibrarySubscriptionViewController : MPEntityListViewController

@property (nonatomic,weak) id<MPLibrarySubscriptionViewControllerDelegate> delegate;
@property (nonatomic,strong) NSSet *selectedLibraries;

@end
