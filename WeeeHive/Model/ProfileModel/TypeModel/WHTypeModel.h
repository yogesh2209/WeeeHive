//
//  WHTypeModel.h
//  WeeeHive
//
//  Created by Schoofi on 26/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHTypeDetailsModel.h"

@interface WHTypeModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHTypeDetailsModel> *type;

@end
