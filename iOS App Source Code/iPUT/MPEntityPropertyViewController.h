//
//  MPEntityPropertyViewController.h
//  iPUT
//
//  Created by Paciej on 23/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPManageDatabaseProtocols.h"

@interface MPEntityPropertyViewController : MPBaseViewController

@property (strong,nonatomic) NSString *className;
@property (nonatomic,strong) NSString *propertyName;
@property (nonatomic,strong) NSString *propertyDisplayedName;
@property (nonatomic,strong) id propertyValue;
@property (nonatomic,weak) id<MPEditPropertyControllerDelegateProtocol> delegate;

@end
