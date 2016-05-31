//
//  WHPushNotificationsListModel.h
//  WeeeHive
//
//  Created by Schoofi on 25/05/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "JSONModel.h"
#import "WHPushNotificationsListDetailsModel.h"

@interface WHPushNotificationsListModel : JSONModel

@property (nonatomic,strong) NSMutableArray <WHPushNotificationsListDetailsModel> *notifications;

@end
