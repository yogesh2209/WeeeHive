//
//  WHLoginCodeViewController.m
//  WeeeHive
//
//  Created by Schoofi on 16/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHLoginCodeViewController.h"

//Singleton Class
#import "WHSingletonClass.h"

//Alert Class
#import "ASNetworkAlertClass.h"

//Constant file for URLs
#import "Constant.h"

//Progress View
#import "SVProgressHUD.h"

//Singleton Class
#import "WHSingletonClass.h"

#import "WHLoginModel.h"
#import "WHLoginDetailsModel.h"
#import "WHMessageModel.h"


//JSON Classes
#import "JSONHTTPClient.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHLoginViewController.h"

@interface WHLoginCodeViewController (){
    
    //JSON Object
    WHMessageModel *messageStatus;
    WHTokenErrorModel *tokenStatus;
    WHSingletonClass *sharedObject;
    WHLoginModel *loginData;
    WHLoginDetailsModel *loginInfoModel;
    
    NSUserDefaults *defaults;
    
    NSString *gettedVerificationCode;
    NSString *token;
    NSString *status;
    NSString *getEmail;
    int getTemp;
    NSString *getUserId;
    NSString *gettedDeviceId;
    
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonLogout;
@property (strong, nonatomic) IBOutlet UITextView *textViewMessage;
@property (strong, nonatomic) IBOutlet UIButton *buttonRequestCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldVerificationCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonEnterCode;

@end

@implementation WHLoginCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getValues];
    [self customizeUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager]deviceId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.temp==1) {
         self.navigationItem.hidesBackButton=YES;
    }
    else{
        self.navigationItem.hidesBackButton=NO;
        self.navigationItem.rightBarButtonItem=nil;
    }
    
   
}
//keyboard disappear/appear wherever touch on screen
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Verification Code";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textFieldVerificationCode.backgroundColor=[UIColor clearColor];
    self.textFieldVerificationCode.layer.cornerRadius=2.0f;
    self.textFieldVerificationCode.layer.masksToBounds=YES;
    self.textFieldVerificationCode.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textFieldVerificationCode.layer.borderWidth=0.5f;
    self.textViewMessage.text=@"You were provided temporary access. We have posted Verification code at your address. Please login again to enter the same to ensure permanent access.";
    [self.textViewMessage setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    self.textViewMessage.textColor = [UIColor blackColor];
    
    self.buttonEnterCode.layer.cornerRadius=2.0f;
    self.buttonEnterCode.layer.masksToBounds=YES;
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textFieldVerificationCode) {
        [self.textFieldVerificationCode resignFirstResponder];
    }
    return YES;
}



-(void) getValues{
    
    gettedVerificationCode=[[WHSingletonClass sharedManager] singletonVrfCode];
    getEmail=[[WHSingletonClass sharedManager]singletonEmail];
    token=[[WHSingletonClass sharedManager] singletonToken];
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
}

- (IBAction)buttonEnterCodePressed:(id)sender {
    
    if (self.textFieldVerificationCode.text.length !=0) {
        
        if ([self.textFieldVerificationCode.text isEqualToString:[NSString stringWithFormat:@"%@",gettedVerificationCode]]) {
            status=@"4";
            [self serviceCallingForUpdatingStatus];
        }
        else{
            self.textFieldVerificationCode.text=@"";
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Verification code do not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else{
        self.textFieldVerificationCode.text=@"";
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Textfield cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
}

//service calling for updatingStatus
- (void) serviceCallingForUpdatingStatus{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"email=%@&status=%@&token=%@&user_id=%@&device_id=%@",getEmail,status,token,getUserId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_STATUS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                

                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
        
                 if ([messageStatus.Msg isEqualToString:@"0"]) {
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong,try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([tokenStatus.error isEqualToString:@"0"]){
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong,try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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

                     [self performSegueWithIdentifier:@"codeToHomeSegueVC" sender:nil];
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

//service calling for requesting verification code again
- (void) serviceCallingForRequestingCode{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@",getUserId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_RESENDCODE]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]) {
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong,try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                      [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"We will post you a verification code within 5-7 working days which will need to be entered to get permanent access" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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
    
    if (buttonIndex == 0) {
        sharedObject.singletonIsLoggedIn=0;
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];    }
}
- (IBAction)buttonRequestCodePressed:(id)sender {
    [self serviceCallingForRequestingCode];
}
- (IBAction)barButtonLogoutPressed:(id)sender {
    sharedObject.singletonIsLoggedIn=0;
    NSString *string=@"0";
    [defaults setObject:string forKey:@"LOGGED"];
    [self.navigationController popToRootViewControllerAnimated:YES];}

@end
