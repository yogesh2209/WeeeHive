//
//  WHPollListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHPollListDetailsModel <NSObject>
@end

@interface WHPollListDetailsModel : JSONModel

@property (nonatomic,strong) NSString *poll_id;
@property (nonatomic,strong) NSString *created_by;
@property (nonatomic,strong) NSString *question;
@property (nonatomic,strong) NSString *option;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *answer;
@property (nonatomic,strong) NSString *ans_by;
@property (nonatomic,strong) NSString *likes;
@property (nonatomic,strong) NSString *unlikes;

@end
