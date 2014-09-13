//
//  LibraryResource.h
//  iPUT
//
//  Created by Paciej on 27/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Blob, Library;

@interface LibraryResource : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * db_deleted;
@property (nonatomic, retain) NSString * db_description;
@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSNumber * db_modified;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Blob *blob;
@property (nonatomic, retain) NSSet *libraries;
@end

@interface LibraryResource (CoreDataGeneratedAccessors)

- (void)addLibrariesObject:(Library *)value;
- (void)removeLibrariesObject:(Library *)value;
- (void)addLibraries:(NSSet *)values;
- (void)removeLibraries:(NSSet *)values;

@end
