//
//  WHEditCredentialsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 29/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHEditCredentialsViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"



@interface WHEditCredentialsViewController (){
    
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSString *getMobile;
    NSString *getCurrentPswd;
    NSString *getNewPswd;
    NSString *getConfirmPswd;
    NSString *gettedDeviceId;
 
    int value;
    NSUserDefaults *defaults;
    
    
}

@property (weak, nonatomic) IBOutlet UIView *viewMobile;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMobile;
@property (weak, nonatomic) IBOutlet UIView *viewNewPswd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPswd;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmPswd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPswd;
@property (weak, nonatomic) IBOutlet UIView *viewCurrentPswd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrentPswd;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;

@end

@implementation WHEditCredentialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getValues];
    [self customiseUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonSubmitPressed:(id)sender {
    
    [self getTextfieldValues];
    
    if ([self.textFieldNewPswd.text isEqualToString:[NSString stringWithFormat:@"%@",self.textFieldConfirmPswd.text]]) {
        
        if (self.textFieldCurrentPswd.text.length!=0) {
            
            if ([self.textFieldMobile.text isEqualToString:[NSString stringWithFormat:@"%@",[[WHSingletonClass sharedManager]singletonMobile]]]) {
                //code when phone is not changed
                
                if (self.textFieldNewPswd.text.length==0 && self.textFieldConfirmPswd.text.length==0) {
                    //code when nothing is changed
                    //no service hit in this
                }
                else{
                    //code when password is changed
                    value=2;
                    [self serviceCallingForEditingCredentials];
                }
                
            }
            else{
                //code when phone is changed
                if (self.textFieldNewPswd.text.length==0 && self.textFieldConfirmPswd.text.length==0) {
                    //code when phone is changed but password is not
                    value=1;
                    [self serviceCallingForEditingCredentials];
                }
                else{
                    //code when both are changed
                    value=3;
                    [self serviceCallingForEditingCredentials];
                }
                
                
            }
            
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Current password cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"New password and confirm password does not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }
}

-(void)customiseUI{
    
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Edit Credentials";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewConfirmPswd.layer.cornerRadius=2.0f;
    self.viewConfirmPswd.layer.masksToBounds=YES;
    self.viewConfirmPswd.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewConfirmPswd.layer.borderWidth=0.5f;
    self.viewConfirmPswd.backgroundColor=[UIColor clearColor];
    self.viewCurrentPswd.layer.cornerRadius=2.0f;
    self.viewCurrentPswd.layer.masksToBounds=YES;
    self.viewCurrentPswd.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCurrentPswd.layer.borderWidth=0.5f;
    self.viewCurrentPswd.backgroundColor=[UIColor clearColor];
    self.viewMobile.layer.cornerRadius=2.0f;
    self.viewMobile.layer.masksToBounds=YES;
    self.viewMobile.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewMobile.layer.borderWidth=0.5f;
    self.viewMobile.backgroundColor=[UIColor clearColor];
    self.viewNewPswd.layer.cornerRadius=2.0f;
    self.viewNewPswd.layer.masksToBounds=YES;
    self.viewNewPswd.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewNewPswd.layer.borderWidth=0.5f;
    self.viewNewPswd.backgroundColor=[UIColor clearColor];
    self.textFieldConfirmPswd.backgroundColor=[UIColor clearColor];
    self.textFieldConfirmPswd.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldCurrentPswd.backgroundColor=[UIColor clearColor];
    self.textFieldCurrentPswd.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldMobile.backgroundColor=[UIColor clearColor];
    self.textFieldMobile.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldNewPswd.backgroundColor=[UIColor clearColor];
    self.textFieldNewPswd.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSubmit.layer.cornerRadius=2.0f;
    self.buttonSubmit.layer.masksToBounds=YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
  
    self.textFieldMobile.text=[[WHSingletonClass sharedManager] singletonMobile];
}

- (void) getTextfieldValues{
    
    getMobile=self.textFieldMobile.text;
    getCurrentPswd=self.textFieldCurrentPswd.text;
    getNewPswd=self.textFieldNewPswd.text;
    getConfirmPswd=self.textFieldConfirmPswd.text;
}

//service calling for editing credentials
- (void) serviceCallingForEditingCredentials{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&phone=%@&psw=%@&crr_psw=%@&device_id=%@&value=%d",getUserId,getToken,getMobile,getNewPswd,getCurrentPswd,gettedDeviceId,value]                                                                                                                                                                                                                       ;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_EDITCREDENTIALS]
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
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Credentials updated successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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
            sharedObject.singletonIsLoggedIn=0;
  
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
