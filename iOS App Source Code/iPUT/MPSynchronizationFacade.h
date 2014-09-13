//
//  MPSynchronizationFacade.h
//  iPUT
//
//  Created by Paciej on 24/07/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPBaseObject.h"
#import <Parse/PFConstants.h>

@interface MPSynchronizationFacade : MPBaseObject

+ (instancetype)sharedInstance;

- (void)loginUser:(NSString *)user password:(NSString *)password;

- (BOOL)fetchEntireDatabase;
- (BOOL)fetchPersonData;

- (BOOL)fetchListOfLibraries;
- (BOOL)fetchResourcesWithoutLibraries;
- (BOOL)fetchBlobFileForBlob:(Blob *)blob;
- (BOOL)fetchPresenceInfoForStudent:(Student *)student;

- (BOOL)upsertListOfPresence:(ListOfPresence *)list;

- (void)synchronizeDatabaseModifications;
- (void)upsertModifiedEntities;
- (void)deleteRemovedEntities;

- (void)logoutCurrentUser;

@end
