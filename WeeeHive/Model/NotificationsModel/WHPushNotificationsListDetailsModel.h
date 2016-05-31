//
//  WHPushNotificationsListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 25/05/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHPushNotificationsListDetailsModel <NSObject>
@end

@interface WHPushNotificationsListDetailsModel : JSONModel


@property (nonatomic,strong) NSString *tag;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *badge;
@property (nonatomic,strong) NSString *payload;
@property (nonatomic,strong) NSString *date_time;
@property (nonatomic,strong) NSString *image;

@end
