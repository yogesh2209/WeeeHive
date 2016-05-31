//
//  ChatCellSettings.h
//  iFlyChatChatView
//
//  Created by iFlyLabs on 27/08/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GroupChatCellSettings : NSObject

+(GroupChatCellSettings *)getInstance;

-(void) setGroupSenderBubbleColor:(UIColor *)color;
-(void) setGroupReceiverBubbleColor:(UIColor *)color;
-(void) setGroupSenderBubbleNameTextColor:(UIColor *)color;
-(void) setGroupReceiverBubbleNameTextColor:(UIColor *)color;
-(void) setGroupSenderBubbleMessageTextColor:(UIColor *)color;
-(void) setGroupReceiverBubbleMessageTextColor:(UIColor *)color;
-(void) setGroupSenderBubbleTimeTextColor:(UIColor *)color;
-(void) setGroupReceiverBubbleTimeTextColor:(UIColor *)color;
-(void) setGroupSenderBubbleColorHex:(NSString *)HexColor;
-(void) setGroupReceiverBubbleColorHex:(NSString *)HexColor;
-(void) setGroupSenderBubbleNameTextColorHex:(NSString *)HexColor;
-(void) setGroupReceiverBubbleNameTextColorHex:(NSString *)HexColor;
-(void) setGroupSenderBubbleMessageTextColorHex:(NSString *)HexColor;
-(void) setGroupReceiverBubbleMessageTextColorHex:(NSString *)HexColor;
-(void) setGroupSenderBubbleTimeTextColorHex:(NSString *)HexColor;
-(void) setGroupReceiverBubbleTimeTextColorHex:(NSString *)HexColor;
-(void) setGroupSenderBubbleFontWithSizeForName:(UIFont *)nameFont;
-(void) setGroupReceiverBubbleFontWithSizeForName:(UIFont *)nameFont;
-(void) setGroupSenderBubbleFontWithSizeForMessage:(UIFont *)messageFont;
-(void) setGroupReceiverBubbleFontWithSizeForMessage:(UIFont *)messageFont;
-(void) setGroupSenderBubbleFontWithSizeForTime:(UIFont *)timeFont;
-(void) setGroupReceiverBubbleFontWithSizeForTime:(UIFont *)timeFont;
-(void) senderGroupBubbleTailRequired:(BOOL)isRequiredOrNot;
-(void) receiverGroupBubbleTailRequired:(BOOL)isRequiredOrNot;
-(UIColor *) getGroupSenderBubbleColor;
-(UIColor *) getGroupReceiverBubbleColor;
-(NSArray *) getGroupSenderBubbleTextColor;
-(NSArray *) getGroupReceiverBubbleTextColor;
-(NSArray *) getGroupSenderBubbleFontWithSize;
-(NSArray *) getGroupReceiverBubbleFontWithSize;
-(BOOL) getGroupSenderBubbleTail;
-(BOOL) getGroupReceiverBubbleTail;

@end
