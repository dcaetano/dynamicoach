//
//  AppDelegate.h
//  DynamiCoach
//
//  Created by Danilo on 1/15/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrimaryViewController.h"
#import "InitialSetupViewController.h"
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) PrimaryViewController *pvc;
@property (nonatomic, strong) InitialSetupViewController *isvc;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *playerDB;
@property (nonatomic) FMDatabase *database;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
