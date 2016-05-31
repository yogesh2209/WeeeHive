//
//  WHTypeInfoModel.h
//  WeeeHive
//
//  Created by Schoofi on 26/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHTypeDetailsModel <NSObject>
@end

@interface WHTypeDetailsModel : JSONModel

@property (nonatomic,strong) NSString *full_name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *occupation;
@property (nonatomic,strong) NSString *college_name;
@property (nonatomic,strong) NSString *college_id;
@property (nonatomic,strong) NSString *school_name;
@property (nonatomic,strong) NSString *school_id;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *work_interest_id;
@property (nonatomic,strong) NSString *work_interest;
@property (nonatomic,strong) NSString *help_in_as;

@end
