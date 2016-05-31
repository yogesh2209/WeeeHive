//
//  WHStatesModel.h
//  WeeeHive
//
//  Created by Schoofi on 20/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHStatesDetailsModel.h"

@interface WHStatesModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHStatesDetailsModel> *stateList;

@end
