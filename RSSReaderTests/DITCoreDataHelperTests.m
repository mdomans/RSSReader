//
//  DITCoreDataHelperTests.m
//  RSSReader
//
//  Created by mdomans on 22.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DITCoreDataHelper.h"
#import "Feed.h"
#import <Kiwi/Kiwi.h>

@interface DITCoreDataHelperTests : XCTestCase

@end

@implementation DITCoreDataHelperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateInMemoryStore {
    NSPersistentStoreCoordinator *coord = [NSPersistentStoreCoordinator createInMemoryStore];
    XCTAssert(coord.persistentStores, @"");
    XCTAssertEqual(1, coord.persistentStores.count, @"");
    NSPersistentStore *store = coord.persistentStores[0];
    XCTAssertEqual(store.type, NSInMemoryStoreType, @"");
}

- (void)testCreateInContextManagedObject {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = [NSPersistentStoreCoordinator createInMemoryStore];
    XCTAssertThrows([NSManagedObject createInContext:context], @"");
}

- (void)testCreateInContextSubclass {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = [NSPersistentStoreCoordinator createInMemoryStore];
    NSManagedObject *object = [Feed createInContext:context];
    XCTAssert(object, @"");
}

@end

SPEC_BEGIN(DITCoreDataUtils)

describe(@"DITCoreDataUtils", ^{
    context(@"create context", ^{
        let(managedObjectContext, ^{
            NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
            managedObjectContext.persistentStoreCoordinator = [NSPersistentStoreCoordinator createInMemoryStore];
            return managedObjectContext;
        });
        beforeEach(^{
            
        });
        it(@"should not allow to create a NSManagedObject", ^{
            [[theBlock(^{
                [NSManagedObject createInContext:managedObjectContext];
            }) should] raise];
        });
        it(@"should allow to create an instance of NSManagedObject subclass", ^{
            Feed *feed = [Feed createInContext:managedObjectContext];
            [feed shouldNotBeNil];
        });
        it(@"should have a sharedInstance", ^{
            [[[DITCoreDataHelper sharedInstance] should] beMemberOfClass:[DITCoreDataHelper class]];
        });
        it(@"should be able to fetch object", ^{
            Feed *feed = [Feed createInContext:managedObjectContext];
            [[DITCoreDataHelper sharedInstance] stub:@selector(managedObjectContext) andReturn:managedObjectContext];
            feed.title = @"test";
            NSManagedObjectID *objectID = [feed objectID];
            [managedObjectContext save:nil];
            NSManagedObject *object = [[DITCoreDataHelper sharedInstance] fetchObjectWithID:objectID];
            [[object should] beNonNil];
            [[[object objectID] should] beIdenticalTo:objectID];
        });
        it(@"should return entity name", ^{
            [[[Feed entityName] should] beNonNil];
            [[[Feed entityName] should] equal:@"Feed"];
        });
        it(@"should fetch one object", ^{
            [Feed createInContext:managedObjectContext];
            Feed *fetched = [Feed fetchOneInContext:managedObjectContext];
            [[fetched should] beNonNil];
        });
        it(@"should fetch multiple objects", ^{
            [Feed createInContext:managedObjectContext];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Feed entityName]];
            [Feed fetchWithFetchRequest:fetchRequest inContext:managedObjectContext];
        });
    });
});

SPEC_END
