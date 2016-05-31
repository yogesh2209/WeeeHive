//
//  WHPushNotificationsListModel.m
//  WeeeHive
//
//  Created by Schoofi on 25/05/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHPushNotificationsListModel.h"

@implementation WHPushNotificationsListModel

- (id)init {
    
    if (self = [super init]) {
        
        self.notifications = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
