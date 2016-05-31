//
//  WHYourWeehiveModel.m
//  WeeeHive
//
//  Created by Schoofi on 12/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHYourWeehiveModel.h"

@implementation WHYourWeehiveModel

- (id)init {
    
    if (self = [super init]) {
        
        self.group = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}


@end
