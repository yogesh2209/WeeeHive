//
//  WHAddWeehiveGroupViewController.m
//  WeeeHive
//
//  Created by Schoofi on 30/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHAddWeehiveGroupViewController.h"

#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"
#import "UIImageView+WebCache.h"
#import "WHFriendListToAddGroupViewController.h"
#import "WHAddMembersFilterViewController.h"

#import "WHYourWeehiveModel.h"
#import "WHYourWeehiveDetailsModel.h"
#import "WHTokenErrorModel.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"





//Framework
#import <AssetsLibrary/AssetsLibrary.h>

@interface WHAddWeehiveGroupViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDelegate, UIAlertViewDelegate,NSURLConnectionDataDelegate>{
    
    WHYourWeehiveModel *weehiveData;
    WHYourWeehiveDetailsModel *weehiveInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    int indicator;
    NSString *getUserId;
    NSString *getToken;
    
    NSData *imageData;
    
    NSString *getGroupName;
    NSString *getDescription;
    NSString *fileName;
    UIImage *getSelectedImage;
    NSString *getGroupId;
    
    NSString *gettedDeviceId;
    NSString *getCityId;
    NSString *getNeghbourhoodId;
    
    BOOL isPhotoSelected;
    
    NSUserDefaults *defaults;
    
    
    
}


@property (weak, nonatomic) IBOutlet UIView *viewGroupName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGroupName;
@property (weak, nonatomic) IBOutlet UITextView *textViewDesc;
@property (weak, nonatomic) IBOutlet UIButton *buttonUploadPic;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (strong, nonatomic) IBOutlet UIButton *buttonAddMemberFilter;
@property (strong, nonatomic) IBOutlet UIButton *buttonAddMemberFriendList;


@end

@implementation WHAddWeehiveGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    self.textViewDesc.text = @"Write your message here";
    self.textViewDesc.textColor = [UIColor lightGrayColor];
    self.textViewDesc.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeghbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    self.buttonAddMemberFilter.userInteractionEnabled=NO;
    self.buttonAddMemberFriendList.userInteractionEnabled=NO;
    self.buttonAddMemberFriendList.alpha=0.5f;
    self.buttonAddMemberFilter.alpha=0.5f;
    self.buttonDone.userInteractionEnabled=YES;
    self.buttonDone.alpha=1.0f;
    self.viewGroupName.userInteractionEnabled=YES;
    self.viewGroupName.alpha=1.0f;
    self.textViewDesc.userInteractionEnabled=YES;
    self.textViewDesc.alpha=1.0f;
    self.buttonUploadPic.userInteractionEnabled=YES;
    self.buttonUploadPic.alpha=1.0f;
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Add Weehive";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewGroupName.backgroundColor=[UIColor clearColor];
    self.viewGroupName.layer.cornerRadius=2.0f;
    self.viewGroupName.layer.masksToBounds=YES;
    self.viewGroupName.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewGroupName.layer.borderWidth=0.5f;
    self.textFieldGroupName.backgroundColor=[UIColor clearColor];
    self.textFieldGroupName.layer.borderColor=[UIColor clearColor].CGColor;
    self.textViewDesc.backgroundColor=[UIColor clearColor];
    self.textViewDesc.layer.cornerRadius=2.0f;
    self.textViewDesc.layer.masksToBounds=YES;
    self.textViewDesc.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewDesc.layer.borderWidth=0.5f;
    self.buttonDone.layer.cornerRadius=2.0f;
    self.buttonDone.layer.masksToBounds=YES;
    self.buttonUploadPic.layer.cornerRadius=2.0f;
    self.buttonUploadPic.layer.masksToBounds=YES;
    self.buttonUploadPic.backgroundColor=[UIColor clearColor];
    self.buttonUploadPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.buttonUploadPic.layer.borderWidth=0.5f;
    
    self.buttonAddMemberFilter.layer.cornerRadius=2.0f;
    self.buttonAddMemberFilter.layer.masksToBounds=YES;
    self.buttonAddMemberFilter.backgroundColor=[UIColor clearColor];
    self.buttonAddMemberFilter.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.buttonAddMemberFilter.layer.borderWidth=0.5f;
    
    self.buttonAddMemberFriendList.layer.cornerRadius=2.0f;
    self.buttonAddMemberFriendList.layer.masksToBounds=YES;
    self.buttonAddMemberFriendList.backgroundColor=[UIColor clearColor];
    self.buttonAddMemberFriendList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.buttonAddMemberFriendList.layer.borderWidth=0.5f;
    
    
}



#pragma mark  UITextView Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textViewDesc.textColor == [UIColor lightGrayColor]) {
        self.textViewDesc.text = @"";
        self.textViewDesc.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.textViewDesc.text.length == 0){
        self.textViewDesc.textColor = [UIColor lightGrayColor];
        self.textViewDesc.text = @"Write your message here";
        [self.textViewDesc resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.textViewDesc.text.length == 0){
            self.textViewDesc.textColor = [UIColor lightGrayColor];
            self.textViewDesc.text = @"Write your message here";
            [self.textViewDesc resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}


- (void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    
}

- (void) getFormValues{
    
    getDescription=self.textViewDesc.text;
    getGroupName=self.textFieldGroupName.text;
    
}


- (IBAction)buttonDonePressed:(id)sender {
    
    if (self.textFieldGroupName.text.length!=0 && self.textViewDesc.text.length!=0) {
        
        if ([self.textViewDesc.text isEqualToString:@"Write your message here"]) {
            
            self.textViewDesc.text=@"";
            
        }
        [self serviceCallAddGroup];
        
    }
    else{
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fields cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
}

- (IBAction)buttonUploadPicPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Select the image you want to upload"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                          //    NSLog(@"You pressed button one");
                                                              
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
        [self.buttonUploadPic setTitle:[NSString stringWithFormat:@"%@",fileName] forState:UIControlStateNormal];
        isPhotoSelected=1;
        
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
}


- (void) serviceCallAddGroup{
    
    [self getFormValues];
    
    // Show Progress bar.
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_ADDGROUP];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:getGroupName forKey:@"group_name"];
    [parameters setValue:getDescription forKey:@"description"];
    [parameters setValue:getUserId forKey:@"created_by"];
    [parameters setValue:getToken forKey:@"token"];
    [parameters setValue:gettedDeviceId forKey:@"device_id"];
    [parameters setValue:getCityId forKey:@"city_id"];
    [parameters setValue:getNeghbourhoodId forKey:@"neg_id"];
    
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        if (isPhotoSelected==1){
            imageData = UIImageJPEGRepresentation(getSelectedImage, 0.5);
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
        
        weehiveData=[[WHYourWeehiveModel alloc]initWithDictionary:jsonResponse error:nil];
        messageStatus=[[WHMessageModel alloc]initWithDictionary:jsonResponse error:nil];
        tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:jsonResponse error:nil];
        
        if ([tokenStatus.error isEqualToString:@"0"]) {
            sharedObject.singletonIsLoggedIn=0;
            // Hide Progress bar.
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Session expired" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else if ([messageStatus.Msg isEqualToString:@"0"]){
            // Hide Progress bar.
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            
        }
        else{
            // Hide Progress bar.
            [SVProgressHUD dismiss];
            self.buttonAddMemberFilter.alpha=1.0f;
            self.buttonAddMemberFriendList.alpha=1.0f;
            self.buttonAddMemberFriendList.userInteractionEnabled=YES;
            self.buttonAddMemberFilter.userInteractionEnabled=YES;
            self.buttonDone.userInteractionEnabled=NO;
            self.buttonDone.alpha=0.5f;
            self.viewGroupName.userInteractionEnabled=NO;
            self.viewGroupName.alpha=0.5f;
            self.textViewDesc.userInteractionEnabled=NO;
            self.textViewDesc.alpha=0.5f;
            self.buttonUploadPic.userInteractionEnabled=NO;
            self.buttonUploadPic.alpha=0.5f;
            
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Weehive created successfully, please add members now" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            for (WHYourWeehiveDetailsModel *each in weehiveData.group) {
                getGroupId=each.group_id;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }];
    
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if (indicator==1) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (indicator==2){
            
            NSString *string=@"0";
            [defaults setObject:string forKey:@"LOGGED"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
}

- (IBAction)buttonAddMemberFilterPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addMemberFilterSegueVC" sender:nil];
}
- (IBAction)buttonAddMemberFriendListPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addMemberFriendsSegueVC" sender:nil];
}

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addMemberFriendsSegueVC"]) {
        WHFriendListToAddGroupViewController *secondVC = segue.destinationViewController;
        secondVC.getGroupId=getGroupId;
        secondVC.getIndicatorValue=1;
    }
    else{
        WHAddMembersFilterViewController *secondVC = segue.destinationViewController;
        secondVC.getGroupId=getGroupId;
    }
}

@end
