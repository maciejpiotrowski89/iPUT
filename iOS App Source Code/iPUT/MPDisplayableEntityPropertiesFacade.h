//
//  MPDisplayableEntityPropertiesFacade.h
//  iPUT
//
//  Created by Paciej on 17/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import "MPDisplayableEntityProperties.h"

@interface MPDisplayableEntityPropertiesFacade : MPBaseObject

+ (MPDisplayableEntityProperties *)propertiesForClassName: (NSString *)className;

@end
