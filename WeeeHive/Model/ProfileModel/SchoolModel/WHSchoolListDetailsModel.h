//
//  WHSchoolListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 17/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHSchoolListDetailsModel <NSObject>
@end

@interface WHSchoolListDetailsModel : JSONModel

@property (nonatomic,strong) NSString *school_name;
@property (nonatomic,strong) NSString *school_id;
@property (nonatomic,strong) NSString *id;

@end
