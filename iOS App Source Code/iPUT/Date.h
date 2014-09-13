//
//  Date.h
//  iPUT
//
//  Created by Paciej on 23/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListOfPresence, Subject;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate * dateStart;
@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSDate * dateEnd;
@property (nonatomic, retain) ListOfPresence *list;
@property (nonatomic, retain) Subject *subject;

@end
