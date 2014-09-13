//
//  Blob.h
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lecturer, LibraryResource, Student;

@interface Blob : NSManagedObject

@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) Lecturer *lecturer;
@property (nonatomic, retain) LibraryResource *resource;
@property (nonatomic, retain) Student *student;

@end
