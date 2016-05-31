//
//  WHNeighboorDataModel.h
//  WeeeHive
//
//  Created by Schoofi on 04/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHNeighborhoodDetailsModel.h"

@interface WHNeighboorDataModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHNeighborhoodDetailsModel> *city_Neg;

@end
