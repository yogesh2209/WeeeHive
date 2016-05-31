//
//  WHLocalityDataModel.m
//  WeeeHive
//
//  Created by Schoofi on 04/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHLocalityDataModel.h"

@implementation WHLocalityDataModel


- (id)init {
    
    if (self = [super init]) {
        
        self.city_Neg_loc = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
    
}

@end
