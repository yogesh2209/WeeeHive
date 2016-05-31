//
//  WHCollegeListModel.h
//  WeeeHive
//
//  Created by Schoofi on 17/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

#import "WHCollegeListDetailsModel.h"

@interface WHCollegeListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHCollegeListDetailsModel> *college_List;

@end
