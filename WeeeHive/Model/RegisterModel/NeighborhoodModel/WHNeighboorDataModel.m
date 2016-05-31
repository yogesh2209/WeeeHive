//
//  WHNeighboorDataModel.m
//  WeeeHive
//
//  Created by Schoofi on 04/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHNeighboorDataModel.h"

@implementation WHNeighboorDataModel

- (id)init {
    
    if (self = [super init]) {
        
        self.city_Neg = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
    
}

@end
