//
//  LNKAppDelegate.h
//  Link
//
//  Created by David Zilli on 8/17/14.
//  Copyright (c) 2014 Link. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
