//
//  WHNeghTimesDetailsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 12/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHNeghTimesDetailsViewController.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "JSONHTTPClient.h"

#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHSingletonClass.h"
#import "WHNeghTimesCommentsTableViewCell.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "UIImageView+WebCache.h"
#import "WHNeghtimesImagesTableViewCell.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

//Framework
#import <AssetsLibrary/AssetsLibrary.h>

@interface WHNeghTimesDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSDate *originalDate;
    NSString *finalDate;
    NSIndexPath *getIndexPath;
    NSString *getUserId;
    NSString *getToken;
    NSString *getPostId;
    NSDate *orignalCellDate;
    NSString *finalCellDate;
    NSString *getPostPostedById;
    NSString *getComment;
    NSString *currentDateString;
    NSData *imageData;
    NSString *fileName;
    UIImage *getSelectedImage;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    int heightView;
    NSUserDefaults *defaults;
}

@property (strong, nonatomic) IBOutlet UIView *viewReply;
@property (weak, nonatomic) IBOutlet UIView *viewDisplayData;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePic;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UITableView *tableViewComments;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldComment;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet UIButton *buttonUpload;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTweetImage;


@end

@implementation WHNeghTimesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    [self addTapGesture];
    defaults=[NSUserDefaults standardUserDefaults];
    [self getSingletonValues];
    sharedObject=[WHSingletonClass sharedManager];
    self.tableViewComments.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewComments addSubview:refreshControl];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.imageViewTweetImage.image=self.getImageString;
    self.imageViewProfilePic.image=self.getImagePath;
    
    if (self.indicator==1) {
        [self serviceCallingForGettingComments];

    }
    else{
        
    }
    
}

// Tap Gesture
- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGestureCalled:)];
    [self.tableViewComments addGestureRecognizer:tapGesture];
}

// UITapGestureRecognizer Selector
- (void)tapImageGestureCalled:(UITapGestureRecognizer *)sender {
    
    [self.textFieldComment resignFirstResponder];
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
     [self.viewReply setFrame:CGRectMake(20,self.view.frame.size.height-36,self.view.frame.size.width-40,30)];
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

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textFieldComment) {
        // Code to animate view up.
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect newFrame = self.viewReply.frame;
            newFrame.origin.y = newFrame.origin.y + 258;
            self.viewReply.frame = newFrame;
            
        } completion:nil];
        [self.textFieldComment resignFirstResponder];
    }
       return YES;
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
    
    self.viewDisplayData.backgroundColor=[UIColor clearColor];
    self.viewDisplayData.layer.cornerRadius=2.0f;
    self.viewDisplayData.layer.masksToBounds=YES;
    self.viewDisplayData.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewDisplayData.layer.borderWidth=0.5f;
    self.textViewMessage.backgroundColor=[UIColor clearColor];
    self.textViewMessage.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldComment.backgroundColor=[UIColor clearColor];
    self.textFieldComment.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSend.backgroundColor=[UIColor clearColor];
    self.buttonSend.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewReply.backgroundColor=[UIColor clearColor];
    self.viewReply.layer.cornerRadius=2.0f;
    self.viewReply.layer.masksToBounds=YES;
    self.viewReply.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewReply.layer.borderWidth=0.5f;
    self.tableViewComments.layer.cornerRadius=2.0f;
    self.tableViewComments.layer.masksToBounds=YES;
    self.tableViewComments.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewComments.layer.borderWidth=0.5f;
}

-(void)getValues{

    self.labelName.text=[NSString stringWithFormat:@"%@ %@",self.getFirstName,self.getLastName];
    self.textViewMessage.text=self.getMessage;
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
    
    if (self.textFieldComment.text.length!=0) {
        [self serviceCallingForAddingComment];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Textfields cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (void)animateTableView {
    
    [self.tableViewComments reloadData];
    NSArray *cells = self.tableViewComments.visibleCells;
    CGFloat height = self.tableViewComments.bounds.size.height;
    
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
- (void) getTextFieldComment{
    
    getComment=self.textFieldComment.text;
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewComments.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewComments.hidden=NO;
                     self.tableViewComments.backgroundView = messageLabel;
                     self.tableViewComments.separatorStyle = UITableViewCellSeparatorStyleNone;

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

#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return profileData.profile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    profileInfoModel=profileData.profile[indexPath.row];
    
    if (profileInfoModel.reply_image.length==0) {
        
        //code for only comment without image
        WHNeghTimesCommentsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:WHNEGHTIMESCOMMENTS_CELL];
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        orignalCellDate   =  [dateFormatter dateFromString:profileInfoModel.reply_date];
        [dateFormatter setDateFormat:@"dd-MMM-yy"];
        finalCellDate = [dateFormatter stringFromDate:orignalCellDate];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",finalCellDate];
        cell.labelComment.numberOfLines=0;
        cell.labelComment.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelComment.text=[NSString stringWithFormat:@"%@",profileInfoModel.reply_details];
        
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return cell;
  
    }
    else{
        
        //code with image
        WHNeghtimesImagesTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"neghtimesImagesCustomCell"];
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        orignalCellDate   =  [dateFormatter dateFromString:profileInfoModel.reply_date];
        [dateFormatter setDateFormat:@"dd-MMM-yy"];
        finalCellDate = [dateFormatter stringFromDate:orignalCellDate];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",finalCellDate];
        cell.labelComment.numberOfLines=0;
        cell.labelComment.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelComment.text=[NSString stringWithFormat:@"%@",profileInfoModel.reply_details];
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        
        //LAZY LOADING FOR REPLY IMAGE.
        NSString *final_reply_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.reply_image];
        [cell.imageViewtweetImage sd_setImageWithURL:[NSURL URLWithString:final_reply_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        //LAZY LOADING FOR PROFILE PIC.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
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

// method for calculating current date.
- (id) getCurrentDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    currentDateString=dateString;
    return dateString;
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
                                                            //   NSLog(@"You pressed button two");
                                                               
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
        fileName = [representation filename];
        [self dismissViewControllerAnimated:YES completion:nil];
        getSelectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        self.indicator=2;
        [self.buttonUpload setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
        
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
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
        
    
      [self.buttonUpload setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
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
          
            self.textFieldComment.text=@"";
            self.textFieldComment.placeholder=@"Type Message";
            [self serviceCallingForGettingComments];
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}



- (void)keyboardDidShow:(NSNotification *)notification
{
    
    // Code to animate view down.
    [UIView animateWithDuration:0.5 animations:^{
        
    // Assign new frame to your view
    [self.viewReply setFrame:CGRectMake(20,self.view.frame.size.height-298,self.view.frame.size.width-40,30)];
 
    int heightTableView =(self.view.frame.size.height)-(self.viewDisplayData.frame.size.height+16 + heightView + 30 + 8);
  
    self.tableViewComments.frame = CGRectMake(20,340,self.view.frame.size.width-40,heightTableView-64);
         messageLabel.hidden=YES;
        
         }];
    
}


- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //Given size may not account for screen rotation
     heightView = MIN(keyboardSize.height,keyboardSize.width);
 
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}


@end
