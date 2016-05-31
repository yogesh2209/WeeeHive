//
//  WHBadgeListModel.h
//  WeeeHive
//
//  Created by Schoofi on 27/05/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHBadgeListDetailsModel.h"

@interface WHBadgeListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHBadgeListDetailsModel> *badge;

@end
