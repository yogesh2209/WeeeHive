//
//  WHCityModel.h
//  WeeeHive
//
//  Created by Schoofi on 04/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

#import "WHCityDetailsModel.h"
@interface WHCityModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHCityDetailsModel> *city;

@end
