//
//  DITFeedParserHelper.h
//  RSSReader
//
//  Created by mdomans on 20.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DITFeedParserHelper : NSObject

+ (instancetype)sharedInstance;

- (void)enqueFeedWithObjectID:(NSManagedObjectID *)objectID;

@end
