//
//  WHYourWeehiveDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 12/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHYourWeehiveDetailsModel <NSObject>

@end

@interface WHYourWeehiveDetailsModel : JSONModel

@property (nonatomic,strong) NSString *group_id;
@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSString *created_by;
@property (nonatomic,strong) NSString *picture;
@property (nonatomic,strong) NSString *created_date;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *comment_by;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *cmnconn;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *request_by;
@property (nonatomic,strong) NSString *image;



@end
