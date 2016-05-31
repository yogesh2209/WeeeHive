//
//  WHProfileDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 23/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHProfileDetailsModel <NSObject>
@end

@interface WHProfileDetailsModel : JSONModel

@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *dob;
@property (nonatomic,strong) NSString *living_since;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *pincode;
@property (nonatomic,strong) NSString *weehives_name;
@property (nonatomic,strong) NSString *current_purpose;
@property (nonatomic,strong) NSString *occupation;
@property (nonatomic,strong) NSString *help_in;
@property (nonatomic,strong) NSString *interest1;
@property (nonatomic,strong) NSString *interest2;
@property (nonatomic,strong) NSString *interest3;
@property (nonatomic,strong) NSString *family;
@property (nonatomic,strong) NSString *marital_status;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *family_type;
@property (nonatomic,strong) NSString *locality;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *neighborhood_id;
@property (nonatomic,strong) NSString *neighborhood_name;
@property (nonatomic,strong) NSString *posted_date;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *post_id;
@property (nonatomic,strong) NSString *reply_date;
@property (nonatomic,strong) NSString *reply_details;
@property (nonatomic,strong) NSString *coupon_image;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *isAdded;
@property (nonatomic,assign) int count;
@property (nonatomic,strong) NSString *con_u_id;
@property (nonatomic,strong) NSString *group_id;
@property (nonatomic,strong) NSString *comments;
@property (nonatomic,strong) NSString *help_in_as;
@property (nonatomic,strong) NSString *rating;
@property (nonatomic,strong) NSString *tweet_image;
@property (nonatomic,strong) NSString *origin_city;
@property (nonatomic,strong) NSString *origin;
@property (nonatomic,strong) NSString *school;
@property (nonatomic,strong) NSString *college;
@property (nonatomic,strong) NSString *work_interest;
@property (nonatomic,strong) NSString *speciality;
@property (nonatomic,strong) NSString *connections;
@property (nonatomic,strong) NSString *reply_image;
@property (nonatomic,strong) NSString *origin_city_N;
@property (nonatomic,strong) NSString *origin_N;
@property (nonatomic,strong) NSString *school_N;
@property (nonatomic,strong) NSString *college_N;
@property (nonatomic,strong) NSString *work_interest_N;
@property (nonatomic,strong) NSString *city_N;
@property (nonatomic,strong) NSString *occupation_N;
@property (nonatomic,strong) NSString *current_purpose_N;
@property (nonatomic,strong) NSString *interest1_N;
@property (nonatomic,strong) NSString *interest2_N;
@property (nonatomic,strong) NSString *interest3_N;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *help_in_as_N;
@property (nonatomic,strong) NSString *date_time;
@property (nonatomic,strong) NSString *max_id;
@property (nonatomic,strong) NSString *request_by;
@property (nonatomic,strong) NSString *picture;
@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSString *created_by;
@property (nonatomic,strong) NSString *created_date;
@property (nonatomic,strong) NSString *admin_first_name;
@property (nonatomic,strong) NSString *admin_last_name;






@end
