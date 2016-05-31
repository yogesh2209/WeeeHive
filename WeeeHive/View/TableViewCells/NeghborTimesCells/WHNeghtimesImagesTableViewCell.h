//
//  WHNeghtimesImagesTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 14/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNeghtimesImagesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (strong, nonatomic) IBOutlet UILabel *labelDate;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewtweetImage;

@property (strong, nonatomic) IBOutlet UILabel *labelComment;

@end
