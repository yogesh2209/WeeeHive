//
//  WHForgotPassThreeViewController.m
//  WeeeHive
//
//  Created by Schoofi on 19/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHForgotPassThreeViewController.h"
#import "WHSingletonClass.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "JSONHTTPClient.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

#import "WHLoginModel.h"
#import "WHLoginDetailsModel.h"
#import "WHMessageModel.h"

@interface WHForgotPassThreeViewController (){
 
    //JSON Objects
    WHLoginModel *loginData;
    WHLoginDetailsModel *loginInfoModel;
    WHSingletonClass *sharedObject;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    NSString *getUserId;
    NSString *getToken;
    NSString *getPassword;
     NSString *gettedDeviceId;
    NSUserDefaults *defaults;
    
}

@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmPassword;

@end

@implementation WHForgotPassThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//keyboard disappear/appear wherever touch on screen
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textFieldPassword) {
        [self.textFieldConfirmPassword becomeFirstResponder];
    } else if (theTextField == self.textFieldConfirmPassword) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Forgot Password";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewPassword.backgroundColor=[UIColor clearColor];
    self.viewPassword.layer.cornerRadius=2.0f;
    self.viewPassword.layer.masksToBounds=YES;
    self.viewPassword.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewPassword.layer.borderWidth=0.5f;
    
    self.viewConfirmPassword.backgroundColor=[UIColor clearColor];
    self.viewConfirmPassword.layer.cornerRadius=2.0f;
    self.viewConfirmPassword.layer.masksToBounds=YES;
    self.viewConfirmPassword.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewConfirmPassword.layer.borderWidth=0.5f;
    
    self.textFieldPassword.backgroundColor=[UIColor clearColor];
    self.textFieldPassword.layer.borderColor=[UIColor clearColor].CGColor;
    
    self.textFieldConfirmPassword.backgroundColor=[UIColor clearColor];
    self.textFieldConfirmPassword.layer.borderColor=[UIColor clearColor].CGColor;
    
    self.buttonDone.layer.cornerRadius=2.0f;
    self.buttonDone.layer.masksToBounds=YES;
}

-(void)getValues{
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
}

//service calling for updating password
- (void) serviceCallingForUpdatingPassword{
    
    [self getTextfieldValue];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&token=%@&pass=%@&device_id=%@" ,getUserId,getToken,getPassword,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_UPDATEPASSWORD]
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
                 else{
                     loginData=[[WHLoginModel alloc]initWithDictionary:json error:&err];
                     for (WHLoginDetailsModel *each in loginData.user_Details) {
                         
                         sharedObject.singletonEmail=each.email;
                         sharedObject.singletonVrfCode=each.verification_code;
                         sharedObject.singletonStatus=each.status;
                         sharedObject.singletonFirstName=each.first_name;
                         sharedObject.singletonLastName=each.last_name;
                         sharedObject.singletonUserId=each.id;
                         sharedObject.singletonToken=each.token;
                         sharedObject.singletonLocality=each.locality;
                         sharedObject.singletonPinCode=each.pincode;
                         sharedObject.singletonState=each.state;
                         sharedObject.singletonCity=each.city;
                         sharedObject.singletonAddress=each.address;
                         sharedObject.singletonDob=each.dob;
                         sharedObject.singletonOccupation=each.occupation;
                         sharedObject.singletonImage=each.image;
                         sharedObject.singletonMobile=each.mobile;
                         sharedObject.singletonWeehiveName=each.weehives_name;
                         sharedObject.singletonInterestOne=each.interest1;
                         sharedObject.singletonInterestTwo=each.interest2;
                         sharedObject.singletonInterestThree=each.interest3;
                         sharedObject.singletonRegistrationDate=each.date;
                     }

                     [self performSegueWithIdentifier:@"passToHomeSegueVC" sender:nil];
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

-(void)getTextfieldValue{
    
    getPassword=self.textFieldPassword.text;
}

- (IBAction)buttonDonePressed:(id)sender {
    
    if (self.textFieldPassword.text.length!=0 && self.textFieldConfirmPassword.text.length!=0) {
        
        if ([self.textFieldPassword.text isEqualToString:[NSString stringWithFormat:@"%@",self.textFieldConfirmPassword.text]]) {
            
            [self serviceCallingForUpdatingPassword];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Passwords do not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else{
      [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Textfields cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if ([tokenStatus.error isEqualToString:@"0"]) {
            NSString *string=@"0";
            [defaults setObject:string forKey:@"LOGGED"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    }
}
@end
