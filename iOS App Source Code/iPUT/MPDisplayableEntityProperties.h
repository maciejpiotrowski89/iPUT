//
//  MPDisplayableEntityProperties.h
//  iPUT
//
//  Created by Paciej on 17/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"

@interface MPDisplayableEntityProperties : MPBaseObject

//Keys
@property (nonatomic,strong) NSArray *properties;
@property (nonatomic,strong) NSArray *sets;
@property (nonatomic,strong) NSArray *setsAcceptableObjectTypes;
@property (nonatomic,strong) NSArray *objects;
//Displayable Names
@property (nonatomic,strong) NSArray *propertiesNames;
@property (nonatomic,strong) NSArray *setsNames;
@property (nonatomic,strong) NSArray *objectsNames;

@end
