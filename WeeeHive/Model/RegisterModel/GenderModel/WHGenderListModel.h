//
//  WHGenderListModel.h
//  WeeeHive
//
//  Created by Schoofi on 16/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

#import "WHGenderListDetailsModel.h"

@interface WHGenderListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHGenderListDetailsModel> *gender;


@end
