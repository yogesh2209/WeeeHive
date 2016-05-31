//
//  WHSchoolListModel.m
//  WeeeHive
//
//  Created by Schoofi on 17/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHSchoolListModel.h"

@implementation WHSchoolListModel

- (id)init {
    
    if (self = [super init]) {
        
        self.school_List = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
