//
//  WHGenderListModel.m
//  WeeeHive
//
//  Created by Schoofi on 16/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHGenderListModel.h"

@implementation WHGenderListModel

- (id)init {
    
    if (self = [super init]) {
        
        self.gender = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
    
}

@end
