//
//  WHHelpViewController.m
//  WeeeHive
//
//  Created by Schoofi on 16/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHHelpViewController.h"
#import "Constant.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"


@interface WHHelpViewController ()<UITextViewDelegate>
{
    
    NSString *getUserId;
    NSString *getToken;
    NSString *getMessage;
    NSString *getEmail;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    NSString *deviceId;
    NSString *getEmailId;
}

@property (strong, nonatomic) IBOutlet UIView *viewEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextView *textViewMessage;
@property (strong, nonatomic) IBOutlet UIButton *buttonSubmit;

@end

@implementation WHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseUI];
    [self getvalues];
    deviceId=[[WHSingletonClass sharedManager] deviceId];
    self.textViewMessage.text = @"Write your message here";
    self.textViewMessage.textColor = [UIColor lightGrayColor];
    self.textViewMessage.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customiseUI{

        UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.text =@"Help";
        titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
        titleView.textColor = [UIColor blackColor];
        titleView.tintColor=[UIColor blackColor];
        // Your color here
        self.navigationItem.titleView = titleView;
        [titleView sizeToFit];
  
    self.viewEmail.backgroundColor=[UIColor clearColor];
    self.viewEmail.layer.cornerRadius=2.0f;
    self.viewEmail.layer.masksToBounds=YES;
    self.viewEmail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewEmail.layer.borderWidth=0.5f;
    self.textFieldEmail.backgroundColor=[UIColor clearColor];
    self.textFieldEmail.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSubmit.layer.cornerRadius=2.0f;
    self.buttonSubmit.layer.masksToBounds=YES;
    self.textViewMessage.backgroundColor=[UIColor clearColor];
    self.textViewMessage.layer.cornerRadius=2.0f;
    self.textViewMessage.layer.masksToBounds=YES;
    self.textViewMessage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewMessage.layer.borderWidth=0.5f;
    
}
#pragma mark  UITextField Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textViewMessage.textColor == [UIColor lightGrayColor]) {
        self.textViewMessage.text = @"";
        self.textViewMessage.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.textViewMessage.text.length == 0){
        self.textViewMessage.textColor = [UIColor lightGrayColor];
        self.textViewMessage.text = @"Write your message here";
        [self.textViewMessage resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.textViewMessage.text.length == 0){
            self.textViewMessage.textColor = [UIColor lightGrayColor];
            self.textViewMessage.text = @"Write your message here";
            [self.textViewMessage resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}


- (void) getvalues{
    
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getToken=[[WHSingletonClass sharedManager] singletonToken];
    getEmail=[[WHSingletonClass sharedManager] singletonEmail];
    self.textFieldEmail.text=getEmail;
}


- (IBAction)buttonSubmitPressed:(id)sender {
    if (self.textFieldEmail.text.length!=0 && self.textViewMessage.text.length!=0) {
        
        if ([self.textViewMessage.text isEqualToString:@"Write your message here"]) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Message cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else {
            [self serviceCallingForSubmittingFeedback];
        }
        
        
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Textfield cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

//service calling for submitting feedback
- (void) serviceCallingForSubmittingFeedback{
    
    getEmail=self.textFieldEmail.text;
    getMessage=self.textViewMessage.text;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&token=%@&email=%@&message=%@&device_id=%@",getUserId,getToken,getEmail,getMessage,deviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_CONTACTUS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
              
                 NSLog(@"%@",json);
               
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Thankyou for your feedback! We will get back to you soon!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else{
                     
                     
                 }
                 
                 
                 // Hide Progress bar.
                 [SVProgressHUD dismiss];
                 
                 
             }];
            
        });
        
    }
    
    
    else {
        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
    }
    
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        if (buttonIndex == 0) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if ([messageStatus.Msg isEqualToString:@"1"]){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
