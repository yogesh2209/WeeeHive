//
//  WHLoginModel.h
//  WeeeHive
//
//  Created by Schoofi on 21/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHLoginDetailsModel.h"

@interface WHLoginModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHLoginDetailsModel> *user_Details;

@end
