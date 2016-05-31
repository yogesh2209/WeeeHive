//
//  WHPollListModel.m
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHPollListModel.h"

@implementation WHPollListModel

-(id)init{
    
    if (self=[super init]) {
        
        self.polls= (id)[NSMutableArray new];
    }
    return self;
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
