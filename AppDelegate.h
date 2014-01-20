//
//  AppDelegate.h
//  DynamiCoach
//
//  Created by Danilo on 1/15/14.
//  Copyright (c) 2014 dcaetano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrimaryViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) PrimaryViewController *pvc;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
