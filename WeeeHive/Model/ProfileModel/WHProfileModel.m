//
//  WHProfileModel.m
//  WeeeHive
//
//  Created by Schoofi on 23/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHProfileModel.h"

@implementation WHProfileModel
- (id)init {
    
    if (self = [super init]) {
        
        self.profile = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
