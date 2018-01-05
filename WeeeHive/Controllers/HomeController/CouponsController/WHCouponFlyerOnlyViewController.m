//
//  WHCouponFlyerOnlyViewController.m
//  WeeeHive
//
//  Created by Schoofi on 03/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHCouponFlyerOnlyViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"

@interface WHCouponFlyerOnlyViewController (){
    
    WHMessageModel *messageStatus;
    
    NSString *getUserId;
    NSString *getFirstName;
    NSString *getLastName;
    NSString *tableName;
    NSString *getName;
    NSString *gettedContentId;
}

@property (weak, nonatomic) IBOutlet UITextView *textViewFlyer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonReport;

@end

@implementation WHCouponFlyerOnlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    gettedContentId=[NSString stringWithFormat:@"Coupon Id : %@",self.getContentId];
    self.textViewFlyer.text=self.getText;
}

- (void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getFirstName=[[WHSingletonClass sharedManager] singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager] singletonLastName];
    tableName=@"Table Name: flyers_coupon";
    getName=[NSString stringWithFormat:@"%@ %@",getFirstName,getLastName];
    [self.textViewFlyer setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.textViewFlyer.textColor = [UIColor blackColor];
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Coupon";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textViewFlyer.backgroundColor=[UIColor clearColor];
    self.textViewFlyer.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewFlyer.layer.borderWidth=0.5f;
    self.textViewFlyer.layer.cornerRadius=2.0f;
    self.textViewFlyer.layer.masksToBounds=YES;
}


- (IBAction)barButtonReportPressed:(id)sender {
    
     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to report this content as inappropriate?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil]show];
}

//service calling for reporting content as inappropriate
- (void) serviceCallingForReportingContent{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&u_name=%@&table_name=%@&content_id=%@",getUserId,getName,tableName,gettedContentId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_REPORT_CONTENT]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
         
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                  if ([messageStatus.Msg isEqualToString:@"0"]){
                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                  else if ([messageStatus.Msg isEqualToString:@"1"]){
                      [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your response has been received! Thank you for the same!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                      
                  }
                 else{
                    
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     // Hide Progress bar.
                     [SVProgressHUD dismiss];
                 });
                 
             }];
            
        });
        
    }
    
    
    else {
        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
    }
    
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        
        [self serviceCallingForReportingContent];
    }
    
}

@end
