//
//  DITFeedHelper.m
//  RSSReader
//
//  Created by mdomans on 19.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import "DITFeedHelper.h"

@implementation DITFeedHelper

+ (void)findRSSFeedForURL:(NSURL *)url completionBlock:(DITFeedHelperFindFeedCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSError *regExpError = nil;
            NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"http(s)?(.*)\\.rss" options:NSRegularExpressionCaseInsensitive error:&regExpError];
            NSArray *matches = [regExp matchesInString:data options:0 range:NSMakeRange(0, [data length])];
            if ([matches count]) {
                NSTextCheckingResult *result = matches[0];
                NSString *rssHtmlTag = [data substringWithRange:result.range];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(rssHtmlTag);
                });
            }
        }
    });
}

+ (NSString *)findRSSFeedForURL:(NSURL *)url {
    NSError *error = nil;
    NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSError *regExpError = nil;
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"http(s)?(.*)\\.rss" options:NSRegularExpressionCaseInsensitive error:&regExpError];
        assert(!regExpError);
        NSArray *matches = [regExp matchesInString:data options:0 range:NSMakeRange(0, [data length])];
        if ([matches count]) {
            NSTextCheckingResult *result = matches[0];
            NSString *rssHtmlTag = [data substringWithRange:result.range];
            return rssHtmlTag;
        }
    }
    return NULL;
}


@end
