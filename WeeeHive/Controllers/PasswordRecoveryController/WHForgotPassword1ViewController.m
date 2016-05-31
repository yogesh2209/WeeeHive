//
//  ForgotPassword1ViewController.m
//  WeeeHive
//
//  Created by Schoofi on 19/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHForgotPassword1ViewController.h"

#import "JSONHTTPClient.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHMessageModel.h"

@interface WHForgotPassword1ViewController (){
    
    WHMessageModel *messageStatus;
    NSString *getEmailId;
}


@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;

@end

@implementation WHForgotPassword1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
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


//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Reset Password";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewEmail.layer.backgroundColor=[UIColor clearColor].CGColor;
    self.viewEmail.layer.cornerRadius=2.0f;
    self.viewEmail.layer.masksToBounds=YES;
    self.viewEmail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewEmail.layer.borderWidth=0.5f;
    self.textFieldEmail.layer.backgroundColor=[UIColor clearColor].CGColor;
    self.textFieldEmail.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDone.layer.cornerRadius=2.0f;
    self.buttonDone.layer.masksToBounds=YES;
}

- (void)getValues{
    
    getEmailId=self.textFieldEmail.text;
}

- (IBAction)buttonDonePressed:(id)sender {
    
    if (self.textFieldEmail.text.length==0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Text field cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        [self getValues];
        [self serviceCallingForSendingEmail];
    }
}

//service calling for sending email (forgot password)
- (void) serviceCallingForSendingEmail{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"email=%@",getEmailId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FORGOTPASS1]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
               
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([messageStatus.Msg isEqualToString:@"1"]) {
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please login with temporary password mailed to you" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                 }
                 else{
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
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
        
        [self.navigationController popViewControllerAnimated:YES];
     }
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textFieldEmail) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


@end
