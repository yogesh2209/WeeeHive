//
//  WHPollListTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHPollListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *labelQuestion;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalVotes;

@property (weak, nonatomic) IBOutlet UILabel *labelLikeVote;

@property (weak, nonatomic) IBOutlet UILabel *labelDislike;


@property (weak, nonatomic) IBOutlet UIButton *buttonDisLike;

@property (weak, nonatomic) IBOutlet UIButton *buttonLike;

@property (strong, nonatomic) IBOutlet UIButton *buttonReport;


@end
