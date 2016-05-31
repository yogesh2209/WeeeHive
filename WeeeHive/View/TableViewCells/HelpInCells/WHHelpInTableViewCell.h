//
//  WHHelpInTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 19/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHHelpInTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelOccupation;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;

@property (weak, nonatomic) IBOutlet UIButton *buttonCall;
@property (weak, nonatomic) IBOutlet UILabel *labelRating;
@property (strong, nonatomic) IBOutlet UILabel *labelHelpInAs;

@end
