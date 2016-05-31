//
//  WHProfileDetailsModel.m
//  WeeeHive
//
//  Created by Schoofi on 23/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHProfileDetailsModel.h"

@implementation WHProfileDetailsModel

- (id)init {
    
    if (self = [super init]) {
        
        
        self.isAdded = @"0";
        
        
    }
    
    return self;
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
