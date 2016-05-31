//
//  ChatCellSettings.m
//  iFlyChatChatView
//
//  Created by iFlyLabs on 27/08/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import "GroupChatCellSettings.h"

@interface UIColor(HexString)

+ (CGFloat) colorGroupComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end


@implementation UIColor(HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorGroupComponentFrom: colorString start: 0 length: 1];
            green = [self colorGroupComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorGroupComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorGroupComponentFrom: colorString start: 0 length: 1];
            red   = [self colorGroupComponentFrom: colorString start: 1 length: 1];
            green = [self colorGroupComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorGroupComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorGroupComponentFrom: colorString start: 0 length: 2];
            green = [self colorGroupComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorGroupComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorGroupComponentFrom: colorString start: 0 length: 2];
            red   = [self colorGroupComponentFrom: colorString start: 2 length: 2];
            green = [self colorGroupComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorGroupComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorGroupComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return (CGFloat)hexComponent/255.0f;
}

@end


@implementation GroupChatCellSettings

UIColor *senderGroupBubbleColor;

UIColor *receiverGroupBubbleColor;

BOOL senderGroupBubbleTail;
BOOL receiverGroupBubbleTail;

UIColor *senderGroupBubbleNameTextColor;

UIColor *receiverGroupBubbleNameTextColor;

UIColor *senderGroupBubbleMessageTextColor;

UIColor *receiverGroupBubbleMessageTextColor;

UIColor *senderGroupBubbleTimeTextColor;

UIColor *receiverGroupBubbleTimeTextColor;

UIFont *senderGroupBubbleNameFontWithSize;
UIFont *senderGroupBubbleMessageFontWithSize;
UIFont *senderGroupBubbleTimeFontWithSize;

UIFont *receiverGroupBubbleNameFontWithSize;
UIFont *receiverGroupBubbleMessageFontWithSize;
UIFont *receiverGroupBubbleTimeFontWithSize;

//Singleton instance
static GroupChatCellSettings *instance = nil;


+(GroupChatCellSettings *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        senderGroupBubbleColor = [UIColor colorWithRed:0 green:(122.0f/255.0f) blue:1.0f alpha:1.0f];
        
        receiverGroupBubbleColor = [UIColor colorWithRed:(223.0f/255.0f) green:(222.0f/255.0f) blue:(229.0f/255.0f) alpha:1.0f];
        
        senderGroupBubbleNameTextColor = [UIColor colorWithRed:(255.0f/255.0f) green:(255.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f];
        
        receiverGroupBubbleNameTextColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
        
        senderGroupBubbleMessageTextColor = [UIColor colorWithRed:(255.0f/255.0f) green:(255.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f];
        
        receiverGroupBubbleMessageTextColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
        
        senderGroupBubbleTimeTextColor = [UIColor colorWithRed:(255.0f/255.0f) green:(255.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f];
        
        receiverGroupBubbleTimeTextColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
        
        senderGroupBubbleNameFontWithSize = [UIFont boldSystemFontOfSize:11];
        senderGroupBubbleMessageFontWithSize = [UIFont systemFontOfSize:14];
        senderGroupBubbleTimeFontWithSize = [UIFont systemFontOfSize:11];
        
        receiverGroupBubbleNameFontWithSize = [UIFont boldSystemFontOfSize:11];
        receiverGroupBubbleMessageFontWithSize = [UIFont systemFontOfSize:14];
        receiverGroupBubbleTimeFontWithSize = [UIFont systemFontOfSize:11];
        
        senderGroupBubbleTail = YES;
        
        receiverGroupBubbleTail = YES;
    });
    
    return instance;
}

-(void) setGroupSenderBubbleColor:(UIColor *)color
{
    senderGroupBubbleColor = color;
}

-(void) setGroupReceiverBubbleColor:(UIColor *)color
{
    receiverGroupBubbleColor = color;
}

-(void) setGroupSenderBubbleNameTextColor:(UIColor *)color
{
    senderGroupBubbleNameTextColor = color;
}

-(void) setGroupReceiverBubbleNameTextColor:(UIColor *)color
{
    receiverGroupBubbleNameTextColor = color;
}

-(void) setGroupSenderBubbleMessageTextColor:(UIColor *)color
{
    senderGroupBubbleMessageTextColor = color;
}

-(void) setGroupReceiverBubbleMessageTextColor:(UIColor *)color
{
    receiverGroupBubbleMessageTextColor = color;
}

-(void) setGroupSenderBubbleTimeTextColor:(UIColor *)color
{
    senderGroupBubbleTimeTextColor = color;
}

-(void) setGroupReceiverBubbleTimeTextColor:(UIColor *)color
{
    receiverGroupBubbleTimeTextColor = color;
}

-(void) setGroupSenderBubbleColorHex:(NSString *)HexColor
{
    [self setGroupSenderBubbleColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupReceiverBubbleColorHex:(NSString *)HexColor
{
    [self setGroupReceiverBubbleColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupSenderBubbleNameTextColorHex:(NSString *)HexColor
{
    [self setGroupSenderBubbleNameTextColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupReceiverBubbleNameTextColorHex:(NSString *)HexColor
{
    [self setGroupReceiverBubbleNameTextColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupSenderBubbleMessageTextColorHex:(NSString *)HexColor
{
    [self setGroupSenderBubbleMessageTextColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupReceiverBubbleMessageTextColorHex:(NSString *)HexColor
{
    [self setGroupReceiverBubbleMessageTextColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupSenderBubbleTimeTextColorHex:(NSString *)HexColor
{
    [self setGroupSenderBubbleTimeTextColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupReceiverBubbleTimeTextColorHex:(NSString *)HexColor
{
    [self setGroupReceiverBubbleTimeTextColor:[UIColor colorWithHexString:HexColor]];
}

-(void) setGroupSenderBubbleFontWithSizeForName:(UIFont *)nameFont
{
    senderGroupBubbleNameFontWithSize = nameFont;
}

-(void) setGroupReceiverBubbleFontWithSizeForName:(UIFont *)nameFont
{
    receiverGroupBubbleNameFontWithSize = nameFont;
}

-(void) setGroupSenderBubbleFontWithSizeForMessage:(UIFont *)messageFont
{
    senderGroupBubbleMessageFontWithSize = messageFont;
}

-(void) setGroupReceiverBubbleFontWithSizeForMessage:(UIFont *)messageFont
{
    receiverGroupBubbleMessageFontWithSize = messageFont;
}

-(void) setGroupSenderBubbleFontWithSizeForTime:(UIFont *)timeFont
{
    senderGroupBubbleTimeFontWithSize = timeFont;
}

-(void) setGroupReceiverBubbleFontWithSizeForTime:(UIFont *)timeFont
{
    receiverGroupBubbleTimeFontWithSize = timeFont;
}

-(void) senderGroupBubbleTailRequired:(BOOL)isRequiredOrNot
{
    senderGroupBubbleTail = isRequiredOrNot;
}

-(void) receiverGroupBubbleTailRequired:(BOOL)isRequiredOrNot
{
    receiverGroupBubbleTail = isRequiredOrNot;
}

-(UIColor *) getGroupSenderBubbleColor
{
    return senderGroupBubbleColor;
}

-(UIColor *) getGroupReceiverBubbleColor
{
    return receiverGroupBubbleColor;
}

-(NSArray *) getGroupSenderBubbleTextColor
{
    return @[senderGroupBubbleNameTextColor,senderGroupBubbleMessageTextColor,senderGroupBubbleTimeTextColor];
}

-(NSArray *) getGroupReceiverBubbleTextColor
{
    return @[receiverGroupBubbleNameTextColor,receiverGroupBubbleMessageTextColor,receiverGroupBubbleTimeTextColor];
}

-(NSArray *) getGroupSenderBubbleFontWithSize
{
    return @[senderGroupBubbleNameFontWithSize,senderGroupBubbleMessageFontWithSize,senderGroupBubbleTimeFontWithSize];
}

-(NSArray *) getGroupReceiverBubbleFontWithSize
{
    return @[receiverGroupBubbleNameFontWithSize,receiverGroupBubbleMessageFontWithSize,receiverGroupBubbleTimeFontWithSize];
}

-(BOOL) getGroupSenderBubbleTail
{
    return senderGroupBubbleTail;
}

-(BOOL) getGroupReceiverBubbleTail
{
    return receiverGroupBubbleTail;
}


@end
