//
//  MPEntityListViewController.h
//  iPUT
//
//  Created by Paciej on 07/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseTableViewController.h"
#import "MPManageDatabaseProtocols.h"

@interface MPEntityListViewController : MPBaseTableViewController <MPCreateNewEntityControllerDelegateProtocol, UIAlertViewDelegate>

@property (strong,nonatomic) NSString *className;
@property (strong,nonatomic) NSString *displayedClassName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic) BOOL isAddButtonEnabled;
@property (weak,nonatomic) id <MPSelectEntityControllerDelegateProtocol> delegate;
@property (nonatomic,strong) NSString *propertyName;
@property (nonatomic, strong) id propertyValue;
@property (nonatomic, strong) id parentEntity;
@end
