//
//  ContentView.m
//  ChatTextView
//
//  Created by iFlyLabs on 06/08/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import "GroupContentView.h"

static CGFloat kDefaultAnimationDuration = 0.5;
static NSInteger kMinimumNumberOfLines = 1;
static NSInteger kMaximumNumberOfLines = 3;

@interface GroupContentView() <UITextViewDelegate>

@property (nonatomic, strong) NSLayoutConstraint *achatTextViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *acontentViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *acontentViewBottomConstraint;
@property (nonatomic, assign) CGFloat ainitialHeight;
@property (nonatomic, assign) CGFloat amaximumHeight;
@property (nonatomic, assign) NSInteger amaximumNumberOfLines;
@property (nonatomic, assign) NSInteger aminimumNumberOfLines;

@end

@implementation GroupContentView

@synthesize achatTextView;

-(id)initWithTextView:(UITextView *)textView ChatTextViewHeightConstraint:(NSLayoutConstraint *)chatTextViewHeightConstraint contentView:(UIView *)contentView ContentViewHeightConstraint:(NSLayoutConstraint *)contentViewHeightConstraint andContentViewBottomConstraint:(NSLayoutConstraint *)contentViewBottomConstraint
{
    self = [super init];
    
    if(self)
    {
        achatTextView = textView;
        
        self.achatTextViewHeightConstraint = chatTextViewHeightConstraint;
        
        self.acontentView = contentView;
        
        self.acontentViewHeightConstraint = contentViewHeightConstraint;
        
        self.acontentViewBottomConstraint = contentViewBottomConstraint;
        
        [self addKeyboardNotificationsObserver];
        
        achatTextView.delegate = self;
        
        [self updateMinimumNumberOfLines:kMinimumNumberOfLines andMaximumNumberOfLine:kMaximumNumberOfLines];
    }
    
    return self;
}

//-(void)textViewDidChange:(UITextView *)textView
//{
//    [self resizeTextViewWithAnimation:NO];
//}

#pragma mark  UITextField Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.achatTextView.textColor == [UIColor lightGrayColor]) {
        self.achatTextView.text = @"";
        self.achatTextView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.achatTextView.text.length == 0){
        self.achatTextView.textColor = [UIColor lightGrayColor];
        self.achatTextView.text = @"type message";
        [self.achatTextView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.achatTextView.text.length == 0){
            self.achatTextView.textColor = [UIColor lightGrayColor];
            self.achatTextView.text = @"type message";
            [self.achatTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}



-(void)updateMinimumNumberOfLines:(NSInteger)minimumNumberOfLines
           andMaximumNumberOfLine:(NSInteger)maximumNumberOfLines
{
    self.aminimumNumberOfLines = minimumNumberOfLines;
    self.amaximumNumberOfLines = maximumNumberOfLines;
    self.aanimationDuration = kDefaultAnimationDuration;
    
    [self updateInitialHeightAndResize];
}

- (void)updateInitialHeightAndResize
{
    //getting initial height
    self.ainitialHeight = [self estimatedInitialHeight];
    self.amaximumHeight = [self estimatedMaximumHeight];
    
    [self resizeTextViewWithAnimation:NO];
}


-(NSInteger)estimatedInitialHeight
{
    CGFloat totalHeight = [self caretHeight] * self.aminimumNumberOfLines + self.achatTextView.textContainerInset.top + self.achatTextView.textContainerInset.bottom;
    //CGFloat totalHeight = [self caretHeight] * self.minimumNumberOfLines;
    //return fmax(totalHeight,self.chatTextView.frame.size.height);
    return totalHeight;
}

- (CGFloat)estimatedMaximumHeight
{
    CGFloat totalHeight = [self caretHeight] * self.amaximumNumberOfLines + self.achatTextView.textContainerInset.top + self.achatTextView.textContainerInset.bottom;
    //CGFloat totalHeight = [self caretHeight] * self.maximumNumberOfLines;
    return totalHeight;
}

- (CGFloat)caretHeight
{
    return [self.achatTextView caretRectForPosition:self.achatTextView.selectedTextRange.end].size.height - 1.5;
}

- (void)resizeTextViewWithAnimation:(BOOL)animated
{
    //get current number of lines
    NSInteger textViewCurrentNumberOfLines = [self currentNumberOfLines];
    
    CGFloat verticalAlignmentConstant = 0.0;
    
    if (textViewCurrentNumberOfLines <= self.aminimumNumberOfLines)
    {
        verticalAlignmentConstant = self.ainitialHeight;
    }
    else if ((textViewCurrentNumberOfLines > self.aminimumNumberOfLines) && (textViewCurrentNumberOfLines <= self.amaximumNumberOfLines))
    {
        CGFloat currentHeight = [self currentHeight];
        
        verticalAlignmentConstant = (currentHeight > self.ainitialHeight) ? currentHeight : self.ainitialHeight;
    }
    else if (textViewCurrentNumberOfLines > self.amaximumNumberOfLines)
    {
        verticalAlignmentConstant = self.amaximumHeight;
    }
    
    if (self.achatTextViewHeightConstraint.constant != verticalAlignmentConstant)
    {
        [self updateVerticalAlignmentWithHeight:verticalAlignmentConstant animated:animated];
    }
    
    if (textViewCurrentNumberOfLines <= self.amaximumNumberOfLines)
    {
        [self.achatTextView setContentOffset:CGPointZero animated:YES];
    }
}

-(NSInteger)currentNumberOfLines
{
    //get height of one line = caret height
    CGFloat caretHeight = [self caretHeight];
    
    //get current height of textView
    CGFloat currentHeight = [self currentHeight];
    
    //CGFloat totalHeight = currentHeight + self.chatTextView.textContainerInset.top + self.chatTextView.textContainerInset.bottom;
    
    CGFloat totalHeight = currentHeight;
    
    NSInteger currentNumberOfLines = (totalHeight/caretHeight);
    
    return currentNumberOfLines;
}

-(CGFloat)currentHeight
{
    CGFloat width = self.achatTextView.bounds.size.width - 2.0 * self.achatTextView.textContainer.lineFragmentPadding;
    CGRect boundingRect = [self.achatTextView.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                            attributes:@{ NSFontAttributeName:self.achatTextView.font}
                                                               context:nil];
    
    CGFloat heightByBoundingRect = CGRectGetHeight(boundingRect);
    
    //CGFloat currentHeight = heightByBoundingRect + self.chatTextView.font.lineHeight;
    
    CGFloat currentHeight = heightByBoundingRect + self.achatTextView.textContainerInset.top + self.achatTextView.textContainerInset.bottom;
    
    return currentHeight;
    
}

- (void)updateVerticalAlignmentWithHeight:(CGFloat)height animated:(BOOL)animated
{
    CGFloat originY = CGRectGetMaxY(self.acontentView.frame) - self.acontentViewHeightConstraint.constant;
    
    CGFloat oldContentViewHeightConstraint = self.acontentViewHeightConstraint.constant;
    
    self.achatTextViewHeightConstraint.constant = height;
    
    self.acontentViewHeightConstraint.constant = height + 16;
    
    CGRect newContentViewFrame = CGRectMake(self.acontentView.frame.origin.x, originY - (self.acontentViewHeightConstraint.constant - oldContentViewHeightConstraint)/2, self.acontentView.frame.size.width, self.acontentView.frame.size.height);
    
    self.acontentView.frame = newContentViewFrame;
    
    
    if (animated == true) {
        [UIView animateWithDuration:kDefaultAnimationDuration
                         animations:^{
                             [self.achatTextView.superview layoutIfNeeded];
                         }
                         completion:nil];
    }
    else {
        [self.achatTextView.superview layoutIfNeeded];
    }
}

- (void)addKeyboardNotificationsObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)handleKeyboardWillShow:(NSNotification *)paramNotification
{
    
    NSDictionary* info = [paramNotification userInfo];
    
    //when switching languages keyboard might change its height (emoji keyboard is higher than most keyboards).
    //You can get both sizes of the previous keyboard and the new one from info dictionary.
    
    // size of the keyb that is about to disappear
    __unused CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // size of the keyb that is about to appear
    CGSize kbSizeNew = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //make adjustments to constraints here...
    
    self.acontentViewBottomConstraint.constant = kbSizeNew.height;
    
    //Magick!
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // work
    [self.achatTextView.superview.superview layoutIfNeeded];
    
    [UIView commitAnimations];
    
}

- (void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    NSDictionary* info = [paramNotification userInfo];
    
    //adjust constraints
    
    self.acontentViewBottomConstraint.constant = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // work
    [self.achatTextView.superview.superview layoutIfNeeded];
    
    [UIView commitAnimations];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
