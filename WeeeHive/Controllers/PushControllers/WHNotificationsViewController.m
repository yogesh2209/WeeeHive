//
//  WHNotificationsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 02/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHNotificationsViewController.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"
#import "AppDelegate.h"
#import "NSDate+DateTools.h"
#import "WHNotificationsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WHPushNotificationsListDetailsModel.h"
#import "WHPushNotificationsListModel.h"

#import "WHCouponsViewController.h"
#import "WHPulsePollViewController.h"
#import "WHNotificationsViewController.h"
#import "WHRequestsPushViewController.h"
#import "WHNeighborTimesViewController.h"
#import "WHYourNeighborhoodMsgsChattingViewController.h"
#import "WHWeehiveDetailsViewController.h"
#import "WHMessagesPushViewController.h"

@interface WHNotificationsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    WHPushNotificationsListModel *pushData;
    WHPushNotificationsListDetailsModel *pushInfoModel;
    WHMessageModel *messageStatus;

    NSDate *originalDate;
    NSString *getUserId;
    NSString *getToken;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewNotificationsList;

@end

@implementation WHNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
   
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    self.tableViewNotificationsList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewNotificationsList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self serviceCallingForGettingNotificationsList];
}

- (void)animateTableView {
    
    [self.tableViewNotificationsList reloadData];
    NSArray *cells = self.tableViewNotificationsList.visibleCells;
    CGFloat height = self.tableViewNotificationsList.bounds.size.height;
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

- (void)refresh {
    
    [self serviceCallingForGettingNotificationsList];
    
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
    titleView.text =@"Notifications";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)getValues{
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
}

//service calling for getting notifications list
- (void) serviceCallingForGettingNotificationsList{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&device_id=%@",getUserId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_PUSHNOTIFICATIONLIST]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                
                 
                 pushData=[[WHPushNotificationsListModel alloc] initWithDictionary:json error:&err];
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewNotificationsList.hidden=NO;
                     self.tableViewNotificationsList.backgroundView = messageLabel;
                     self.tableViewNotificationsList.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     
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
    return pushData.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHNotificationsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:POST_NOTIFICATIONLISTCELL];
    pushInfoModel=pushData.notifications[indexPath.row];
    cell.labelHeading.text=[NSString stringWithFormat:@"%@",pushInfoModel.payload];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    originalDate   =  [dateFormatter dateFromString:pushInfoModel.date_time];
    cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.timeAgoSinceNow];
    cell.labelHeading.numberOfLines=0;
    cell.labelHeading.lineBreakMode=NSLineBreakByWordWrapping;
    
    //LAZY LOADING.
    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,pushInfoModel.image];
    [cell.imageMain sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
    return  cell;

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    pushInfoModel=pushData.notifications[indexPath.row];
//    CGSize constraint = CGSizeMake(225, 20000);
//    
//    // Size for payload
//    NSString *name = [NSString stringWithFormat:@"%@",pushInfoModel.payload];
//    
//    CGFloat heightName = 0.0;
//    
//    if (name.length > 0) {
//        
//        NSAttributedString *attributedTextName =  [[NSAttributedString alloc] initWithString:name];
//        
//        CGRect rectName= [attributedTextName boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        
//        CGSize sizeName   = rectName.size;
//        
//        heightName = MAX(sizeName.height, 21.0f);
//        
//    }
//    
//    return 15 + heightName + 10  + 10 + 21 + 5;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    pushInfoModel=pushData.notifications[indexPath.row];
    
    NSString *tag=pushInfoModel.tag;
    int tagValue= [tag intValue];
    //FRIEND REQUEST PUSH OR GROUP REQUEST PUSH
    if (tagValue == 1 || tagValue==2) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
         UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        UINavigationController *navVc=(UINavigationController *) window.rootViewController;
        WHRequestsPushViewController *someVC = (WHRequestsPushViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"requestsStoryBoard"];
       //[self presentViewController:someVC animated:YES completion:nil];
        [navVc pushViewController: someVC animated:YES];
    }
    //NEIGHBOUR CHAT PUSH || GROUP CHAT PUSH
    else if (tagValue == 3 || tagValue==4){
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        UINavigationController *navVc=(UINavigationController *) window.rootViewController;
        WHMessagesPushViewController *someVC = (WHMessagesPushViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"messagesStoryBoard"];
       // [self presentViewController:someVC animated:YES completion:nil];
        [navVc pushViewController: someVC animated:YES];
    }
    //POLL ADD PUSH
    else if (tagValue==5){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        UINavigationController *navVc=(UINavigationController *)window.rootViewController;
        WHPulsePollViewController *someVC = (WHPulsePollViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"pollStoryBoard"];
       // [self presentViewController:someVC animated:YES completion:nil];
       [navVc pushViewController: someVC animated:YES];
    }
    //COUPON ADD PUSH
    else if (tagValue==6){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        UINavigationController *navVc=(UINavigationController *)window.rootViewController;
        WHCouponsViewController *someVC = (WHCouponsViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"couponsStoryBoard"];
      //  [self presentViewController:someVC animated:YES completion:nil];
       [navVc pushViewController: someVC animated:YES];
    }
    //NEIGH TIMES ADD
    else if (tagValue==7){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
        UINavigationController *navVc=(UINavigationController *) window.rootViewController;
        WHNeighborTimesViewController *someVC = (WHNeighborTimesViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"neghTimesStoryBoard"];
        [navVc pushViewController: someVC animated:YES];
        //[self presentViewController:someVC animated:YES completion:nil];
    }
    //ACTION FRIEND REQUEST PUSH OR ACTION GROUP REQUEST PUSH
    else if (tagValue == 8 || tagValue==9){
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        UIWindow* window = [[UIApplication sharedApplication] keyWindow];
//        UINavigationController *navVc=(UINavigationController *) window.rootViewController;
//        WHNotificationsViewController *someVC = (WHNotificationsViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"notificationsStoryBoard"];
//        [navVc pushViewController: someVC animated:YES];
//        //[self presentViewController:someVC animated:YES completion:nil];
    }
    
    else{
        
    }

}


@end
