//
//  WHNeighborKnowDetailsViewController.h
//  WeeeHive
//
//  Created by Schoofi on 06/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondDelegate <NSObject>

-(void)sendDataToA:(NSString *)indicatorValue; // to indicate that this screen has come from search bar detail screen.

@end

@interface WHNeighborKnowDetailsViewController : UIViewController


@property(nonatomic,assign)id delegate;

@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *purpose;
@property (nonatomic,strong) NSString *occupation;
@property (nonatomic,strong) NSString *livingSince;
@property (nonatomic,strong) NSString *morningAct;
@property (nonatomic,strong) NSString *weekendAct;
@property (nonatomic,strong) NSString *eveningAct;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *help;
@property (nonatomic,strong) NSString *maritalStatus;
@property (nonatomic,strong) UIImage *getImage;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *friendUserId;

@property (nonatomic,strong) NSString *getOriginCity;
@property (nonatomic,strong) NSString *getOrigin;
@property (nonatomic,strong) NSString *getSchool;
@property (nonatomic,strong) NSString *getCollege;
@property (nonatomic,strong) NSString *getWorkInterest;
@property (nonatomic,strong) NSString *getSpeciality;
@property (nonatomic,strong) NSString *getWeehiveName;

@property(nonatomic,strong) NSString *getIndicator; // to indicate that screen is coming from search bar list or normal list.

@end
