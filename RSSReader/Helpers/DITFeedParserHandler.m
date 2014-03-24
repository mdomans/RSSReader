//
//  DITFeedParserHandler.m
//  RSSReader
//
//  Created by mdomans on 21.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import "DITFeedParserHandler.h"
#import "Feed.h"
#import "../Models/FeedEntry.h"
#import <MWFeedParser/MWFeedParser.h>
#import "DITCoreDataHelper.h"

@interface DITFeedParserHandler () <MWFeedParserDelegate>

@property (strong, nonatomic) NSManagedObjectID *objectID;
@property (strong, nonatomic) MWFeedParser *parser;
@property (strong, nonatomic) Feed *feed;

@end

@implementation DITFeedParserHandler

- (DITFeedParserHandler *)initWithFeed:(Feed *)feed {
    DITFeedParserHandler * handler = [super init];
    handler.feed = feed;
    handler.parser = [[MWFeedParser alloc] initWithFeedURL:[NSURL URLWithString:feed.url]];
    handler.parser.delegate = handler;
    handler.parser.feedParseType = ParseTypeFull;
    handler.parser.connectionType = ConnectionTypeAsynchronously;
    return handler;
}

- (void)start {
    [self.parser parse];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
    self.feed.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
    FeedEntry *entry = [FeedEntry createInContext:self.feed.managedObjectContext];
    entry.title = item.title;
    entry.summary = item.summary;
    entry.published = item.date;
    entry.author = item.author;
    entry.feed = self.feed;
    
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    NSManagedObjectContext *context = self.feed.managedObjectContext;
    NSError *error = nil;
    if(![context save:&error]){
        NSLog(@"%@", error);
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    
}

@end

