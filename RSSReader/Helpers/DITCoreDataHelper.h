//
//  DITCoreDataHelper.h
//  RSSReader
//
//  Created by mdomans on 20.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DITCoreDataHelperUpdateBlock)(NSManagedObject *object);

@interface DITCoreDataHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;

- (void)fetchObjectWithObjectID:(NSManagedObjectID *)objectID updateBlock:(DITCoreDataHelperUpdateBlock)updateBlock;
- (NSManagedObject *)fetchObjectWithID:(NSManagedObjectID *)objectID;

@end


@interface NSManagedObject (DITUtils)

+ (NSString *)entityName;
+ (instancetype)createInContext:(NSManagedObjectContext *)context;
+ (instancetype)fetchOneInContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetchWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context;


@end

@interface NSPersistentStoreCoordinator (DITUtils)

+ (instancetype)createInMemoryStore ;

@end