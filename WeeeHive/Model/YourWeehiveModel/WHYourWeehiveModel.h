//
//  WHYourWeehiveModel.h
//  WeeeHive
//
//  Created by Schoofi on 12/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHYourWeehiveDetailsModel.h"

@interface WHYourWeehiveModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHYourWeehiveDetailsModel> *group;

@end
