//
//  DITMasterViewController.h
//  RSSReader
//
//  Created by mdomans on 17.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface DITMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
