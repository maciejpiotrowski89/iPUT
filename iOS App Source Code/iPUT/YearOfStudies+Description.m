//
//  YearOfStudies+Description.m
//  iPUT
//
//  Created by Paciej on 22/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "YearOfStudies+Description.h"

@implementation YearOfStudies (Description)

- (NSString *)description {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *start = [dateFormatter stringFromDate:self.yearStart];
    NSString *end = [dateFormatter stringFromDate:self.yearEnd];
    return [NSString stringWithFormat:@"%@ - %@", start, end];
}

@end
