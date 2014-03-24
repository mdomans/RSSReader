//
//  DITCoreDataHelper.m
//  RSSReader
//
//  Created by mdomans on 20.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import "DITCoreDataHelper.h"

@interface DITCoreDataHelper ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation DITCoreDataHelper

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedInstance {
    static DITCoreDataHelper *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DITCoreDataHelper alloc] init];
    });
    return sharedInstance;
}

- (NSManagedObject *)fetchObjectWithID:(NSManagedObjectID *)objectID {
    return [self.managedObjectContext objectWithID:objectID];
}

- (void)fetchObjectWithObjectID:(NSManagedObjectID *)objectID updateBlock:(DITCoreDataHelperUpdateBlock)updateBlock {
    NSManagedObject *object = [self.managedObjectContext objectWithID:objectID];
    NSManagedObjectContext *__weak weakContext = self.managedObjectContext;
    dispatch_async(dispatch_get_main_queue(), ^{
        updateBlock(object);
        [weakContext save:nil];
    });
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RSSReader" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"RSSReader.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


@end


@implementation NSManagedObject (DITUtils)

+ (NSArray *)fetchWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    NSArray *data = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"%@", error);
        return nil;
    }
    return data;
}

+ (instancetype)fetchOneInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [fetchRequest setFetchLimit:1];
    NSArray *objects = [NSManagedObject fetchWithFetchRequest:fetchRequest inContext:context];
    if(objects.count){
        return objects[0];
    }else{
        return nil;
    }
}

+ (NSString *) entityName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createInContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    return newManagedObject;
}

@end

@implementation NSPersistentStoreCoordinator (DITUtils)

+ (instancetype)createInMemoryStore {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    [coord addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    return coord;
}

@end
