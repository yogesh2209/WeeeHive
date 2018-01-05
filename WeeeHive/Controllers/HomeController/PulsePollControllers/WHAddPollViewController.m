//
//  WHAddPollViewController.m
//  WeeeHive
//
//  Created by Schoofi on 29/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHAddPollViewController.h"
#import "Constant.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "JSONHTTPClient.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

@interface WHAddPollViewController ()<UITextViewDelegate>
{
    
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSString *getQuestion;
     NSString *gettedDeviceId;
    NSString *getCityId;
    NSString *getNeighbourhoodId;
    
    NSString *getFirstName;
    NSString *getLastName;
    NSString *gettedImageString;
    
    NSUserDefaults *defaults;
    
    
}

@property (weak, nonatomic) IBOutlet UITextView *textViewQuestion;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;


@end

@implementation WHAddPollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  customizeUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    
   
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonAddPressed:(id)sender {
    
    if ([self.textViewQuestion.text isEqualToString:@"Write your poll here"] || self.textViewQuestion.text.length==0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"poll cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        
        [self serviceCallingForAddPoll];
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Add Poll";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.buttonAdd.layer.cornerRadius=2.0f;
    self.buttonAdd.layer.masksToBounds=YES;
    self.textViewQuestion.backgroundColor=[UIColor clearColor];
    self.textViewQuestion.layer.cornerRadius=2.0f;
    self.textViewQuestion.layer.masksToBounds=YES;
    self.textViewQuestion.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewQuestion.layer.borderWidth=0.5f;
    self.textViewQuestion.text = @"Write your poll here";
    self.textViewQuestion.textColor = [UIColor lightGrayColor];
    self.textViewQuestion.delegate = self;
}

- (void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager] singletonToken];
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    getFirstName=[[WHSingletonClass sharedManager] singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager] singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager] singletonImage];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    
 
}

#pragma mark  UITextField Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textViewQuestion.textColor == [UIColor lightGrayColor]) {
        self.textViewQuestion.text = @"";
        self.textViewQuestion.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.textViewQuestion.text.length == 0){
        self.textViewQuestion.textColor = [UIColor lightGrayColor];
        self.textViewQuestion.text = @"Write your poll here";
        [self.textViewQuestion resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.textViewQuestion.text.length == 0){
            self.textViewQuestion.textColor = [UIColor lightGrayColor];
            self.textViewQuestion.text = @"Write your poll here";
            [self.textViewQuestion resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

//service calling for adding Poll
- (void) serviceCallingForAddPoll{
    
    getQuestion=self.textViewQuestion.text;
    
   
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"token=%@&u_id=%@&question=%@&device_id=%@&city_id=%@&neg_id=%@&first_name=%@&last_name=%@&image=%@",getToken,getUserId,getQuestion,gettedDeviceId,getCityId,getNeighbourhoodId,getFirstName,getLastName,gettedImageString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDPOLL]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
               
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No record found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Poll submitted successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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
                NSString *string=@"0";
                    [defaults setObject:string forKey:@"LOGGED"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
      
    }
    else if ([messageStatus.Msg isEqualToString:@"1"]){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
