//
//  WHYourNeghborListModel.h
//  WeeeHive
//
//  Created by Schoofi on 10/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHYourNeghborListDetailsModel.h"

@interface WHYourNeghborListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHYourNeghborListDetailsModel> *your_Neg;

@end
