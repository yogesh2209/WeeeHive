//
//  WHNeghborTimesCollectionViewCell.h
//  WeeeHive
//
//  Created by Schoofi on 10/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNeghborTimesCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *labelName;


@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UITextView *textViewStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePic;


@property (weak, nonatomic) IBOutlet UILabel *labelStatus;


@property (weak, nonatomic) IBOutlet UILabel *labelComments;


@end
