//
//  WHNeighborTimesViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHNeighborTimesViewController.h"

#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHNeghborTimesCollectionViewCell.h"
#import "WHNeghtimesWithImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "WHNeghtimesTextViewController.h"
#import "WHAddNeghTimesTweetViewController.h"
#import "NSDate+DateTools.h"
#import "WHNeghTimesDetailsViewController.h"

@interface WHNeighborTimesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSDate *originalDate;
    NSString *finalDate;
    NSIndexPath *getIndexPath;
    int clicked;
    int temp;
    int value;
    NSString *newString;
    BOOL isPressed;
    NSString *tempString;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    int countComments;
    int dividedComments;
    NSString *getNeighbourhoodId;
    NSString *getCityId;
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewNeghTimes;
@property (strong, nonatomic) IBOutlet UIView *viewFilterSort;
@property (strong, nonatomic) IBOutlet UIButton *buttonLeftSide;
@property (strong, nonatomic) IBOutlet UIButton *buttonRightSide;

@end

@implementation WHNeighborTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    self.collectionViewNeghTimes.alwaysBounceVertical = YES;
    [self.collectionViewNeghTimes addSubview:refreshControl];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.collectionViewNeghTimes.hidden=NO;
    self.viewFilterSort.hidden=YES;
    [self serviceCallingForNeghhoodTimes];

}

- (void)refresh {
    
    [self serviceCallingForNeghhoodTimes];
    
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

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Neighbourhood Times";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewFilterSort.backgroundColor=[UIColor clearColor];
    self.viewFilterSort.layer.cornerRadius=2.0f;
    self.viewFilterSort.layer.masksToBounds=YES;
    self.viewFilterSort.layer.borderColor=[UIColor clearColor].CGColor;
   
    
    self.buttonLeftSide.backgroundColor=[UIColor clearColor];
    self.buttonLeftSide.layer.cornerRadius=2.0f;
    self.buttonLeftSide.layer.masksToBounds=YES;
    self.buttonLeftSide.layer.borderWidth=0.5f;
    self.buttonLeftSide.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.buttonRightSide.backgroundColor=[UIColor clearColor];
    self.buttonRightSide.layer.cornerRadius=2.0f;
    self.buttonRightSide.layer.masksToBounds=YES;
    self.buttonRightSide.layer.borderWidth=0.5f;
    self.buttonRightSide.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
}
- (void)animateCollectionView {
    
    [self.collectionViewNeghTimes reloadData];
    NSArray *cells = self.collectionViewNeghTimes.visibleCells;
    CGFloat height = self.collectionViewNeghTimes.bounds.size.height;
    
    for (UICollectionViewCell *cell in cells) {
        
        cell.transform = CGAffineTransformMakeTranslation(0, height);
        
    }
    
    int index = 0;
    
    for (UICollectionViewCell *cell in cells) {
        
        [UIView animateWithDuration:0.8 delay:0.05 * index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
        
        index += 1;
    }
}


-(void)getValues{
    
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId =[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    
}
//service calling for getting neghborhood times list
- (void) serviceCallingForNeghhoodTimes{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"token=%@&u_id=%@&device_id=%@&city_id=%@&neg_id=%@",getToken,getUserId,gettedDeviceId,getCityId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_NEGHTIMES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                                  
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.collectionViewNeghTimes.hidden=NO;
                     self.collectionViewNeghTimes.backgroundView = messageLabel;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateCollectionView];
                     
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
#pragma mark  UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return profileData.profile.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    profileInfoModel=profileData.profile[indexPath.row];
    
    if (profileInfoModel.tweet_image.length==0) {
        WHNeghborTimesCollectionViewCell *cell = (WHNeghborTimesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:WHNEGHTIMES_CELL forIndexPath:indexPath];
        profileInfoModel=profileData.profile[indexPath.row];
        cell.layer.cornerRadius=2.0f;
        cell.layer.masksToBounds=YES;
        cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth=0.5f;
        cell.backgroundColor=[UIColor clearColor];
         cell.labelStatus.numberOfLines=0;
        cell.labelStatus.lineBreakMode=NSLineBreakByWordWrapping;
       
            cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
             tempString = [profileInfoModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //LAZY LOADING.
            NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,tempString];
            [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
     
        cell.labelStatus.text=[NSString stringWithFormat:@"%@",profileInfoModel.message];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:profileInfoModel.posted_date];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.timeAgoSinceNow];
        cell.labelComments.text=[NSString stringWithFormat:@"%@ Comments",profileInfoModel.comments];
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        countComments=[profileInfoModel.comments intValue];
        dividedComments=countComments/5;
        cell.labelComments.text=[NSString stringWithFormat:@"%@ comments",profileInfoModel.comments];
        
        return cell;
        
    }
    else{
        
        WHNeghtimesWithImageCollectionViewCell *cell = (WHNeghtimesWithImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:WHNEGHTIMES_IMAGE_CELL forIndexPath:indexPath];
        profileInfoModel=profileData.profile[indexPath.row];
        cell.layer.cornerRadius=2.0f;
        cell.layer.masksToBounds=YES;
        cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth=0.5f;
        cell.backgroundColor=[UIColor clearColor];
        cell.labelStatus.numberOfLines=0;
        cell.labelStatus.lineBreakMode=NSLineBreakByWordWrapping;
        tempString = [profileInfoModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,tempString];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        newString = [profileInfoModel.tweet_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
            NSString *final_Image_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,newString];
        
            
            [cell.imageViewTweetPic sd_setImageWithURL:[NSURL URLWithString:final_Image_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
            tempString = [profileInfoModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.labelStatus.text=[NSString stringWithFormat:@"%@",profileInfoModel.message];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:profileInfoModel.posted_date];
      cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.timeAgoSinceNow];
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        newString = [profileInfoModel.tweet_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.labelComments.text=[NSString stringWithFormat:@"%@ comments",profileInfoModel.comments];
     
        return cell;
        
        
    }
    
    
}
#pragma mark  UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    profileInfoModel=profileData.profile[indexPath.row];
    
    if (profileInfoModel.tweet_image.length==0) {
        CGSize constraint = CGSizeMake(225, 20000);
        
        // Size for Name
        
        NSString *name = [NSString stringWithFormat:@"%@",profileInfoModel.message];
        
        CGFloat heightName = 0.0;
        
        
        if (profileInfoModel.message.length > 0) {
            
            NSAttributedString *attributedTextName =  [[NSAttributedString alloc] initWithString:name];
            
            CGRect rectName= [attributedTextName boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGSize sizeName   = rectName.size;
            
            heightName = MAX(sizeName.height, 21.0f);
            
        }
       
        
        float tempHeight = heightName + 60;
        
        NSInteger tempppHeight=tempHeight;
        NSInteger height= tempppHeight;
        
        NSInteger width = collectionView.frame.size.width - 20;
        return CGSizeMake(width, height);
    }
    else{
        
        CGSize constraint = CGSizeMake(225, 20000);
        
        // Size for Name
        
        NSString *name = [NSString stringWithFormat:@"%@",profileInfoModel.message];
        
        CGFloat heightName = 0.0;
        
        
        if (profileInfoModel.message.length > 0) {
            
            NSAttributedString *attributedTextName =  [[NSAttributedString alloc] initWithString:name];
            
            CGRect rectName= [attributedTextName boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGSize sizeName   = rectName.size;
            
            heightName = MAX(sizeName.height, 21.0f);
            
        }
        NSInteger height= 275 + heightName;
        NSInteger width = collectionView.frame.size.width - 20;
        return CGSizeMake(width, height);
    }
    
    
}

#pragma mark  UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    getIndexPath=indexPath;
    profileInfoModel=profileData.profile[indexPath.row];
    if (profileInfoModel.tweet_image.length==0) {
        [self performSegueWithIdentifier:@"neghtimesOnlyTextSegueVC" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"neghTimesDetailsSegueVC" sender:nil];
    }
}


////service calling for getting filtered result
//- (void) serviceCallingFilteredNeghTimes{
//
//    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
//
//        // Show Progress bar.
//        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
//
//        NSString *details = [NSString stringWithFormat:@"token=%@&u_id=%@&temp=%d",getToken,getUserId,temp];
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // Code executed in the background
//
//            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FILTERED_NEGHTIMES]
//                                           bodyString:details
//                                           completion:^(NSDictionary *json, JSONModelError *err)
//             {
//
//
//
//                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
//                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
//                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
//
//                 if ([tokenStatus.error isEqualToString:@"0"]) {
//                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
//                 }
//                 else if ([messageStatus.Msg isEqualToString:@"0"]){
//                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No record found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
//                 }
//                 else{
//                     self.collectionViewNeghTimes.hidden=NO;
//                     self.viewFilterSort.hidden=YES;
//                 }
//
//
//                 // Update UI in main thread.
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [self animateCollectionView];
//
//                     // Hide Progress bar.
//                     [SVProgressHUD dismiss];
//                 });
//
//             }];
//
//        });
//
//    }
//
//
//    else {
//        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
//    }
//
//}

//Sorting Service

//service calling for getting Sorted result
- (void) serviceCallingSortedNeghTimes{
    

    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"token=%@&u_id=%@&value=%d&device_id=%@&city_id=%@&neg_id=%@",getToken,getUserId,value,gettedDeviceId,getCityId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_SORTED_NEGHTIMES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 

                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No record found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else{
                     self.collectionViewNeghTimes.hidden=NO;
                     self.viewFilterSort.hidden=YES;
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateCollectionView];
                     
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //code when there is image in the cell i.e tweet with image
    if([segue.identifier isEqualToString:@"neghTimesDetailsSegueVC"]){
        
        WHNeghtimesWithImageCollectionViewCell *cell =(WHNeghtimesWithImageCollectionViewCell *)[self.collectionViewNeghTimes cellForItemAtIndexPath:getIndexPath];
        WHNeghTimesDetailsViewController *secondVC = segue.destinationViewController;
        secondVC.getImagePath = cell.imageViewProfilePic.image;
        secondVC.getMessage=profileInfoModel.message;
        secondVC.getDate=profileInfoModel.posted_date;
        secondVC.getFirstName=profileInfoModel.first_name;
        secondVC.getLastName=profileInfoModel.last_name;
        secondVC.postId=profileInfoModel.post_id;
        secondVC.postedById=profileInfoModel.user_id;
        secondVC.getImageString=cell.imageViewTweetPic.image;
        secondVC.indicator=1;
        secondVC.getImageStringUrl=profileInfoModel.tweet_image;
        
        
    }
    else if ([segue.identifier isEqualToString:@"neghtimesOnlyTextSegueVC"]){
        
        WHNeghborTimesCollectionViewCell *cell =(WHNeghborTimesCollectionViewCell *)[self.collectionViewNeghTimes cellForItemAtIndexPath:getIndexPath];
        WHNeghtimesTextViewController *secondVC = segue.destinationViewController;
        secondVC.getImagePath = cell.imageViewProfilePic.image;
        secondVC.getMessage=profileInfoModel.message;
        secondVC.getDate=profileInfoModel.posted_date;
        secondVC.getFirstName=profileInfoModel.first_name;
        secondVC.getLastName=profileInfoModel.last_name;
        secondVC.postId=profileInfoModel.post_id;
        secondVC.postedById=profileInfoModel.user_id;
        secondVC.indicator=1;
        
    }
    else if ([segue.identifier isEqualToString:@"addTweetSegueVC"]){
        
        WHAddNeghTimesTweetViewController *secondVC = segue.destinationViewController;
        secondVC.gettedCityId=getCityId;
        secondVC.gettedNeghId=getNeighbourhoodId;
        
    }
    
    
}

//Button Action
- (IBAction)barButtonAddTweetPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addTweetSegueVC" sender:nil];
}



//Sorting and Filter Button Actions
- (IBAction)buttonSortPressed:(id)sender {
    
    if (isPressed==0) {
        clicked=1;
        isPressed=1;
        [self.buttonLeftSide setTitle:@"Most Commented" forState:UIControlStateNormal];
        [self.buttonRightSide setTitle:@"Most Recent" forState:UIControlStateNormal];
        self.collectionViewNeghTimes.hidden=YES;
        self.viewFilterSort.hidden=NO;
        
        
    }
    else if (isPressed==1){
        isPressed=0;
        self.collectionViewNeghTimes.hidden=NO;
        self.viewFilterSort.hidden=YES;
    }
}

//FILTER CODE
/*
 - (IBAction)buttonFilterPressed:(id)sender {
 
 if (isPressed==0) {
 clicked=2;
 isPressed=1;
 self.collectionViewNeghTimes.hidden=YES;
 self.viewFilterSort.hidden=NO;
 [self.buttonLeftSide setTitle:@"Own Tweets" forState:UIControlStateNormal];
 [self.buttonRightSide setTitle:@"Neighbours Tweets" forState:UIControlStateNormal];
 }
 else if (isPressed==1){//Own Tweets
 isPressed=0;
 self.collectionViewNeghTimes.hidden=NO;
 self.viewFilterSort.hidden=YES;
 }
 }
 */
- (IBAction)buttonLeftSidePressed:(id)sender {
    if (clicked==1) {
        //Most Commented Case
        value=1;
        isPressed=0;
        [self serviceCallingSortedNeghTimes];
        
    }
    //    else if (clicked==2){
    //        //Own Tweets Case
    //        temp=1;
    //        [self serviceCallingFilteredNeghTimes];
    //    }
}

- (IBAction)buttonRightSidePressed:(id)sender {
    if (clicked==1) {
        //Most Recented Case
        // value=2;
        isPressed=0;
        self.collectionViewNeghTimes.hidden=NO;
        self.viewFilterSort.hidden=YES;
        [self serviceCallingForNeghhoodTimes];
    }
    //    else if (clicked==2){
    //        //Neighbours Tweets Case
    //        temp=2;
    //        [self serviceCallingFilteredNeghTimes];
    //    }
}


//Reset button action
/*
 - (IBAction)buttonResetPressed:(id)sender {
 clicked=0;
 isPressed=0;
 self.collectionViewNeghTimes.hidden=NO;
 self.viewFilterSort.hidden=YES;
 [self serviceCallingForNeghhoodTimes];
 }
 */


#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}



@end
