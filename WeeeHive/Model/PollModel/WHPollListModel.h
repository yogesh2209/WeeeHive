//
//  WHPollListModel.h
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHPollListDetailsModel.h"

@interface WHPollListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHPollListDetailsModel> *polls;

@end
