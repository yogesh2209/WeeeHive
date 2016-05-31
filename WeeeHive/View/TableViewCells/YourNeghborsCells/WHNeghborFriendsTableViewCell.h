//
//  WHNeghborFriendsTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 07/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNeghborFriendsTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (strong, nonatomic) IBOutlet UILabel *labelOccupation;
@property (strong, nonatomic) IBOutlet UIButton *buttonAddFriend;


@property (strong, nonatomic) IBOutlet UILabel *labelStatus;

@property (strong, nonatomic) IBOutlet UILabel *labelInterests;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelConnections;

@end
