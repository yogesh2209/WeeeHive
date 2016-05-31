//
//  WHLoginModel.m
//  WeeeHive
//
//  Created by Schoofi on 21/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHLoginModel.h"

@implementation WHLoginModel

- (id)init {
    
    if (self = [super init]) {
        
        self.user_Details = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
