//
//  NSManagedObject+Utils.h
//  iPUT
//
//  Created by Paciej on 28/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Utils)
-(Class)classOfPropertyNamed:(NSString*) propertyName;
@end
