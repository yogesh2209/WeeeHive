//  WHRequestsPushViewController.m
//  WeeeHive
//
//  Created by Schoofi on 02/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.

#import "WHRequestsPushViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHRequestsPushTableViewCell.h"
#import "WHGroupRequestsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface WHRequestsPushViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    NSString *getUserId;
    NSString *getToken;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSString *friendUserId;
    NSString *getGroupId;
    //Indicates whether request is accepted or rejected.
    int indicator;
    
    NSString *getFirstName;
    NSString *getLastName;
    NSString *gettedImageString;
    
    NSUserDefaults *defaults;
   
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewRequestsList;

@end

@implementation WHRequestsPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    self.tableViewRequestsList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewRequestsList addSubview:refreshControl];
    defaults=[NSUserDefaults standardUserDefaults];
   
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
    titleView.text =@"Friend Requests";
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
    getFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager] singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
}

- (void)animateTableView {
    
    [self.tableViewRequestsList reloadData];
    NSArray *cells = self.tableViewRequestsList.visibleCells;
    CGFloat height = self.tableViewRequestsList.bounds.size.height;
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
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FRIENDREQUESTS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewRequestsList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No pending friend Requests. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewRequestsList.hidden=NO;
                     self.tableViewRequestsList.backgroundView = messageLabel;
                     self.tableViewRequestsList.separatorStyle = UITableViewCellSeparatorStyleNone;
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

//service calling for Sending Friend Request
- (void) serviceCallingForActionFriendRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&friend_id=%@&value=%d&first_name=%@&last_name=%@&image=%@",getUserId,getToken,gettedDeviceId,friendUserId,indicator,getFirstName,getLastName,gettedImageString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ACTIONREQUEST]
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

//service calling for handling Group/Weehive Request
- (void) serviceCallingForActionGroupRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&friends_u_id=%@&value=%d&group_id=%@&first_name=%@&last_name=%@&image=%@",getUserId,getToken,gettedDeviceId,friendUserId,indicator,getGroupId,getFirstName,getLastName,gettedImageString];
        
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



#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return profileData.profile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    profileInfoModel=profileData.profile[indexPath.row];

    if ([profileInfoModel.group_id isEqualToString:@""]) {
        //code when friend request is there.
        WHRequestsPushTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:POST_REQUESTSCELL];
        profileInfoModel=profileData.profile[indexPath.row];
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        cell.buttonAccept.tag=indexPath.row;
        [cell.buttonAccept addTarget:self action:@selector(acceptButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonIgnore.tag=indexPath.row;
        [cell.buttonIgnore addTarget:self action:@selector(ignoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonAccept.layer.cornerRadius=2.0f;
        cell.buttonAccept.layer.masksToBounds=YES;
        cell.buttonIgnore.layer.cornerRadius=2.0f;
        cell.buttonIgnore.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return  cell;

    }
    else{
        //code when group request is there.
        WHGroupRequestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:POST_GROUPREQUESTCELL];
        profileInfoModel=profileData.profile[indexPath.row];
        cell.labelLine.text=[NSString stringWithFormat:@"%@ %@ has asked to join the group %@",profileInfoModel.first_name,profileInfoModel.last_name,profileInfoModel.group_name];
        cell.buttonAccept.tag=indexPath.row;
        [cell.buttonAccept addTarget:self action:@selector(acceptButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonIgnore.tag=indexPath.row;
        [cell.buttonIgnore addTarget:self action:@selector(ignoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonAccept.layer.cornerRadius=2.0f;
        cell.buttonAccept.layer.masksToBounds=YES;
        cell.buttonIgnore.layer.cornerRadius=2.0f;
        cell.buttonIgnore.layer.masksToBounds=YES;
        cell.labelLine.numberOfLines=0;
        cell.labelLine.numberOfLines=0;
        cell.labelLine.lineBreakMode=NSLineBreakByWordWrapping;
        cell.imageViewGroupPicture.layer.cornerRadius=cell.imageViewGroupPicture.frame.size.height/2;
        cell.imageViewGroupPicture.layer.masksToBounds=YES;
        
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewGroupPicture sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];

        return  cell;
    }
    
}

//button accept click
-(void)acceptButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
    profileInfoModel=profileData.profile[senderButton.tag];
    if ([profileInfoModel.group_id isEqualToString:@""]) {
        //code to handle friend request
        friendUserId=profileInfoModel.request_by;
        indicator=1;
        [self serviceCallingForActionFriendRequest];
    }
    else{
       //code to handle group request
        //code to handle group request
        friendUserId=profileInfoModel.request_by;
        getGroupId=profileInfoModel.group_id;
        indicator=1;
        [self serviceCallingForActionGroupRequest];
        
    }
    
   
}

//button reject click
-(void)ignoreButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
    profileInfoModel=profileData.profile[senderButton.tag];
    if ([profileInfoModel.group_id isEqualToString:@""]) {
        //code to handle friend request
        friendUserId=profileInfoModel.request_by;
        indicator=2;
        [self serviceCallingForActionFriendRequest];
    }
    else{
        //code to handle group request
        friendUserId=profileInfoModel.request_by;
        getGroupId=profileInfoModel.group_id;
        indicator=2;
        [self serviceCallingForActionGroupRequest];
    }
    
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if ([tokenStatus.error isEqualToString:@"0"]) {
            NSString *string=@"0";
            [defaults setObject:string forKey:@"LOGGED"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    }
}

@end
