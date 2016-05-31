//
//  WHWeehiveDetailsViewController.h
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WHWeehiveDetailsViewController : UIViewController


@property (nonatomic,strong) NSString *getGroupName;
@property (nonatomic,strong) NSString *getGroupId;
@property (nonatomic,strong) NSString *getImagePath;
@property (nonatomic,strong) NSString *getCreatedBy;
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *groupDesc;


//created by person's name
@property (nonatomic,strong) NSString *getFirstName;
@property (nonatomic,strong) NSString *getLastName;




@end
