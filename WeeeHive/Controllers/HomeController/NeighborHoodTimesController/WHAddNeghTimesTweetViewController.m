//
//  WHAddNeghTimesTweetViewController.m
//  WeeeHive
//
//  Created by Schoofi on 29/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHAddNeghTimesTweetViewController.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHSingletonClass.h"
#import "WHSingletonClass.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

//Framework
#import <AssetsLibrary/AssetsLibrary.h>

@interface WHAddNeghTimesTweetViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, NSURLConnectionDelegate, UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSString *getMessage;
    UIImage *getSelectedImage;
    NSData *imageData;
    BOOL isFlag;
    NSString *fileName;
    NSString *gettedDeviceId;
    NSString *getCityId;
    NSString *getNeighbourhoodId;
    
    NSString *getFirstName;
    NSString *getLastName;
    NSString *getImageString;
    NSUserDefaults *defaults;
    
    
}

@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (strong, nonatomic) IBOutlet UIButton *buttonUploadPic;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewSelectedImage;

@end

@implementation WHAddNeghTimesTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getValues];
    [self customizeUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}


//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Add Message";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textViewMessage.text = @"Write your message here";
    self.textViewMessage.textColor = [UIColor lightGrayColor];
    self.textViewMessage.delegate = self;
    self.buttonSubmit.layer.cornerRadius=2.0f;
    self.buttonSubmit.layer.masksToBounds=YES;
    self.textViewMessage.backgroundColor=[UIColor clearColor];
    self.textViewMessage.layer.cornerRadius=2.0f;
    self.textViewMessage.layer.masksToBounds=YES;
    self.textViewMessage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewMessage.layer.borderWidth=0.5f;
    self.buttonUploadPic.backgroundColor=[UIColor clearColor];
    self.buttonUploadPic.layer.cornerRadius=2.0f;
    self.buttonUploadPic.layer.masksToBounds=YES;
    self.buttonUploadPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.buttonUploadPic.layer.borderWidth=0.5f;
}

- (void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager] singletonToken];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    getFirstName=[[WHSingletonClass sharedManager] singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager] singletonLastName];
    getImageString=[[WHSingletonClass sharedManager] singletonImage];
    
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    
}


- (IBAction)buttonSubmitPressed:(id)sender {
    
    if ([self.textViewMessage.text isEqualToString:@"Write your message here"] || self.textViewMessage.text.length==0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Message cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        
        [self serviceCallSubmittingTweet];
    }
}



#pragma mark  UITextView Delegates

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

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        if (buttonIndex == 0) {

                if ([tokenStatus.error isEqualToString:@"0"]) {
                    
                    NSString *string=@"0";
                    [defaults setObject:string forKey:@"LOGGED"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
    
        }
    }
    }
    else if ([messageStatus.Msg isEqualToString:@"1"]){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)buttonUploadPicPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Select the image you want to upload"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                            //  NSLog(@"You pressed button one");
                                                              
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
                                                             //  NSLog(@"You pressed button two");
                                                               
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
        self.imageViewSelectedImage.image= [info valueForKey:UIImagePickerControllerOriginalImage];
        isFlag=1;
        [self.buttonUploadPic setTitle:fileName forState:UIControlStateNormal];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
}


- (void) serviceCallSubmittingTweet{
    
    getMessage=self.textViewMessage.text;
    
    // Show Progress bar.
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
   NSString *url=[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_ADDNEGHTIMESTWEET];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:getUserId forKey:@"u_id"];
    [parameters setValue:getToken forKey:@"token"];
    [parameters setValue:getMessage forKey:@"msg"];
    [parameters setValue:gettedDeviceId forKey:@"device_id"];
    [parameters setValue:getCityId forKey:@"city_id"];
    [parameters setValue:getNeighbourhoodId forKey:@"neg_id"];
    [parameters setValue:getFirstName forKey:@"first_name"];
    [parameters setValue:getLastName forKey:@"last_name"];
    [parameters setValue:getImageString forKey:@"image"];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        imageData = UIImageJPEGRepresentation(getSelectedImage, 0.5);
        
        if (imageData) {
            
            NSString *initialTemp=@"IMG";
            NSInteger randomNumber = arc4random() % 16;
            NSString *finalTemp=@".JPG";
            
            fileName=[NSString stringWithFormat:@"%@%ld%@",initialTemp,(long)randomNumber,finalTemp]
            ;
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
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

@end
