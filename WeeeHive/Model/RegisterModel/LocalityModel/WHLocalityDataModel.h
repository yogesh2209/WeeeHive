//
//  WHLocalityDataModel.h
//  WeeeHive
//
//  Created by Schoofi on 04/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHLocalityDetailsModel.h"

@interface WHLocalityDataModel : JSONModel

@property (nonatomic,strong) NSMutableArray  <WHLocalityDetailsModel> *city_Neg_loc;

@end
