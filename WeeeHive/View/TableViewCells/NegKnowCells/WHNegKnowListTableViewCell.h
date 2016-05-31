//
//  WHNegKnowListTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 27/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNegKnowListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelOccupation;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelInterests;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNegPic;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddFriend;


@property (strong, nonatomic) IBOutlet UILabel *labelConections;

@property (strong, nonatomic) IBOutlet UILabel *labelIndicatorStatus;

@end
