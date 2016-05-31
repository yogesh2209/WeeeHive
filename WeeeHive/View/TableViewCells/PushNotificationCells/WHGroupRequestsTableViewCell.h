//
//  WHGroupRequestsTableViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 10/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHGroupRequestsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageViewGroupPicture;



@property (strong, nonatomic) IBOutlet UILabel *labelLine;

@property (strong, nonatomic) IBOutlet UIButton *buttonAccept;



@property (strong, nonatomic) IBOutlet UIButton *buttonIgnore;


@end
