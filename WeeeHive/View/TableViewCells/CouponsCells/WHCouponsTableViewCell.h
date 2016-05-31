//
//  WHCouponsTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 14/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHCouponsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePic;


@property (weak, nonatomic) IBOutlet UIImageView *imageCoupon;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;


@property (weak, nonatomic) IBOutlet UILabel *labelFlyer;


@end
