//
//  WHNeghborChatListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 10/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHNeghborChatListDetailsModel <NSObject>

@end

@interface WHNeghborChatListDetailsModel : JSONModel

@property (nonatomic,strong) NSString *date_time;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *msg_by;

@end
