//
//  WHYourNeghborListDetailsModel.h
//  WeeeHive
//
//  Created by Schoofi on 10/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "JSONModel.h"

@protocol WHYourNeghborListDetailsModel <NSObject>

@end

@interface WHYourNeghborListDetailsModel : JSONModel

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

@end

