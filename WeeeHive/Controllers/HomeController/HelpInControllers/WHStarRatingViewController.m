//
//  WHStarRatingViewController.m
//  WeeeHive
//
//  Created by Schoofi on 04/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHStarRatingViewController.h"
#import "RatingView.h"
#import "Constant.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

@interface WHStarRatingViewController ()<RatingViewDelegate>{
    
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    NSString *getUserId;
    NSString *getToken;
    NSString *getRatedPersonId;
    int getRating;
    NSString *gettedDeviceId;
}


@property (weak, nonatomic) IBOutlet UIView *viewCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplay;
@property (strong, nonatomic) RatingView *ratingView;

@end

@implementation WHStarRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    [self getValues];
    self.labelDisplay.text = @"Rate him/her out of 5 stars";
    self.labelDisplay.textColor = [UIColor lightGrayColor];
    self.labelDisplay.numberOfLines = 0;
    self.labelDisplay.textAlignment = NSTextAlignmentCenter;
    self.labelDisplay.font = [UIFont fontWithName:@"Palatino-Italic" size:18];
    RatingView *RV0 = [[RatingView alloc] initWithFrame:CGRectMake(60, 124, self.view.frame.size.width-120, 40)
                                      selectedImageName:@"selected.png"
                                        unSelectedImage:@"unSelected.png"
                                               minValue:0
                                               maxValue:5
                                          intervalValue:1.0
                                             stepByStep:NO];
    RV0.delegate = self;
    RV0.value=0;
    [self.view addSubview:RV0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonCancelPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark RatingView delegate

- (void)rateChanged:(RatingView *)ratingView
{
    getRating=ratingView.value;
    [self serviceCallingForGettingRating];
    
}

- (void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager] singletonToken];
    
}


//service calling for rating
- (void) serviceCallingForGettingRating{
    
    
    getRatedPersonId=self.gettedUserId;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&rating=%d&rated_person_id=%@&device_id=%@",getUserId,getToken,getRating,getRatedPersonId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_RATING]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
           
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Successful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                     
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
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([messageStatus.Msg isEqualToString:@"1"]){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



@end
