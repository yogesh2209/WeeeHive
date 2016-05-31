//
//  WHMessagesPushTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 02/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHMessagesPushTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;

@property (strong, nonatomic) IBOutlet UILabel *labelDate;

@end
