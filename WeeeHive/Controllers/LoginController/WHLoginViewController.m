//
//  WHLoginViewController.m
//  WeeeHive
//
//  Created by Schoofi on 16/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHLoginViewController.h"

//Alert Class
#import "ASNetworkAlertClass.h"

//Constant file for URLs
#import "Constant.h"

//Progress View
#import "SVProgressHUD.h"

//Singleton Class
#import "WHSingletonClass.h"

//JSON Classes
#import "JSONHTTPClient.h"
#import "WHLoginModel.h"
#import "WHLoginDetailsModel.h"
#import "WHMessageModel.h"
#import "WHLoginCodeViewController.h"
#import "WHUpdateAddressViewController.h"

#import "WHHomeViewController.h"


@interface WHLoginViewController (){
    
    //JSON Objects
    WHLoginModel *loginData;
    WHLoginDetailsModel *loginInfoModel;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getDeviceId;
    NSString *getEmail;
    NSString *getPassword;
    NSString *gettedDeviceId;
    NSString *iphoneIndicator;
    
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoinNow;

@end

@implementation WHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObject=[WHSingletonClass sharedManager];
    [self customiseUI];
    defaults = [NSUserDefaults standardUserDefaults];
    self.textFieldEmail.text=[defaults objectForKey:@"EMAIL"];
    self.textFieldPassword.text=[defaults objectForKey:@"PASSWORD"];
    gettedDeviceId=[defaults objectForKey:@"DEVICE"];
    getDeviceId=[defaults objectForKey:@"TOKEN"];
    
    
//    if (self.textFieldEmail.text.length==0 || self.textFieldPassword.text.length==0 || getDeviceId.length==0) {
//        
//    }
//    else if ([[[WHSingletonClass sharedManager] loginToken] isEqualToString:@"1"]){
//        
//    }
//    else{
//        
//        [self serviceCallingForLogin];
//    }
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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void) customiseUI{
    
    self.viewPassword.backgroundColor=[UIColor clearColor];
    self.viewPassword.layer.cornerRadius=2.0f;
    self.viewPassword.layer.masksToBounds=YES;
    self.viewPassword.layer.borderWidth=0.5f;
    self.viewPassword.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textFieldEmail.backgroundColor=[UIColor clearColor];
    self.textFieldEmail.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewEmail.backgroundColor=[UIColor clearColor];
    self.viewEmail.layer.cornerRadius=2.0f;
    self.viewEmail.layer.masksToBounds=YES;
    self.viewEmail.layer.borderWidth=0.5f;
    self.viewEmail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textFieldPassword.backgroundColor=[UIColor clearColor];
    self.textFieldPassword.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonLogin.layer.cornerRadius=2.0f;
    self.buttonLogin.layer.masksToBounds=YES;
    
    self.textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void) getValues{
    getEmail=self.textFieldEmail.text;
    getPassword=self.textFieldPassword.text;
    // gettedDeviceId=@"y408137y090jlkblkhjskjugkhssasfkinieehjkvbgvfsadbsk90kfnac3275032";
    // sharedObject.deviceId=gettedDeviceId;
}

- (IBAction)buttonSignInPressed:(id)sender {
    
    if (self.textFieldEmail.text.length !=0 && self.textFieldPassword.text.length !=0) {
        
        [self serviceCallingForLogin];
    }
    
    else{
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"TextField cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (IBAction)buttonSignUpPressed:(id)sender {
    [self performSegueWithIdentifier:@"joinNowToGettingStartedSegueVC" sender:nil];
}

- (IBAction)buttonForgotPasswordPressed:(id)sender {
    [self performSegueWithIdentifier:@"forgotPassSegueVC" sender:nil];
}

- (NSString *)randomizeString:(NSString *)str
{
    NSMutableString *input = [str mutableCopy];
    NSMutableString *output = [NSMutableString string];
    
    NSUInteger len = input.length;
    
    for (NSUInteger i = 0; i < len; i++) {
        NSInteger index = arc4random_uniform((unsigned int)input.length);
        [output appendFormat:@"%C", [input characterAtIndex:index]];
        [input replaceCharactersInRange:NSMakeRange(index, 1) withString:@""];
    }
  
    gettedDeviceId=output;
    return output;
    
}


//service calling for Login
- (void) serviceCallingForLogin{
    
    iphoneIndicator=@"I";
    getDeviceId=[defaults objectForKey:@"TOKEN"];

    [self getValues];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"email=%@&u_Pass=%@&device_id=%@&indicator=%@",getEmail,getPassword,getDeviceId,iphoneIndicator];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_LOGIN]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
               
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if (json!=0) {
                     
                     if ([messageStatus.Msg isEqualToString:@"0"]) {
                         
                         self.textFieldEmail.text=@"";
                         self.textFieldPassword.text=@"";
                         [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Credentials do not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     }
                     
                     else{
                         defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setObject:self.textFieldEmail.text forKey:@"EMAIL"];
                         [defaults setObject:self.textFieldPassword.text forKey:@"PASSWORD"];
                         NSString *abc=@"1";
                         sharedObject.singletonIsLoggedIn=1;
                         [defaults setObject:iphoneIndicator forKey:@"INDICATOR"];
                         [defaults setObject:getDeviceId forKey:@"TOKEN"];
                         [defaults setObject:abc forKey:@"LOGGED"];
                         
                         sharedObject.deviceId=getDeviceId;
                         
                         [defaults synchronize];
                         
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
                             sharedObject.singletonNeighbourhoodId=each.neighborhood_id;
                             sharedObject.singletonIsAddressEntered=each.address_entered;
                             
                             [defaults setObject:each.email forKey:@"EMAIL"];
                             [defaults setObject:each.verification_code forKey:@"V_CODE"];
                             [defaults setObject:each.status forKey:@"STATUS"];
                             [defaults setObject:each.first_name forKey:@"FIRST_NAME"];
                             [defaults setObject:each.last_name forKey:@"LAST_NAME"];
                             [defaults setObject:each.id forKey:@"ID"];
                             
                             [defaults setObject:each.pincode forKey:@"PINCODE"];
                             [defaults setObject:each.state forKey:@"STATE"];
                             [defaults setObject:each.city forKey:@"CITY"];
                             [defaults setObject:each.address forKey:@"ADDRESS"];
                             [defaults setObject:each.dob forKey:@"DOB"];
                             [defaults setObject:each.occupation forKey:@"OCCUPATION"];
                             [defaults setObject:each.image forKey:@"IMAGE"];
                             [defaults setObject:each.mobile forKey:@"MOBILE"];
                             [defaults setObject:each.weehives_name forKey:@"WEEEHIVE_NAME"];
                             [defaults setObject:each.interest1 forKey:@"INT1"];
                             [defaults setObject:each.interest2 forKey:@"INT2"];
                             [defaults setObject:each.interest3 forKey:@"INT3"];
                             [defaults setObject:each.date forKey:@"DATE"];
                             [defaults setObject:each.neighborhood_id forKey:@"NEG_ID"];
                             [defaults setObject:each.address_entered forKey:@"ADD_ENTERED"];
                            
                         }
                         
                         if([sharedObject.singletonStatus isEqualToString:@"1"]) {
                             //code when user is registered but not entered his profile.
                             [self performSegueWithIdentifier:@"loginToProfileSegueVC" sender:nil];
                         }
                         else if([sharedObject.singletonStatus isEqualToString:@"2"]){
                             //code when user has entered his profile but not entered his verification code. (with address details entered)
                             [self performSegueWithIdentifier:@"afterLoginHomeSegueVC" sender:nil];
                         }
                         else if ([sharedObject.singletonStatus isEqualToString:@"3"]){
                             //code when user has asked for password change
                             [self performSegueWithIdentifier:@"changePassSegueVC" sender:nil];
                         }
                         else if ([sharedObject.singletonStatus isEqualToString:@"4"]){
                             //code when user has entered all details like profile, register, verification code so it is that permanenet status now.
                             [self performSegueWithIdentifier:@"afterLoginHomeSegueVC" sender:nil];
                         }
                         else if ([sharedObject.singletonStatus isEqualToString:@"5"]){
                             //code when trial period ends. 7 days are gone.
                             [self performSegueWithIdentifier:@"loginToCodeSegueVC" sender:nil];
                             
                         }
                         else if ([sharedObject.singletonStatus isEqualToString:@"6"]){
                             //code when address and verification code are not entered
                             //so we will take user onto update address screen
                             [self performSegueWithIdentifier:@"loginToUpdateAddressSegueVC" sender:nil];
                             
                         }
                         
                     }
                     
                 }
                 
                 else{
                     
                 }
                 // Hide Progress bar.
                 [SVProgressHUD dismiss];
                 
                 
             }];
            
        });
        
    }
    else {
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
    }
    
}

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"loginToCodeSegueVC"]) {
        WHLoginCodeViewController *secondVC = segue.destinationViewController;
        secondVC.temp=1;
    }
    else if ([segue.identifier isEqualToString:@"loginToUpdateAddressSegueVC"]){
        WHUpdateAddressViewController *secondVC = segue.destinationViewController;
        secondVC.indicator=1;
    }
    else if ([segue.identifier isEqualToString:@"afterLoginHomeSegueVC"]){
        
        if ([sharedObject.singletonStatus isEqualToString:@"2"]) {
            WHHomeViewController *secondVC = segue.destinationViewController;
            secondVC.value=1;
        }
        
    }
    else{
        
    }
    
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textFieldEmail) {
        [self.textFieldPassword becomeFirstResponder];
    } else if (theTextField == self.textFieldPassword) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


@end
