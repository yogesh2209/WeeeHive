//
//  WHYourNeghborListModel.m
//  WeeeHive
//
//  Created by Schoofi on 10/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHYourNeghborListModel.h"

@implementation WHYourNeghborListModel

- (id)init {
    
    if (self = [super init]) {
        
        self.your_Neg = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
