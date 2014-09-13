//
//  Date+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "Date+Description.h"

@implementation Date (Description)

- (NSString *)description {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:self.dateStart];
}

@end
