//
//  WHCouponsListCollectionViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 12/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHCouponsListCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageViewCoupon;

@property (strong, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelText;
@end
