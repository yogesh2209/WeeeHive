//
//  WHGenderListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 16/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHGenderListDetailsModel <NSObject>
@end

@interface WHGenderListDetailsModel : JSONModel

@property (nonatomic,strong) NSString *full_name;
@property (nonatomic,strong) NSString *code;


@end
