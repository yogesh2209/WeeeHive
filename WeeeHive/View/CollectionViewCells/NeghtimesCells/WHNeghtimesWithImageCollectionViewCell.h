//
//  WHNeghtimesWithImageCollectionViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 09/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WHNeghtimesWithImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTweetPic;
@property (strong, nonatomic) IBOutlet UILabel *labelComments;


@end
