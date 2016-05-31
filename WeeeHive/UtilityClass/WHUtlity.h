//
//  WHUtlity.h
//  WeeeHive
//
//  Created by Schoofi on 09/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHUtlity : NSObject

@property (assign, nonatomic) BOOL isInternetConnection;

+ (WHUtlity *)sharedDetails;


@end
