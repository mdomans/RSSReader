//
//  DITFeedParserHelper.m
//  RSSReader
//
//  Created by mdomans on 20.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import "DITFeedParserHelper.h"
#import "DITCoreDataHelper.h"
#import "DITFeedParserHandler.h"
#import "Feed.h"
#import <MWFeedParser/MWFeedParser.h>

@interface DITFeedParserHelper () <MWFeedParserDelegate>

@property (nonatomic, strong) NSMutableArray *handlers;

@end

@implementation DITFeedParserHelper

+ (instancetype)sharedInstance {
    static DITFeedParserHelper *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DITFeedParserHelper new];
        sharedInstance.handlers = [NSMutableArray new];
    });
    return sharedInstance;
}

-(void)enqueFeedWithObjectID:(NSManagedObjectID *)objectID {
    Feed *feed = (Feed *)[[DITCoreDataHelper sharedInstance] fetchObjectWithID:objectID];
    DITFeedParserHandler *newHandler = [[DITFeedParserHandler alloc] initWithFeed:feed];
    [self.handlers addObject:newHandler];
    [newHandler start];
}

@end
