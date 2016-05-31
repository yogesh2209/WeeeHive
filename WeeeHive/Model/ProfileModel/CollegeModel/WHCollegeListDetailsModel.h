//
//  WHCollegeListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 17/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHCollegeListDetailsModel <NSObject>
@end

@interface WHCollegeListDetailsModel : JSONModel

@property (nonatomic,strong) NSString *college_name;
@property (nonatomic,strong) NSString *college_id;
@property (nonatomic,strong) NSString *id;

@end
