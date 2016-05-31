//
//  ChatTableViewCell.m
//  test
//
//  Created by iFlyLabs on 06/04/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import "GroupChatTableViewCell.h"
#import "GroupChatCellSettings.h"

@interface GroupChatTableViewCell ()

@property (strong, nonatomic) UIView *aBubble;
@property (strong, nonatomic) UIView *aMain;
@property (strong, nonatomic) UIView *aUpCurve;
@property (strong, nonatomic) UIView *aDownCurve;
@property (strong, nonatomic) UIView *aHidingLayerTop;
@property (strong, nonatomic) UIView *aHidingLayerSide;

@end

@implementation GroupChatTableViewCell


@synthesize aBubble;
@synthesize aMain;
@synthesize aUpCurve;
@synthesize aDownCurve;
@synthesize aHidingLayerTop;
@synthesize aHidingLayerSide;
@synthesize achatUserImage;
@synthesize achatNameLabel;
@synthesize achatTimeLabel;
@synthesize achatMessageLabel;

NSLayoutConstraint *aheight;
NSLayoutConstraint *awidth;
NSArray *ahorizontal;
NSArray *avertical;

CGFloat ared;
CGFloat ablue;
CGFloat agreen;

static GroupChatCellSettings *chatCellSettings = nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        chatCellSettings = [GroupChatCellSettings getInstance];
    });
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    aBubble = [[UIView alloc] init];
    
    [aBubble setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    aMain = [[UIView alloc] init];
    
    [aMain setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    aUpCurve = [[UIView alloc] init];
    
    [aUpCurve setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    aDownCurve = [[UIView alloc] init];
    
    [aDownCurve setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    aHidingLayerTop = [[UIView alloc] init];
    
    [aHidingLayerTop setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    aHidingLayerSide = [[UIView alloc] init];
    
    [aHidingLayerSide setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    achatUserImage = [[UIImageView alloc] init];
    
    [achatUserImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    achatNameLabel = [[UILabel alloc] init];
    
    [achatNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    achatTimeLabel = [[UILabel alloc] init];
    
    [achatTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    achatMessageLabel = [[UILabel alloc] init];
    
    [achatMessageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:aBubble];
    
    [aBubble addSubview:aDownCurve];
    [aBubble addSubview:aHidingLayerTop];
    [aBubble addSubview:aMain];
    [aBubble addSubview:aUpCurve];
    [aBubble addSubview:aHidingLayerSide];
    [aBubble addSubview:achatUserImage];
    
    [aMain addSubview:achatNameLabel];
    [aMain addSubview:achatTimeLabel];
    [aMain addSubview:achatMessageLabel];
    
   achatUserImage.image = [UIImage imageNamed:@"defaultUser.png"];
    
    achatNameLabel.text = @"chatNameLabel";
    
    achatTimeLabel.text = @"chatTimeLabel";
    
    achatMessageLabel.text = @"chatMessageLabel";
    
    [achatMessageLabel setNumberOfLines:0];
    [achatNameLabel setNumberOfLines:1];
    [achatTimeLabel setNumberOfLines:1];
    
    achatMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    achatNameLabel.lineBreakMode = NSLineBreakByClipping;
    achatTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    //Common placement of the different views
    
    //Setting constraints for Bubble. It should be at a zero distance from top, bottom and 8 distance right hand side of the superview, i.e., self.contentView (The default superview for all tableview cell elements)
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[aBubble]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aBubble)];
    
    awidth = [NSLayoutConstraint constraintWithItem:aBubble attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:128.0f];
    
    [self.contentView addConstraint:awidth];
    
    
    [self.contentView addConstraints:avertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for Main block. It contains name, message and time labels. Main should be at a zero distance from bottom and left of its superview, i.e., Bubble
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aMain]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aMain)];
    
    [aBubble addConstraints:avertical];
    
    aheight = [NSLayoutConstraint constraintWithItem:aMain attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.0f];
    
    awidth = [NSLayoutConstraint constraintWithItem:aMain attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:38.0f];
    
    
    [aBubble addConstraints:@[aheight,awidth]];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for UpCurve. It should be at zero distance from Main on left side, -1 distance from bottom and 10 distance from right of the superview, i.e., Bubble. Height and Width should be 32 and 20 respectively
    
    aheight = [NSLayoutConstraint constraintWithItem:aUpCurve attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.0f];
    
    awidth = [NSLayoutConstraint constraintWithItem:aUpCurve attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:20.0f];
    
    
    [aBubble addConstraints:@[aheight,awidth]];
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[aUpCurve]-(-1)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aUpCurve)];
    
    [aBubble addConstraints:avertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for DownCurve. It should be at a 0 distance from right and bottom of superview and -20 distance from Main on the left. Its superview is Bubble. The height and width should be 25 and 50 respectively.
    
    aheight = [NSLayoutConstraint constraintWithItem:aDownCurve attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
    
    awidth = [NSLayoutConstraint constraintWithItem:aDownCurve attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:50.0f];
    
    
    [aBubble addConstraints:@[aheight,awidth]];
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aDownCurve]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aDownCurve)];
    
    [aBubble addConstraints:avertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for HidingLayerSide. Superview is Bubble. Right and bottom distances should be 0 and top should be greater than 0. Height and Width are 32 and 15 respectively.
    
    aheight = [NSLayoutConstraint constraintWithItem:aHidingLayerSide attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.0f];
    
    awidth = [NSLayoutConstraint constraintWithItem:aHidingLayerSide attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:15.0f];
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[aHidingLayerSide]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerSide)];
    
    [aBubble addConstraints:@[aheight,awidth]];
    
    [aBubble addConstraints:avertical];
    
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for HidingLayerTop. Superview is Bubble. Right, left and top distances should be 0 and bottom should be 20.
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[aHidingLayerTop]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerTop)];
    
    
    [aBubble addConstraints:avertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for chatUserImage. Its superview is Bubble. It should be at 0 distance from right and bottom of superview and 5 distance from Main. Height and width should be 25 and 25.
    
    aheight = [NSLayoutConstraint constraintWithItem:achatUserImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
    
    awidth = [NSLayoutConstraint constraintWithItem:achatUserImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[achatUserImage]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(achatUserImage)];
    
    [aBubble addConstraints:@[aheight,awidth]];
    
    [aBubble addConstraints:avertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting the constraints for chatNameLabel. It should be at 16 distance from right and left of superview, i.e., Main and 8 distance from top and chatMessageLabel which is at 8 distance from chatTimeLabel which is at 8 distance from bottom of superview.
    
    
    ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[achatNameLabel]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(achatNameLabel)];
    
    
    [aMain addConstraints:ahorizontal];
    
    // ////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting width constraint for chatNameLabel
    
    NSLayoutConstraint *proportionalWidth = [NSLayoutConstraint constraintWithItem:achatNameLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:aMain
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:.5
                                                          constant:0];
    
    proportionalWidth.priority = 750;
    
    
    [aMain addConstraint:proportionalWidth];
    
    [achatNameLabel setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    
    // ////////////////////////////////////////////////////////////////////////////////////////////

    
    //Setting the constraints for chatNameLabel. It should be at 16 distance from right and left of superview, i.e., Main and 8 distance from top and chatMessageLabel which is at 8 distance from chatTimeLabel which is at 8 distance from bottom of superview.
    
    
    
    avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[achatNameLabel]-8-[achatMessageLabel]-8-[achatTimeLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(achatNameLabel,achatMessageLabel,achatTimeLabel)];
    
    [aMain addConstraints:avertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    self.contentView.backgroundColor = [UIColor whiteColor];

    
    aBubble.backgroundColor = [UIColor whiteColor];
    
    aUpCurve.backgroundColor = [UIColor whiteColor];
    
    aHidingLayerTop.backgroundColor = [UIColor whiteColor];
    
    aHidingLayerSide.backgroundColor = [UIColor whiteColor];
    
    achatTimeLabel.textAlignment = NSTextAlignmentRight;
    
    [achatMessageLabel setPreferredMaxLayoutWidth:220.0f];
    
    return self;
}

-(void)layoutSubviews
{
    CGSize size = achatMessageLabel.superview.frame.size;
    [achatMessageLabel setCenter:CGPointMake(size.width/2, size.height/2)];
    
    aMain.layer.cornerRadius = 16.0f;
    aUpCurve.layer.cornerRadius = 10.0f;
    aDownCurve.layer.cornerRadius = 25.0f;
    achatUserImage.layer.cornerRadius = 12.5f;
    achatUserImage.layer.masksToBounds = YES;
}

- (void)updateFramesForAuthorType:(aAuthorType)type
{
    
    if(type == iGroupMessageBubbleTableViewCellAuthorTypeSender)
    {
        //Setting constraints for Bubble. It should be at a zero distance from top, bottom and 8 distance right hand side of the superview, i.e., self.contentView (The default superview for all tableview cell elements)
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aBubble]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aBubble)];
        
        
        [self.contentView addConstraints:ahorizontal];

        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for Main block. It contains name, message and time labels. Main should be at a zero distance from bottom and left of its superview, i.e., Bubble
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[aMain]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aMain)];
        
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for UpCurve. It should be at zero distance from Main on left side, -1 distance from bottom and 10 distance from right of the superview, i.e., Bubble. Height and Width should be 32 and 20 respectively
        
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aMain]-0-[aUpCurve]-10-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aMain,aUpCurve)];
        
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for DownCurve. It should be at a 0 distance from right and bottom of superview and -20 distance from Main on the left. Its superview is Bubble. The height and width should be 25 and 50 respectively.
        
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aMain]-(-20)-[aDownCurve]-(0)-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aMain,aDownCurve)];
        
        [aBubble addConstraints:ahorizontal];

        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for HidingLayerSide. Superview is Bubble. Right and bottom distances should be 0 and top should be greater than 0. Height and Width are 32 and 15 respectively.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aHidingLayerSide]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerSide)];
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for HidingLayerTop. Superview is Bubble. Right, left and top distances should be 0 and bottom should be 20.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[aHidingLayerTop]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerTop)];
        
        
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for chatUserImage. Its superview is Bubble. It should be at 0 distance from right and bottom of superview and 5 distance from Main. Height and width should be 25 and 25.
        
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aMain]-5-[achatUserImage]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aMain,achatUserImage)];
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting the constraints for chatTimeLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[achatTimeLabel]-16-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(achatTimeLabel)];
        
        
        
        [aMain addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting the constraints for chatMessageLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[achatMessageLabel]-16-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(achatMessageLabel)];
        
        [aMain addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        if(![chatCellSettings getGroupSenderBubbleTail])
        {
            [aDownCurve setHidden:YES];
            [aUpCurve setHidden:YES];
        }
        else
        {
            [aDownCurve setHidden:NO];
            [aUpCurve setHidden:NO];
        }
        
        
        aMain.backgroundColor = [chatCellSettings getGroupSenderBubbleColor];
        
        aDownCurve.backgroundColor = [chatCellSettings getGroupSenderBubbleColor];
        
        NSArray *textColor = [chatCellSettings getGroupSenderBubbleTextColor];
        
        achatNameLabel.textColor = textColor[0];
        achatMessageLabel.textColor = textColor[1];
        achatTimeLabel.textColor = textColor[2];
        
        NSArray *fontWithSize = [chatCellSettings getGroupSenderBubbleFontWithSize];
        
        achatNameLabel.font = fontWithSize[0];
        achatMessageLabel.font = fontWithSize[1];
        achatTimeLabel.font = fontWithSize[2];
    }
    else
    {
        //Setting constraints for Bubble. It should be at a zero distance from top, bottom and 8 distance from left hand side of the superview, i.e., self.contentView (The default superview for all tableview cell elements)
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[aBubble]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aBubble)];
        
        
        [self.contentView addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for Main block. It contains name, message and time labels. Main should be at a zero distance from bottom and right of its superview, i.e., Bubble
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[aMain]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aMain)];
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for UpCurve. It should be at zero distance from Main on right side, -1 distance from bottom and 10 distance from left of the superview, i.e., Bubble. Height and Width should be 32 and 20 respectively
        
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[aUpCurve]-0-[aMain]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aUpCurve,aMain)];
        
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for DownCurve. It should be at a 0 distance from left and bottom of superview and -20 distance from Main on the right. Its superview is Bubble. The height and width should be 25 and 50 respectively.
        
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[aDownCurve]-(-20)-[aMain]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aDownCurve,aMain)];
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for HidingLayerSide. Superview is Bubble. Left and bottom distances should be 0 and top should be greater than 0. Height and Width are 32 and 15 respectively.
        
       ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[aHidingLayerSide]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerSide)];
        
        avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[aHidingLayerSide]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerSide)];
        
        
        [aBubble addConstraints:ahorizontal];
        
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for HidingLayerTop. Superview is Bubble. Right, left and top distances should be 0 and bottom should be 20.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[aHidingLayerTop]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(aHidingLayerTop)];
        
        
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for chatUserImage. Its superview is Bubble. It should be at 0 distance from left and bottom of superview and 5 distance from Main on the right. Height and width should be 25 and 25.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[achatUserImage]-5-[aMain]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(achatUserImage,aMain)];
        
        avertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[achatUserImage]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(achatUserImage)];
        
        
        [aBubble addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting the constraints for chatTimeLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[achatTimeLabel]-16-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(achatTimeLabel)];
        
        [aMain addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting the constraints for chatMessageLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        ahorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[achatMessageLabel]-16-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(achatMessageLabel)];
        
        [aMain addConstraints:ahorizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        if(![chatCellSettings getGroupReceiverBubbleTail])
        {
            [aDownCurve setHidden:YES];
            [aUpCurve setHidden:YES];
        }
        else
        {
            [aDownCurve setHidden:NO];
            [aUpCurve setHidden:NO];
        }
        
        aMain.backgroundColor = [chatCellSettings getGroupReceiverBubbleColor];
        
        aDownCurve.backgroundColor = [chatCellSettings getGroupReceiverBubbleColor];
        
        NSArray *textColor = [chatCellSettings getGroupReceiverBubbleTextColor];
        
        achatNameLabel.textColor = textColor[0];
        achatMessageLabel.textColor = textColor[1];
        achatTimeLabel.textColor = textColor[2];
        
        NSArray *fontWithSize = [chatCellSettings getGroupReceiverBubbleFontWithSize];
        
        achatNameLabel.font = fontWithSize[0];
        achatMessageLabel.font = fontWithSize[1];
        achatTimeLabel.font = fontWithSize[2];
    }
}

- (void)setAuthorType:(aAuthorType)type
{
    _authorType = type;
    [self updateFramesForAuthorType:_authorType];
}

@end
