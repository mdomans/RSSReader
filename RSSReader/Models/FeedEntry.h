//
//  FeedEntry.h
//  RSSReader
//
//  Created by mdomans on 21.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed;

@interface FeedEntry : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * published;
@property (nonatomic, retain) NSDate * creation_date;
@property (nonatomic, retain) Feed *feed;

@end
