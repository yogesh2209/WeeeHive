//
//  WHCityDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 04/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHCityDetailsModel <NSObject>
@end

@interface WHCityDetailsModel : JSONModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *city;

@end
