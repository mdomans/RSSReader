//
//  Feed.h
//  RSSReader
//
//  Created by mdomans on 21.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedEntry;

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSDate * creation_date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * update_date;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * webpage;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Feed (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(FeedEntry *)value;
- (void)removeEntriesObject:(FeedEntry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
