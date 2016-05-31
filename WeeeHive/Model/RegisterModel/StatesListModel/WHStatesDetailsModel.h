//
//  WHStatesDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 20/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHStatesDetailsModel <NSObject>
@end

@interface WHStatesDetailsModel : JSONModel

@property (nonatomic,strong) NSString *state;

@end
