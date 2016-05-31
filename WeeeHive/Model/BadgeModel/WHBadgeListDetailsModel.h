//
//  WHBadgeListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 27/05/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHBadgeListDetailsModel <NSObject>

@end

@interface WHBadgeListDetailsModel : JSONModel

@property (nonatomic,assign) int badge;

@end
