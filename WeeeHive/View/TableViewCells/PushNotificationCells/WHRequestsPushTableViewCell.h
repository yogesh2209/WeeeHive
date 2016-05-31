//
//  WHRequestsPushTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 02/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHRequestsPushTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;

@property (strong, nonatomic) IBOutlet UIButton *buttonAccept;

@property (strong, nonatomic) IBOutlet UIButton *buttonIgnore;



@end
