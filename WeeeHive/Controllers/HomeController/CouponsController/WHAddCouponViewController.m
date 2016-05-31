//
//  WHAddCouponViewController.m
//  WeeeHive
//
//  Created by Schoofi on 30/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHAddCouponViewController.h"
#import "WHSingletonClass.h"
#import "JSONHTTPClient.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

//Framework
#import <AssetsLibrary/AssetsLibrary.h>


@interface WHAddCouponViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, NSURLConnectionDelegate, UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    WHSingletonClass *sharedObject;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    
    NSString *fileName;
    NSString *getUserId;
    NSString *getToken;
    NSString *getTextViewFlyer;
    UIImage *getSelectedImage;
    NSData *imageData;
    BOOL isFlag;
    NSString *gettedDeviceId;
    NSString *getCityId;
    NSString *getNeighbourhoodId;
    
    NSString *getFirstName;
    NSString *getLastName;
    NSString *gettedImageString;
    NSUserDefaults *defaults;
    
}

@property (weak, nonatomic) IBOutlet UITextView *textViewFlyer;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (weak, nonatomic) IBOutlet UIButton *buttonUploadPic;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewCouponImage;

@end

@implementation WHAddCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    self.textViewFlyer.text = @"Write your message here";
    self.textViewFlyer.textColor = [UIColor lightGrayColor];
    self.textViewFlyer.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Add Coupon";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.buttonSubmit.layer.cornerRadius=2.0f;
    self.buttonSubmit.layer.masksToBounds=YES;
    
    self.buttonUploadPic.backgroundColor=[UIColor clearColor];
    self.buttonUploadPic.layer.cornerRadius=2.0f;
    self.buttonUploadPic.layer.masksToBounds=YES;
    self.buttonUploadPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.buttonUploadPic.layer.borderWidth=0.5f;
    
    self.textViewFlyer.backgroundColor=[UIColor clearColor];
    self.textViewFlyer.layer.cornerRadius=2.0f;
    self.textViewFlyer.layer.masksToBounds=YES;
    self.textViewFlyer.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewFlyer.layer.borderWidth=0.5f;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



#pragma mark  UITextField Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textViewFlyer.textColor == [UIColor lightGrayColor]) {
        self.textViewFlyer.text = @"";
        self.textViewFlyer.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.textViewFlyer.text.length == 0){
        self.textViewFlyer.textColor = [UIColor lightGrayColor];
        self.textViewFlyer.text = @"Write your message here";
        [self.textViewFlyer resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.textViewFlyer.text.length == 0){
            self.textViewFlyer.textColor = [UIColor lightGrayColor];
            self.textViewFlyer.text = @"Write your message here";
            [self.textViewFlyer resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}



#pragma mark  UIValues

-(void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager] singletonToken];
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    getFirstName=[[WHSingletonClass sharedManager] singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager] singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager] singletonImage];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
}


-(void) getTextfieldValues{
    
    getTextViewFlyer=self.textViewFlyer.text;
}

#pragma mark  UIButton Action
- (IBAction)buttonSubmitPressed:(id)sender {
    
    if (isFlag==1) {
        
        if ([self.textViewFlyer.text isEqualToString:@"Write your message here"]) {
            
            getTextViewFlyer=@"";
            [self serviceCallUploadingCoupon];
        }
        else{
            getTextViewFlyer=self.textViewFlyer.text;
            [self serviceCallUploadingCoupon];
            
        }
        
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select an image" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }
}

- (IBAction)buttonUploadPicPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Select the image you want to upload"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              //NSLog(@"You pressed button one");
                                                              
                                                              // Open the Camera if available.
                                                              if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                  //[self pickImageOfSourceType:UIImagePickerControllerSourceTypeCamera];
                                                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                      [self pickImageOfSourceType:UIImagePickerControllerSourceTypeCamera];
                                                                      
                                                                      
                                                                  }];
                                                              } else {
                                                                  [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Camera not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                                              }
                                                              
                                                              
                                                              
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Image Gallery"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              // NSLog(@"You pressed button two");
                                                               
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   [self pickImageOfSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                               }];
                                                               
                                                           }]; // 3
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                            //  NSLog(@"You pressed button two");
                                                          }];
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    

}

- (void)pickImageOfSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate                    = self;
    imagePickerController.sourceType               =  sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark  UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Dismiss presented view controller.
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        
        if (fileName.length==0) {
            NSString *initialTemp=@"IMG";
            NSInteger randomNumber = arc4random() % 9000 + 1000;
            NSString *finalTemp=@".JPG";
            fileName=[NSString stringWithFormat:@"%@%ld%@",initialTemp,(long)randomNumber,finalTemp]
            ;
            
        }
        else{
            fileName = [representation filename];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        getSelectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        isFlag=1;
        self.imageViewCouponImage.image= [info valueForKey:UIImagePickerControllerOriginalImage];
        [self.buttonUploadPic setTitle:fileName forState:UIControlStateNormal];
      
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
}

//- (void) serviceCallUploadingCoupon{
//    
//   
//    
//    // Show Progress bar.
//    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
//    
//    [self getTextfieldValues];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    //Set Params
//    [request setHTTPShouldHandleCookies:NO];
//    //[request setTimeoutInterval:60];
//    [request setHTTPMethod:@"POST"];
//    
//    //Create boundary, it can be anything
//    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
//    
//    // set Content-Type in HTTP header
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//    // post body
//    NSMutableData *body = [NSMutableData data];
//    //Populate a dictionary with all the regular values you would like to send.
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    
//    
//    // add params (all params are strings)
//    for (NSString *param in parameters) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    imageData = UIImageJPEGRepresentation(getSelectedImage, 0.5);
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:imageData]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    // setting the body of the post to the request
//    [request setHTTPBody:body];
//    
//    
//    // set URL
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_UPLOADCOUPON]]];
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               
//                               NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//                               
//                               if ([httpResponse statusCode] == 200) {
//                                   
//                                   // Hide Progress bar.
//                                   [SVProgressHUD dismiss];
//                                   [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Coupon uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
//                                   
//                               }
//                               else{
//                                   // Hide Progress bar.
//                                   [SVProgressHUD dismiss];
//                                   [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
//                               }
//                               
//                           }];
//    
//}


- (void) serviceCallUploadingCoupon{
    
    [self getTextfieldValues];
 
    if ([self.textViewFlyer.text isEqualToString:@"Write your message here"]) {
        self.textViewFlyer.text=@"";
        getTextViewFlyer=@"";
    }
    else{
        
    }
    
    // Show Progress bar.
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_UPLOADCOUPON];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:getUserId forKey:@"u_id"];
    [parameters setValue:getToken forKey:@"token"];
    [parameters setValue:getTextViewFlyer forKey:@"text"];
    [parameters setValue:gettedDeviceId forKey:@"device_id"];
    [parameters setValue:getCityId forKey:@"city_id"];
    [parameters setValue:getNeighbourhoodId forKey:@"neg_id"];
    [parameters setValue:getFirstName forKey:@"first_name"];
    [parameters setValue:getLastName forKey:@"last_name"];
    [parameters setValue:gettedImageString forKey:@"image"];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
       imageData = UIImageJPEGRepresentation(getSelectedImage, 0.5);
        if (imageData) {
            NSString *initialTemp=@"IMG";
            NSInteger randomNumber = arc4random() % 16;
            NSString *finalTemp=@".JPG";
            
            fileName=[NSString stringWithFormat:@"%@%ld%@",initialTemp,(long)randomNumber,finalTemp]
            ;
           
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg"];
        }
        else{
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:nil];
        
        // Hide Progress bar.
        [SVProgressHUD dismiss];
    
        messageStatus=[[WHMessageModel alloc]initWithDictionary:jsonResponse error:nil];
        tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:jsonResponse error:nil];
        
        if ([tokenStatus.error isEqualToString:@"0"]) {
            sharedObject.singletonIsLoggedIn=0;
            
            [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Session expired" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        
        else if ([messageStatus.Msg isEqualToString:@"0"]) {
            [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else if ([messageStatus.Msg isEqualToString:@"1"]){
            
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Successful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        
        if (jsonResponse) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }];
    
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
