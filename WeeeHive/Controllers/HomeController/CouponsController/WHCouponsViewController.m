//
//  WHCouponsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHCouponsViewController.h"
#import "Constant.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHSingletonClass.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHCouponTextOnlyTableViewCell.h"

#import "WHCouponTextImageViewController.h"
#import "WHCouponFlyerOnlyViewController.h"
#import "WHCouponsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WHCouponsDetailsViewController.h"
#import "WHCouponsListCollectionViewCell.h"
#import "NSDate+DateTools.h"

@interface WHCouponsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSDate *orignalDate;
    NSString *finalDate;
    NSIndexPath *getIndexPath;
    NSString *gettedDeviceId;
    NSDate *originalDate;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSString *imageUrl;
    NSString *getCityId;
    NSString *getNeighbourhoodId;
    
    NSUserDefaults *defaults;
    
}


@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCoupons;

@end

@implementation WHCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    self.collectionViewCoupons.alwaysBounceVertical = YES;
    [self.collectionViewCoupons addSubview:refreshControl];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self serviceCallingForGettingCoupons];
    
}

- (void)refresh {
    
    [self serviceCallingForGettingCoupons];
    
    
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
    titleView.text =@"Flyers & Coupons";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)animateCollectionView {
    
    [self.collectionViewCoupons reloadData];
    NSArray *cells = self.collectionViewCoupons.visibleCells;
    CGFloat height = self.collectionViewCoupons.bounds.size.height;
    
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

- (void)getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
}

//service calling for getting Coupons
- (void) serviceCallingForGettingCoupons{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&city_id=%@&neg_id=%@",getUserId,getToken,gettedDeviceId,getCityId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_COUPONS]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.collectionViewCoupons.hidden=NO;
                     self.collectionViewCoupons.backgroundView = messageLabel;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
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

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
     return profileData.profile.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WHCouponsListCollectionViewCell *cell = (WHCouponsListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:WHCOUPONS_CELL forIndexPath:indexPath];
    profileInfoModel=profileData.profile[indexPath.row];
    
    if ([profileInfoModel.text isEqualToString:@""]){
        
        //LAZY LOADING.
        NSString *final1_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.coupon_image];
        [cell.imageViewCoupon sd_setImageWithURL:[NSURL URLWithString:final1_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        cell.labelText.hidden=YES;
        cell.layer.cornerRadius=2.0f;
        cell.layer.masksToBounds=YES;
        cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth=0.5f;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:profileInfoModel.posted_date];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.timeAgoSinceNow];
        NSString  *tempString = [profileInfoModel.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //LAZY LOADING.
         imageUrl = [NSString stringWithFormat:@"%@%@", MAIN_URL,tempString];
        [cell.imageViewCoupon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return  cell;
        
    }
    
    else{
        
        //LAZY LOADING.
        NSString *final1_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.coupon_image];
        [cell.imageViewCoupon sd_setImageWithURL:[NSURL URLWithString:final1_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        cell.labelText.hidden=NO;
        cell.labelText.text=[NSString stringWithFormat:@"%@",profileInfoModel.text];
        cell.labelText.numberOfLines=0;
        cell.labelText.lineBreakMode=NSLineBreakByWordWrapping;
        cell.layer.cornerRadius=2.0f;
        cell.layer.masksToBounds=YES;
        cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth=0.5f;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:profileInfoModel.posted_date];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.timeAgoSinceNow];
        
        //LAZY LOADING.
        imageUrl = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewCoupon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
     
        return cell;
        
    }

}


#pragma mark  UICollectionView Delegate.

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    getIndexPath =indexPath;
    profileInfoModel = profileData.profile[indexPath.row];
    if ([profileInfoModel.text isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"couponsDetailsSegueVC" sender:nil];
    }
    else if ([profileInfoModel.coupon_image isEqualToString:@""]){
        [self performSegueWithIdentifier:@"CouponTextOnlySegueVC" sender:nil];
    }
    else{
        
        [self performSegueWithIdentifier:@"couponTextImageSegueVC" sender:nil];
    }
}
#pragma mark  UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger width = collectionView.frame.size.width - 30;
    return CGSizeMake(width/2, width/2);
}

#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"couponsDetailsSegueVC"]) {
        
        WHCouponsListCollectionViewCell *cell = (WHCouponsListCollectionViewCell *)[self.collectionViewCoupons cellForItemAtIndexPath:getIndexPath];
        WHCouponsDetailsViewController *secondVC = segue.destinationViewController;
        secondVC.getImage = cell.imageViewCoupon.image;
        secondVC.imageString=profileInfoModel.coupon_image;
        secondVC.getContentId=profileInfoModel.id;
    }
    else if ([segue.identifier isEqualToString:@"couponTextImageSegueVC"]){
        
        WHCouponsListCollectionViewCell *cell = (WHCouponsListCollectionViewCell *)[self.collectionViewCoupons cellForItemAtIndexPath:getIndexPath];
        WHCouponTextImageViewController *secondVC = segue.destinationViewController;
        secondVC.getImage = cell.imageViewCoupon.image;
        secondVC.imageString=profileInfoModel.coupon_image;
        secondVC.getTextFlyer=profileInfoModel.text;
        secondVC.getContentId=profileInfoModel.id;
    }
    else if ([segue.identifier isEqualToString:@"CouponTextOnlySegueVC"]){
        
        WHCouponFlyerOnlyViewController *secondVC = segue.destinationViewController;
        secondVC.getText=profileInfoModel.text;
        secondVC.getContentId=profileInfoModel.id;
    }
    else if ([segue.identifier isEqualToString:@"addCouponSegueVC"]){
        
    }
    else{
        
    }
    
}
- (IBAction)barButtonAddCouponPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addCouponSegueVC" sender:nil];
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
