//
//  WHSingletonClass.h
//  WeeeHive
//
//  Created by Schoofi on 23/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WHSingletonClass : NSObject

@property (nonatomic,strong) NSString *singletonFirstName;
@property (nonatomic,strong) NSString *singletonLastName;
@property (nonatomic,strong) NSString *singletonUserId;
@property (nonatomic,strong) NSString *singletonVrfCode;
@property (nonatomic,strong) NSString *singletonLocality;
@property (nonatomic,strong) NSString *singletonState;
@property (nonatomic,strong) NSString *singletonCity;
@property (nonatomic,strong) NSString *singletonPinCode;
@property (nonatomic,strong) NSString *singletonEmail;
@property (nonatomic,strong) NSString *singletonStatus;
@property (nonatomic,strong) NSString *singletonToken;
@property (nonatomic,strong) NSString *singletonAddress;
@property (nonatomic,strong) NSString *singletonDob;
@property (nonatomic,strong) NSString *singletonOccupation;
@property (nonatomic,strong) NSString *singletonPurpose;
@property (nonatomic,strong) NSString *singletonNeighbourhoodId;
@property (nonatomic,strong) NSString *singletonInterestOne;
@property (nonatomic,strong) NSString *singletonInterestTwo;
@property (nonatomic,strong) NSString *singletonInterestThree;
@property (nonatomic,strong) NSString *singletonMaritalStatus;
@property (nonatomic,strong) NSString *singletonFamily;
@property (nonatomic,strong) NSString *singletonLivingSince;
@property (nonatomic,strong) NSString *singletonImage;
@property (nonatomic,strong) NSString *singletonSchool;
@property (nonatomic,strong) NSString *singletonCollege;
@property (nonatomic,strong) NSString *singletonWeehiveName;
@property (nonatomic,strong) NSString *singletonOrigin;
@property (nonatomic,strong) NSString *singletonPassword;
@property (nonatomic,strong) NSString *singletonMobile;
@property (nonatomic,strong) NSString *loginToken;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *singletonRegistrationDate;
@property (nonatomic,strong) NSString *singletonIsAddressEntered;
@property (nonatomic,assign) BOOL singletonIsLoggedIn;
@property (nonatomic,assign) int singletonBadge;




+ (id)sharedManager;

@end
