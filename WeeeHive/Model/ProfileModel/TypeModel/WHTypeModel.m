//
//  WHTypeModel.m
//  WeeeHive
//
//  Created by Schoofi on 26/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHTypeModel.h"

@implementation WHTypeModel

- (id)init {
    
    if (self = [super init]) {
        
        self.type = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
