//
//  WHNeghborChatListModel.m
//  WeeeHive
//
//  Created by Schoofi on 10/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHNeghborChatListModel.h"

@implementation WHNeghborChatListModel

- (id)init {
    
    if (self = [super init]) {
        
        self.chat = (id)[NSMutableArray new];
    }
    
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
