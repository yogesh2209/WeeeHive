//
//  WHNeghborChatListModel.h
//  WeeeHive
//
//  Created by Schoofi on 10/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

#import "WHNeghborChatListDetailsModel.h"

@interface WHNeghborChatListModel : JSONModel

@property (nonatomic, strong) NSMutableArray <WHNeghborChatListDetailsModel> *chat;


@end
