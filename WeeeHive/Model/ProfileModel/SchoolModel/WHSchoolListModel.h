//
//  WHSchoolListModel.h
//  WeeeHive
//
//  Created by Schoofi on 17/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHSchoolListDetailsModel.h"


@interface WHSchoolListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHSchoolListDetailsModel> *school_List;

@end
