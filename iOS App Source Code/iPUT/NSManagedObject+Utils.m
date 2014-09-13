//
//  NSManagedObject+Utils.m
//  iPUT
//
//  Created by Paciej on 28/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "NSManagedObject+Utils.h"
#import <objc/runtime.h>

@implementation NSManagedObject (Utils)
-(Class)classOfPropertyNamed:(NSString*) propertyName
{
    // Get Class of property to be populated.
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0)
    {
        // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

@end
