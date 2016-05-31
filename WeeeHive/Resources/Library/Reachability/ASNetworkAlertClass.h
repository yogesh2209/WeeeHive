//
//  ASNetworkAlertClass.h
//  NetworkCheckClass
//
//  Created by Amandeep Singh on 12/07/15.
//  Copyright (c) 2015 Amandeep Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Internet checking class.
#import "Reachability.h"

@interface ASNetworkAlertClass : NSObject 

// Property to check internet connection.
@property (nonatomic) BOOL isInternetActive;

+ (id)sharedManager;
- (void)showInternetErrorAlertWithMessage;
- (void)showInternetWorkingFineAlertWithMessage;

@end
