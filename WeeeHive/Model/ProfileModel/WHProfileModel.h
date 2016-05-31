//
//  WHProfileModel.h
//  WeeeHive
//
//  Created by Schoofi on 23/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHProfileDetailsModel.h"

@interface WHProfileModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHProfileDetailsModel> *profile;

@end
