//
//  WHSingletonClass.m
//  WeeeHive
//
//  Created by Schoofi on 23/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHSingletonClass.h"

@implementation WHSingletonClass

+ (id)sharedManager {
    
    static WHSingletonClass *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}


@end
