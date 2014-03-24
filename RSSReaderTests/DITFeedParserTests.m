//
//  DITFeedParserTests.m
//  RSSReader
//
//  Created by mdomans on 22.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DITFeedParserHelper.h"
#import "DITFeedParserHandler.h"
#import "DITCoreDataHelper.h"
#import "Feed.h"
#import "FeedEntry.h"
#import <MWFeedParser/MWFeedParser.h>
#import <MWFeedParser/MWFeedInfo.h>
#import <Kiwi/Kiwi.h>


@interface DITFeedParserTests : XCTestCase

@property (nonatomic, strong) DITFeedParserHandler * feedParserHandler;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation DITFeedParserTests

- (void)setUp
{
    [super setUp];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = [NSPersistentStoreCoordinator createInMemoryStore];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateDITFeedParserHandler {
    Feed *feed = [Feed createInContext:self.context];
    XCTAssert(feed, @"could not create feed");
    self.feedParserHandler = [[DITFeedParserHandler alloc] initWithFeed:feed];
    XCTAssert(self.feedParserHandler, @"could not create feedParserHandler");
}

- (void)testFeedParserDidParseFeedInfo {
    Feed *feed = [Feed createInContext:self.context];
    id <MWFeedParserDelegate> handler = [[DITFeedParserHandler alloc] initWithFeed:feed];
    id infoMock = [MWFeedInfo mock];
    [infoMock stub:@selector(title) andReturn:@"testing"];
    [handler feedParser:nil didParseFeedInfo:infoMock];
    XCTAssertEqual(feed.title, @"testing", @"");
}

@end

SPEC_BEGIN(DITFeedParserHandlerTests)

describe(@"DITFeedParserHandler", ^{
    context(@"create context", ^{
        let(managedObjectContext, ^{
            NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
            managedObjectContext.persistentStoreCoordinator = [NSPersistentStoreCoordinator createInMemoryStore];
            return managedObjectContext;
        });
        let(feed, ^{
            return [Feed createInContext:managedObjectContext];
        });
        let(handler, ^{
            return [[DITFeedParserHandler alloc] initWithFeed:feed];
        });
        beforeEach(^{
            
        });
        it(@"should set title of Feed", ^{
            id infoMock = [MWFeedInfo mock];
            [infoMock stub:@selector(title) andReturn:@"testing"];
            [handler feedParser:nil didParseFeedInfo:infoMock];
            [[[feed title] should] beIdenticalTo:@"testing"];
        });
        it(@"should set create FeedEntry for each item in feed", ^{
            id itemMock = [MWFeedItem mock];
            [itemMock stub:@selector(title) andReturn:@"testingTitle"];
            [itemMock stub:@selector(summary) andReturn:@"testingSummary"];
            [itemMock stub:@selector(author) andReturn:@"testingAuthor"];
            [itemMock stub:@selector(date) andReturn:[NSDate date]];
            [handler feedParser:nil didParseFeedItem:itemMock];
            [[[feed entries] should] haveCountOf:1];
            FeedEntry *entry = [FeedEntry fetchOneInContext:managedObjectContext];
            [[entry should] beNonNil];
            [[[entry title] should] equal:@"testingTitle"];
            [[[entry feed] should] equal:feed];
            [[[entry summary] should] equal:@"testingSummary"];
            [[[entry author] should] equal:@"testingAuthor"];
            
        });
    });
});

SPEC_END
