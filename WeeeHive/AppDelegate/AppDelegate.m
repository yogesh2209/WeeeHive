//
//  AppDelegate.m
//  WeeeHive
//
//  Created by Schoofi on 15/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "AppDelegate.h"
//#import <Parse/Parse.h>
#import "WHSingletonClass.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "WHCouponsViewController.h"
#import "WHPulsePollViewController.h"
#import "WHNotificationsViewController.h"
#import "WHRequestsPushViewController.h"
#import "WHNeighborTimesViewController.h"
#import "WHYourNeighborhoodMsgsChattingViewController.h"
#import "WHWeehiveDetailsViewController.h"
#import "WHMessagesPushViewController.h"
#import "WHHomeViewController.h"

#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WHHomeViewController.h"


@interface AppDelegate ()
{
    //Singleton Objects
    WHSingletonClass *sharedObject;
    NSUserDefaults *defaults;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Digits class]]];
  //  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
  //  {
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
  //  }
  //  else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
    [[UITextView appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:244.0/255.0 green:174.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 0);
    shadow.shadowColor = [UIColor whiteColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]
       }
     forState:UIControlStateNormal];
    
    [self createAlertView];
    [self checkInternetConnection];
    [ASNetworkAlertClass sharedManager];
    
    //            //FUNCTION When app is not running. it is killed.
    //            NSDictionary *remoteNotification=launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    //            if(remoteNotification){
    //                NSString *remoteMessage=remoteNotification[@"aps"][@"alert"];
    //                UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"Received on launch" message:remoteMessage preferredStyle:UIAlertControllerStyleAlert];
    //
    //                UIAlertAction *aa=[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    //
    //                [ac addAction:aa];
    //
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                    [application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    //
    //                });
    
    //  }
    
//         NSString *isLogged=[defaults objectForKey:@"TOKEN"];
//         NSLog(@"%@",isLogged);
    
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        //do calculations
//        
//        NSString *getV=[defaults objectForKey:@"LOGGED"];
//        
//        NSLog(@"%@",getV);
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            //load main view controller
//            BOOL isLogged=[[WHSingletonClass sharedManager] singletonIsLoggedIn];
//            NSLog(@"%d",isLogged);
//            
//            NSLog(@"%@",[[WHSingletonClass sharedManager] singletonStatus]);
//            
//            if ([getV isEqualToString:@"1"] || isLogged==1) {
//                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//                UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
//                WHHomeViewController *someVC = (WHHomeViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"homeStoryBoard"];
//                [navVc pushViewController: someVC animated:YES];
//            }
//
//        });
//    });
    
    
    // Override point for customization after application launch.
    return YES;
}
//Push Notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString=[defaults objectForKey:@"TOKEN"];
    
    
    if (tokenString.length!=0 && [deviceTokenString isEqualToString:tokenString]) {
        
    }
    else{
        [defaults setObject:deviceTokenString forKey:@"TOKEN"];
        [defaults synchronize];
        NSString *tokenString=[defaults objectForKey:@"TOKEN"];
        sharedObject =[WHSingletonClass sharedManager];
        sharedObject.deviceId=tokenString;
    }
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
   
    NSArray *userInfoArray=[[NSArray alloc]init];
    userInfoArray=[userInfo valueForKey:@"aps"];
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        
    } else {
        
        NSString *tag=[userInfoArray valueForKey:@"tag"];
       int tagValue= [tag intValue];
        SystemSoundID soundID = 1104;
        AudioServicesPlaySystemSound(soundID);
       
        //FRIEND REQUEST PUSH OR GROUP REQUEST PUSH
        if (tagValue == 1 || tagValue==2) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            WHRequestsPushViewController *someVC = (WHRequestsPushViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"requestsStoryBoard"];
            [navVc pushViewController: someVC animated:YES];
            
        }
        //NEIGHBOUR CHAT PUSH || GROUP CHAT PUSH
        else if (tagValue == 3 || tagValue==4){
            
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            WHMessagesPushViewController *someVC = (WHMessagesPushViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"messagesStoryBoard"];
            [navVc pushViewController: someVC animated:YES];
        }
        //POLL ADD PUSH
        else if (tagValue==5){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            WHPulsePollViewController *someVC = (WHPulsePollViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"pollStoryBoard"];
            [navVc pushViewController: someVC animated:YES];
        }
        //COUPON ADD PUSH
        else if (tagValue==6){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            WHCouponsViewController *someVC = (WHCouponsViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"couponsStoryBoard"];
            [navVc pushViewController: someVC animated:YES];
        }
        //NEIGH TIMES ADD
        else if (tagValue==7){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            WHNeighborTimesViewController *someVC = (WHNeighborTimesViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"neghTimesStoryBoard"];
            [navVc pushViewController: someVC animated:YES];
        }
        //ACTION FRIEND REQUEST PUSH OR ACTION GROUP REQUEST PUSH
        else if (tagValue == 8 || tagValue==9){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            WHNotificationsViewController *someVC = (WHNotificationsViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"notificationsStoryBoard"];
            [navVc pushViewController: someVC animated:YES];
        }
       
        else{
            
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //  NSLog(@"Did Fail to Register for Remote Notifications");
    //  NSLog(@"%@, %@", error, error.localizedDescription);
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    int badgeCount =  (int) [UIApplication sharedApplication].applicationIconBadgeNumber;
//    NSLog(@"%d",badgeCount);
//   // badgeCount = badgeCount + 1;
//NSLog(@"%d",badgeCount);
//    [UIApplication sharedApplication].applicationIconBadgeNumber=badgeCount;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    int badgeCount =  (int) [UIApplication sharedApplication].applicationIconBadgeNumber;
//    
//   
//    NSLog(@"%d",badgeCount);
//    sharedObject.singletonBadge= badgeCount;
//    NSLog(@"%d",sharedObject.singletonBadge);
//    int v=sharedObject.singletonBadge;
//    NSLog(@"%d",v);
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    int badgeCount =  (int) [UIApplication sharedApplication].applicationIconBadgeNumber;
//    NSLog(@"%d",badgeCount);
//    badgeCount = badgeCount + 1;
//    NSLog(@"%d",badgeCount);
//    [UIApplication sharedApplication].applicationIconBadgeNumber=badgeCount;
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Schoofi.WeeeHive" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeeeHive" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeeeHive.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)createAlertView {
    
    self.internetDownAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, -64)];
    
    [self.window addSubview:self.internetDownAlert];
    [self.window bringSubviewToFront:self.internetDownAlert];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.internetDownAlert.frame.origin.y + 20, self.internetDownAlert.frame.size.width, self.internetDownAlert.frame.size.height - 20)];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.internetDownAlert addSubview:self.messageLabel];
}

/*!
 * Create custom alertView to show the network status.
 */
- (void)checkInternetConnection {
    
    //Check For Network Activity
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    [self checkNetworkStatus:nil];
}

#pragma mark  Reachability Section

/*!
 * Method to check internet connection by using the currentReachabilityStatus
 * @param notice Recahbility Notification
 */
-(void)checkNetworkStatus:(NSNotification *)notice{
    
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            // NSLog(@"The internet is down.");
            self.isInternetActive = NO;
            [WHUtlity sharedDetails].isInternetConnection = NO;
            [self internetErrorAlertBar];
            
            break;
        }
        case ReachableViaWiFi:
        {
            // NSLog(@"The internet is working via WIFI.");
            self.isInternetActive = YES;
            [WHUtlity sharedDetails].isInternetConnection = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOAD_TODAYS_BET" object:nil];
            [self internetWorkingFineAlertBar];
            break;
        }
        case ReachableViaWWAN:
        {
            // NSLog(@"The internet is working via WWAN.");
            self.isInternetActive = YES;
            [WHUtlity sharedDetails].isInternetConnection = YES;
            
            break;
        }
        default:
        {
            //  NSLog(@"The internet is not Rechable");
            self.isInternetActive = NO;
            [WHUtlity sharedDetails].isInternetConnection = NO;
        }
    }
}

/*!
 *  Method to show message i.e @"Internet working fine".
 */
- (void)internetWorkingFineAlertBar {
    
    // Show internet alert.
    self.internetDownAlert.backgroundColor = GREEN_COLOR;
    self.messageLabel.text = @"Internet working fine";
    [self.window bringSubviewToFront:self.internetDownAlert];
    self.internetDownAlert.alpha = 1.0f;
    if ([self.alertTimer isValid]) {
        
        [self.alertTimer invalidate];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.internetDownAlert.frame;
        frame.origin.y = 0;
        self.internetDownAlert.frame = frame;
    } completion:^(BOOL finished) {
        
        self.alertTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startAlertTimer:) userInfo:nil repeats:NO];
    }];
}

/*!
 *  Method to show message i.e @"Internet connection error".
 */
- (void)internetErrorAlertBar {
    // Show internet alert.
    self.internetDownAlert.backgroundColor = ORANGE_COLOR(1.0);
    self.messageLabel.text = @"Internet connection error";
    [self.window bringSubviewToFront:self.internetDownAlert];
    self.internetDownAlert.alpha = 1.0f;
    
    if ([self.alertTimer isValid]) {
        
        [self.alertTimer invalidate];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.internetDownAlert.frame;
        frame.origin.y = 0;
        self.internetDownAlert.frame = frame;
    } completion:^(BOOL finished) {
        
        self.alertTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startAlertTimer:) userInfo:nil repeats:NO];
    }];
}

/*!
 *  Method to handle custom alertView animation duration.
 */
- (void)startAlertTimer:(NSTimer *)timer {
    
    [UIView animateWithDuration:0.7 animations:^{
        
        self.internetDownAlert.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.0 animations:^{
            CGRect frame = self.internetDownAlert.frame;
            frame.origin.y = -64;
            self.internetDownAlert.frame = frame;
            self.internetDownAlert.alpha = 1.0f;
        } completion:nil];
    }];
}



@end
