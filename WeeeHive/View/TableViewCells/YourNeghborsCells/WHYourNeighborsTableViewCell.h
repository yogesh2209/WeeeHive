//
//  WHYourNeighborsTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 10/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHYourNeighborsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelOccupation;



@property (weak, nonatomic) IBOutlet UIImageView *imageViewNegPic;

@property (weak, nonatomic) IBOutlet UILabel *labelAge;

@property (strong, nonatomic) IBOutlet UIButton *buttonMessage;

@property (strong, nonatomic) IBOutlet UILabel *labelConnections;


@end
