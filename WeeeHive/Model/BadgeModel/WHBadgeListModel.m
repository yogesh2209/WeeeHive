//
//  WHBadgeListModel.m
//  WeeeHive
//
//  Created by Schoofi on 27/05/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHBadgeListModel.h"

@implementation WHBadgeListModel

- (id)init {
    
    if (self = [super init]) {
        
        self.badge = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
