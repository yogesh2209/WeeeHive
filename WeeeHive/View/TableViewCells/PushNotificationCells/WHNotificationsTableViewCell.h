//
//  WHNotificationsTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 02/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNotificationsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelHeading;

@property (strong, nonatomic) IBOutlet UIImageView *imageMain;


@property (strong, nonatomic) IBOutlet UILabel *labelDate;


@end
