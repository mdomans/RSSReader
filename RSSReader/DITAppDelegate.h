//
//  DITAppDelegate.h
//  RSSReader
//
//  Created by mdomans on 17.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DITAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
