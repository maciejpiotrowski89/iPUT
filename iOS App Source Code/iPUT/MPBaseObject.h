//
//  MPBaseObject.h
//  iPUT
//
//  Created by Paciej on 13/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPBaseObject : NSObject

- (void)initializeObject; //initialization of the class (called in init method). Not needed to call [super initializeObject] in subclasses

@end
