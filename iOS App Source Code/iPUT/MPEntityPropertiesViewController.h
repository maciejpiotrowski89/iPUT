//
//  MPEntityPropertiesViewController.h
//  iPUT
//
//  Created by Paciej on 17/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPEntityDetailsViewController.h"
#import "MPManageDatabaseProtocols.h"

@interface MPEntityPropertiesViewController : MPEntityDetailsViewController <MPEditPropertyControllerDelegateProtocol, MPSelectEntityControllerDelegateProtocol>

@property (nonatomic,weak) id<MPCreateNewEntityControllerDelegateProtocol>delegate;
@property (nonatomic,strong) NSManagedObject *parentEntity;
@property (nonatomic,strong) NSString *className;
@property (nonatomic) BOOL isCreatingNewEntity;

@end
