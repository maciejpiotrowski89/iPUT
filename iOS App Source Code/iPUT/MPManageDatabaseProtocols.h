//
//  MPManageDatabaseProtocols.h
//  iPUT
//
//  Created by Paciej on 25/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPBaseProtocols.h"

@protocol MPEditPropertyControllerDelegateProtocol <MPModalControllerDelegateProtocol>

- (void)editPropertyControllerDidRequestSaveObject:(id)object forPropertyName:(NSString *)name;

@end

@protocol MPSelectEntityControllerDelegateProtocol <MPModalControllerDelegateProtocol>

- (void)selectEntityControllerDidRequestSaveObject:(id)object forPropertyName:(NSString *)name;

@end

@protocol MPCreateNewEntityControllerDelegateProtocol <MPModalControllerDelegateProtocol>

- (void)createNewEntityControllerDidRequestSaveObject:(id)object forClassName:(NSString *)name;

@end

