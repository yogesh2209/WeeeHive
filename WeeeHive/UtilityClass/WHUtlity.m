//
//  WHUtlity.m
//  WeeeHive
//
//  Created by Schoofi on 09/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHUtlity.h"


@implementation WHUtlity

+ (WHUtlity *)sharedDetails {
    
    static WHUtlity *commonFile = nil;
    
    if (commonFile == nil) {
        commonFile = [[WHUtlity alloc] init];
    }
    
    return commonFile;
}


@end
