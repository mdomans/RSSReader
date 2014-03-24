//
//  DITFeedParserHandler.h
//  RSSReader
//
//  Created by mdomans on 21.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@interface DITFeedParserHandler : NSObject

- (instancetype)initWithFeed:(Feed *)feed;
- (void)start;


@end
