//
//  WHWeehiveGroupMembersViewController.h
//  WeeeHive
//
//  Created by Schoofi on 25/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHWeehiveGroupMembersViewController : UIViewController

@property (nonatomic,strong) NSString *getGroupName;
@property (nonatomic,strong) NSString *getGroupId;
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) NSString *createdBy;
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *groupDesc;

//created by person's name
@property (nonatomic,strong) NSString *getFirstName;
@property (nonatomic,strong) NSString *getLastName;

@property (nonatomic,assign) int indicatorJoinGroup;

@property (nonatomic,assign) int getRequestSent;

//get status
@property (nonatomic,strong) NSString *getStatus;


@end
