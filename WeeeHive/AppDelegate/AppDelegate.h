//
//  AppDelegate.h
//  WeeeHive
//
//  Created by Schoofi on 15/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"
#import "Constant.h"
#import "ASNetworkAlertClass.h"
#import "WHUtlity.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


// Defined for Internet Alert View.
@property (strong, nonatomic) UIView *internetDownAlert;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) Reachability* internetReachable;
@property (nonatomic) BOOL isInternetActive;
@property (strong, nonatomic) NSTimer *alertTimer;



- (void)internetWorkingFineAlertBar;
- (void)internetErrorAlertBar;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

