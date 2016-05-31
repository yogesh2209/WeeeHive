//
//  WHGroupRequestsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 10/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHGroupRequestsViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHGroupRequestsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WHYourWeehiveModel.h"
#import "WHYourWeehiveDetailsModel.h"

@interface WHGroupRequestsViewController (){
    
    WHYourWeehiveModel *weehiveData;
    WHYourWeehiveDetailsModel *weehiveInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    NSString *getUserId;
    NSString *getToken;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSString *friendUserId;
    //Indicates whether request is accepted or rejected.
    int indicator;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewGroupRequestList;

@end

@implementation WHGroupRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    self.tableViewGroupRequestList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewGroupRequestList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self serviceCallingForGettingListOfRequests];
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Weehive Requests";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)refresh {
    
    
    [self serviceCallingForGettingListOfRequests];
    
    
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

- (void)getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
}

- (void)animateTableView {
    
    [self.tableViewGroupRequestList reloadData];
    NSArray *cells = self.tableViewGroupRequestList.visibleCells;
    CGFloat height = self.tableViewGroupRequestList.bounds.size.height;
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

//service calling for getting Requests.
- (void) serviceCallingForGettingListOfRequests{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",getUserId,getToken,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_GROUPREQUEST]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 weehiveData=[[WHYourWeehiveModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewGroupRequestList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No pending Weehive Requests. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewGroupRequestList.hidden=NO;
                     self.tableViewGroupRequestList.backgroundView = messageLabel;
                     self.tableViewGroupRequestList.separatorStyle = UITableViewCellSeparatorStyleNone;
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

//service calling for handling Group/Weehive Request
- (void) serviceCallingForActionRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&friends_u_id=%@&value=%d",getUserId,getToken,gettedDeviceId,friendUserId,indicator];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ACTIONGROUPREQUEST]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 

                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                     [self serviceCallingForGettingListOfRequests];
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



//#pragma mark  UITableView dataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return weehiveData.group.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    WHGroupRequestsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:POST_GROUPREQUESTCELL];
//    weehiveInfoModel=weehiveData.group[indexPath.row];
//    cell.labelGroupName.text=[NSString stringWithFormat:@"%@",weehiveInfoModel.group_name];
//    cell.buttonAccept.tag=indexPath.row;
//    cell.labelUserName.text=[NSString stringWithFormat:@"%@ %@",weehiveInfoModel.first_name,weehiveInfoModel.last_name];
//    [cell.buttonAccept addTarget:self action:@selector(acceptButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.buttonIgnore.tag=indexPath.row;
//    [cell.buttonIgnore addTarget:self action:@selector(ignoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.buttonAccept.layer.cornerRadius=2.0f;
//    cell.buttonAccept.layer.masksToBounds=YES;
//    cell.buttonIgnore.layer.cornerRadius=2.0f;
//    cell.buttonIgnore.layer.masksToBounds=YES;
//    cell.imageViewGroupPicture.layer.cornerRadius=cell.imageViewGroupPicture.frame.size.height/2;
//    cell.imageViewGroupPicture.layer.masksToBounds=YES;
//    
//    //LAZY LOADING.
//    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,weehiveInfoModel.image];
//    [cell.imageViewGroupPicture sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
//    
//    return  cell;
//}

-(void)acceptButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
     weehiveInfoModel=weehiveData.group[senderButton.tag];
    friendUserId=weehiveInfoModel.request_by;
    indicator=1;
    [self serviceCallingForActionRequest];
}

-(void)ignoreButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
     weehiveInfoModel=weehiveData.group[senderButton.tag];
    friendUserId=weehiveInfoModel.request_by;
    indicator=2;
    [self serviceCallingForActionRequest];
}



@end
