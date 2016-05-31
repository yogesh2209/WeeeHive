//
//  ChatTableViewCell.h
//  test
//
//  Created by iFlyLabs on 06/04/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, aAuthorType) {
    iGroupMessageBubbleTableViewCellAuthorTypeSender = 0,
    iGroupMessageBubbleTableViewCellAuthorTypeReceiver
};

@interface GroupChatTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *achatUserImage;
@property (strong, nonatomic) UILabel *achatNameLabel;
@property (strong, nonatomic) UILabel *achatTimeLabel;
@property (strong, nonatomic) UILabel *achatMessageLabel;
@property (nonatomic, assign) aAuthorType authorType;

@end
