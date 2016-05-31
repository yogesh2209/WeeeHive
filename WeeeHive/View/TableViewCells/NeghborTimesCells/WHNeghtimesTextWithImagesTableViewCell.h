//
//  WHNeghtimesTextWithImagesTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 18/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNeghtimesTextWithImagesTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (strong, nonatomic) IBOutlet UILabel *labelDate;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewTweet;

@property (strong, nonatomic) IBOutlet UILabel *labelTweet;


@end
