//
//  DITFeedHelper.h
//  RSSReader
//
//  Created by mdomans on 19.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DITFeedHelperFindFeedCompletionBlock)(NSString *feedURLString);

@interface DITFeedHelper : NSObject

+ (void)findRSSFeedForURL:(NSURL*)url completionBlock:(DITFeedHelperFindFeedCompletionBlock)completionBlock;
+ (NSString *)findRSSFeedForURL:(NSURL*)url;

@end
