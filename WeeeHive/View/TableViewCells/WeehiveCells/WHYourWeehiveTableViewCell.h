//
//  WHYourWeehiveTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHYourWeehiveTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfile;


@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelCountNeighbors;
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;

@property (strong, nonatomic) IBOutlet UIButton *buttonRequest;

@property (strong, nonatomic) IBOutlet UILabel *labelDesc;

@end
