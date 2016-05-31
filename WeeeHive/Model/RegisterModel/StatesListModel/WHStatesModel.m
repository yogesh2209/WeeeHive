//
//  WHStatesModel.m
//  WeeeHive
//
//  Created by Schoofi on 20/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHStatesModel.h"

@implementation WHStatesModel

- (id)init {
    
    if (self = [super init]) {
        
        self.stateList = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
