//
//  WHNeghtimesTextViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHNeghtimesTextViewController.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "JSONHTTPClient.h"
#import "Constant.h"
#import "WHSingletonClass.h"

#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

#import "WHNeghtimesTextCommentOnlyTableViewCell.h"
#import "WHNeghtimesTextWithImagesTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"
#import "WHNeghborImageFullScreenViewController.h"

#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"

//Framework
#import <AssetsLibrary/AssetsLibrary.h>

@interface WHNeghtimesTextViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSDate   *originalDate;
    NSString *finalDate;
    NSString *getPostId;
    NSString *getPostPostedById;
    NSString *currentDateString;
    NSString *getUserId;
    NSString *getToken;
    NSString *getComment;
    NSData   *imageData;
    UIImage *getSelectedImage;
    NSString *fileName;
    NSDate *originalCellDate;
    NSString *finalCellDate;
    NSString *newString;
    NSString *tempString;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    int heightView;
    CGRect newFrame;
    NSUserDefaults *defaults;
    
    NSString *gettedFirstName;
    NSString *gettedLastName;
    NSString *tableName;
    NSString *getName;
    NSString *gettedContentId;
    NSString *gettedImageUrl;
  
}

@property (strong, nonatomic) IBOutlet UIView *viewDisplay;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UITextView *textViewDesc;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCommentsList;
@property (strong, nonatomic) IBOutlet UIView *viewMessage;
@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UIButton *buttonCamera;
@property (strong, nonatomic) IBOutlet UITextField *textFieldMessage;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonReport;

@end

@implementation WHNeghtimesTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
  //  [self addTapGesture];
    [self getSingletonValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    self.tableViewCommentsList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewCommentsList addSubview:refreshControl];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    
//    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];

    gettedFirstName=[[WHSingletonClass sharedManager] singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager] singletonLastName];
    tableName=@"Table Name: neigh_times";
    getName=[NSString stringWithFormat:@"%@ %@",gettedFirstName,gettedLastName];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    gettedContentId=[NSString stringWithFormat:@"Post Id: %@",self.postId];
    self.imageViewProfilePic.image=self.getImagePath;
    
    if (self.indicator==1) {
        [self serviceCallingForGettingComments];
    }
    else{
        
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
  //  newFrame = self.viewMessage.frame;
  //  newFrame.origin.y = newFrame.origin.y + 258;
  //  self.viewMessage.frame = newFrame;
}

//// Tap Gesture
//- (void)addTapGesture {
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGestureCalled:)];
//    [self.tableViewCommentsList addGestureRecognizer:tapGesture];
//}
//
//// UITapGestureRecognizer Selector
//- (void)tapImageGestureCalled:(UITapGestureRecognizer *)sender {
//    
//    [self.textFieldMessage resignFirstResponder];
//}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textFieldMessage) {
        [self.viewMessage setFrame:CGRectMake(20,self.view.frame.size.height-36,self.view.frame.size.width-40,30)];
        
        [self.textFieldMessage resignFirstResponder];
    }
    
//    // Code to animate view up.
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        // newFrame = self.viewMessage.frame;
//        newFrame.origin.y = newFrame.origin.y + 258;
//        self.viewMessage.frame = newFrame;
//        
//    } completion:nil];
    return YES;
}

- (void)refresh {
    
    
    [self serviceCallingForGettingComments];
    
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}


- (void)animateTableView {
    
    [self.tableViewCommentsList reloadData];
    NSArray *cells = self.tableViewCommentsList.visibleCells;
    CGFloat height = self.tableViewCommentsList.bounds.size.height;
    
    for (UITableViewCell *cell in cells) {
        
        cell.transform = CGAffineTransformMakeTranslation(0, height);
        
    }
    
    int index = 0;
    
    for (UITableViewCell *cell in cells) {
        
        [UIView animateWithDuration:0.8 delay:0.05 * index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
        
        index += 1;
    }
}


//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Detail";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewMessage.backgroundColor=[UIColor clearColor];
    self.viewMessage.layer.cornerRadius=2.0f;
    self.viewMessage.layer.masksToBounds=YES;
    self.viewMessage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewMessage.layer.borderWidth=0.5f;
    self.textViewDesc.backgroundColor=[UIColor clearColor];
    self.textViewDesc.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldMessage.backgroundColor=[UIColor clearColor];
    self.textFieldMessage.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSend.backgroundColor=[UIColor clearColor];
    self.buttonSend.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewDisplay.backgroundColor=[UIColor clearColor];
    self.viewDisplay.layer.cornerRadius=2.0f;
    self.viewDisplay.layer.masksToBounds=YES;
    self.viewDisplay.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewDisplay.layer.borderWidth=0.5f;
    self.tableViewCommentsList.layer.cornerRadius=2.0f;
    self.tableViewCommentsList.layer.masksToBounds=YES;
    self.tableViewCommentsList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewCommentsList.layer.borderWidth=0.5f;
}

-(void)getValues{
    
    self.labelName.text=[NSString stringWithFormat:@"%@ %@",self.getFirstName,self.getLastName];
    self.textViewDesc.text=self.getMessage;
    self.imageViewProfilePic.layer.cornerRadius=self.imageViewProfilePic.frame.size.height/2;
    self.imageViewProfilePic.layer.masksToBounds=YES;
    self.imageViewProfilePic.image=self.getImagePath;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    originalDate   =  [dateFormatter dateFromString:self.getDate];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
    finalDate = [dateFormatter stringFromDate:originalDate];
    self.labelDate.text=[NSString stringWithFormat:@"%@",finalDate];
    getPostId=self.postId;
    getPostPostedById=self.postedById;
    
}
- (IBAction)buttonSendPressed:(id)sender {
    
    if (self.textFieldMessage.text.length!=0) {
        [self serviceCallingForAddingComment];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Textfields cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}
- (IBAction)buttonCameraPressed:(id)sender {
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
                                                           //   NSLog(@"You pressed button two");
                                                          }];
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    

}

// method for calculating current date.
- (id) getCurrentDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    currentDateString=dateString;
    return dateString;
}

- (void) getTextFieldComment{
    
    getComment=self.textFieldMessage.text;
}


- (void)getSingletonValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
}

//service calling for gettingComments
- (void) serviceCallingForGettingComments{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&post_id=%@&id=%@&device_id=%@",getUserId,getToken,getPostId,getPostPostedById,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_NEGTIMESPOSTCOMMENT]
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
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewCommentsList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewCommentsList.hidden=NO;
                     self.tableViewCommentsList.backgroundView = messageLabel;
                     self.tableViewCommentsList.separatorStyle = UITableViewCellSeparatorStyleNone;

                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateTableView];
                     
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
        fileName = [representation filename];
        [self dismissViewControllerAnimated:YES completion:nil];
        getSelectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        self.indicator=2;
        [self.buttonCamera setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
}

#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return profileData.profile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    profileInfoModel=profileData.profile[indexPath.row];
    
    if (profileInfoModel.reply_image.length==0) {
        
        //code for only comment without image
        WHNeghtimesTextCommentOnlyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tweetWithoutImageCustomCell"];
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        originalCellDate   =  [dateFormatter dateFromString:profileInfoModel.reply_date];
        [dateFormatter setDateFormat:@"dd-MMM-yy"];
        finalCellDate = [dateFormatter stringFromDate:originalCellDate];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",finalCellDate];
        cell.labelTweet.numberOfLines=0;
        cell.labelTweet.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelTweet.text=[NSString stringWithFormat:@"%@",profileInfoModel.reply_details];
        
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        
        tempString = [profileInfoModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //LAZY LOADING FOR PROFILE PIC.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,tempString];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return cell;
        
    }
    else{
        
        //code with image
        WHNeghtimesTextWithImagesTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"tweetWithImageCustomCell"];
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        originalCellDate   =  [dateFormatter dateFromString:profileInfoModel.reply_date];
        [dateFormatter setDateFormat:@"dd-MMM-yy"];
        finalCellDate = [dateFormatter stringFromDate:originalCellDate];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",finalCellDate];
        cell.labelTweet.numberOfLines=0;
        cell.labelTweet.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelTweet.text=[NSString stringWithFormat:@"%@",profileInfoModel.reply_details];
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        
        newString = [profileInfoModel.reply_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //LAZY LOADING FOR REPLY IMAGE.
        NSString *final_reply_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,newString];
        [cell.imageViewTweet sd_setImageWithURL:[NSURL URLWithString:final_reply_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        tempString = [profileInfoModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //LAZY LOADING FOR PROFILE PIC.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,tempString];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    profileInfoModel = profileData.profile[indexPath.row];
    
    if (profileInfoModel.reply_image.length==0) {
        
        //code for only comment cell
        
        CGSize constraint = CGSizeMake(225, 20000);
        
        // Size for Name
        
        NSString *comment = [NSString stringWithFormat:@"%@",profileInfoModel.reply_details];
        
        CGFloat heightComment = 0.0;
        
        
        if (profileInfoModel.reply_details.length > 0) {
            
            NSAttributedString *attributedTextQues =  [[NSAttributedString alloc] initWithString:comment];
            
            CGRect rectComment = [attributedTextQues boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGSize sizeComment   = rectComment.size;
            
            heightComment = MAX(sizeComment.height, 15.0f);
            
        }
        
        return  heightComment + 45;
    }
    else{
        
        //code for image cell
        
        CGSize constraint = CGSizeMake(225, 20000);
        
        // Size for Name
        
        NSString *comment = [NSString stringWithFormat:@"%@",profileInfoModel.reply_details];
        
        CGFloat heightComment = 0.0;
        
        
        if (profileInfoModel.reply_details.length > 0) {
            
            NSAttributedString *attributedTextQues =  [[NSAttributedString alloc] initWithString:comment];
            
            CGRect rectComment = [attributedTextQues boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGSize sizeComment   = rectComment.size;
            
            heightComment = MAX(sizeComment.height, 15.0f);
            
        }
        
        return  heightComment + 260;
    }
    
}

#pragma mark  UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    profileInfoModel=profileData.profile[indexPath.row];
    
    if (profileInfoModel.reply_image.length==0) {
        
    }
    else{
        gettedImageUrl=profileInfoModel.reply_image;
        [self performSegueWithIdentifier:@"neghCellImageSizeSegueVC" sender:nil];
    }
}

- (void) serviceCallingForAddingComment{
    
    [self getCurrentDate];
    [self getTextFieldComment];
    
    // Show Progress bar.
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_NEGHTIMESADDCOMMENT];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:getUserId forKey:@"replied_by"];
    [parameters setValue:getToken forKey:@"token"];
    [parameters setValue:getComment forKey:@"reply_detail"];
    [parameters setValue:currentDateString forKey:@"reply_date"];
    [parameters setValue:getPostPostedById forKey:@"posted_by"];
    [parameters setValue:getPostId forKey:@"post_id"];
    [parameters setValue:gettedDeviceId forKey:@"device_id"];
    
    
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
        
        [self.buttonCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    
        messageStatus=[[WHMessageModel alloc]initWithDictionary:jsonResponse error:nil];
        tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:jsonResponse error:nil];
        
        if ([tokenStatus.error isEqualToString:@"0"]) {
            // Hide Progress bar.
            [SVProgressHUD dismiss];
            sharedObject.singletonIsLoggedIn=0;
            [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Session expired" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        
        else if ([messageStatus.Msg isEqualToString:@"0"]) {
            // Hide Progress bar.
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else if ([messageStatus.Msg isEqualToString:@"1"]){
            // Hide Progress bar.
            [SVProgressHUD dismiss];
            self.textFieldMessage.text=@"";
            self.textFieldMessage.placeholder=@"Type Message";
            [self serviceCallingForGettingComments];
        }
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }];
    
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    return YES;
//}
//
//
////- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
////    [UIView animateWithDuration:0.5 animations:^{
////        
////        newFrame = self.viewMessage.frame;
////        newFrame.origin.y = newFrame.origin.y + 258;
////        self.viewMessage.frame = newFrame;
////        
////    } completion:nil];
////    [self.view endEditing:YES];
////    return YES;
////}
//
//
//- (void)keyboardDidShow:(NSNotification *)notification
//{
//
//    // Code to animate view down.
//    [UIView animateWithDuration:0.5 animations:^{
// 
////    // Assign new frame to your view
//   [self.viewMessage setFrame:CGRectMake(20,self.view.frame.size.height-298,self.view.frame.size.width-40,30)];
//
//    int heightTableView =(self.view.frame.size.height)-(self.viewDisplay.frame.size.height+16  + 30 + 8 + heightView);
//  
//    self.tableViewCommentsList.frame = CGRectMake(20,170,self.view.frame.size.width-40,heightTableView-64);
//    
//        messageLabel.hidden=YES;
//
//    }];
//    
//}
//
//- (void)keyboardWasShown:(NSNotification *)notification
//{
//    // Get the size of the keyboard.
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    //Given size may not account for screen rotation
//    heightView = MIN(keyboardSize.height,keyboardSize.width);
//
//}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        if ([tokenStatus.error isEqualToString:@"0"]) {
            
            NSString *string=@"0";
            [defaults setObject:string forKey:@"LOGGED"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else{
            [self serviceCallingForReportingContent];
        }
    }
    
   
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

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"neghCellImageSizeSegueVC"]) {
        WHNeghborImageFullScreenViewController *secondVC = segue.destinationViewController;
        secondVC.getImageString=gettedImageUrl;
    }
}


@end
