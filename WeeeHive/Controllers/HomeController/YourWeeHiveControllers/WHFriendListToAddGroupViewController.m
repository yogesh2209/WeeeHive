
//
//  WHFriendListToAddGroupViewController.m
//  WeeeHive
//
//  Created by Schoofi on 11/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHFriendListToAddGroupViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHFriendListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WHStatusModel.h"
#import "WHYourWeehiveViewController.h"

@interface WHFriendListToAddGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    WHProfileModel *neghProfileData;
    WHProfileDetailsModel *neghProfileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHStatusModel *statusData;
    WHSingletonClass *sharedObject;
    
    NSUserDefaults *defaults;
    NSString *getUserId;
    NSString *getToken;
    NSInteger finalCount;
    int temp;
    NSIndexPath *getIndexPath;
    NSString *gettedGroupId;
     NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFriendList;

@end

@implementation WHFriendListToAddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    self.tableViewFriendList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewFriendList addSubview:refreshControl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getValueLastScreen];
    [self serviceCallingForGettingListOfNeighbours];
}

- (void)refresh {
    
    
    [self serviceCallingForGettingListOfNeighbours];
    
    
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
    titleView.text =@"Add Friends";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}


- (void)animateTableView {
    
    [self.tableViewFriendList reloadData];
    NSArray *cells = self.tableViewFriendList.visibleCells;
    CGFloat height = self.tableViewFriendList.bounds.size.height;
    
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

- (void)getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    
}

-(void) getValueLastScreen{
    
    gettedGroupId=self.getGroupId;
    
}

//service calling for getting list of friends
- (void) serviceCallingForGettingListOfNeighbours{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&group_id=%@&device_id=%@",getUserId,getToken,gettedGroupId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FRIENDSLISTTOADDGROUP]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {

                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 neghProfileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewFriendList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewFriendList.hidden=NO;
                     self.tableViewFriendList.backgroundView = messageLabel;
                     self.tableViewFriendList.separatorStyle = UITableViewCellSeparatorStyleNone;
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

//service calling for sending attendance Record to server.
- (void) serviceCallingAddingFriends : (NSString *) Friends {
    
    self.tableViewFriendList.hidden=NO;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDFRIENDSGROUP]
                                           bodyString:Friends
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
           
                 
                 statusData=[[WHStatusModel alloc]initWithDictionary:json error:&err];
                 
                 
                 if ([statusData.status isEqualToString:@"1"]){
                     
                     [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Friends added successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                     
                 }
                 else{
                     
                     
                     [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                     
                     
                 }
                 
                 
                 // Hide Progress bar.
                 [SVProgressHUD dismiss];
                 
                 
             }];
            
        });
        
    }
    
    
    else {
        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
    }
    
}




#pragma mark  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    finalCount=neghProfileData.profile.count;
    return neghProfileData.profile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHFriendListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:WHFRIENDLIST_CELL];
    neghProfileInfoModel=neghProfileData.profile[indexPath.row];
    cell.labelName.text=[NSString stringWithFormat:@"%@ %@",neghProfileInfoModel.first_name,neghProfileInfoModel.last_name];
    cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
    cell.imageViewProfilePic.layer.masksToBounds=YES;
    cell.imageViewProfilePic.layer.borderWidth=0;
    
    neghProfileInfoModel.group_id=self.getGroupId;
    neghProfileInfoModel.count=(int) finalCount;
    //LAZY LOADING.
    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,neghProfileInfoModel.image];
    [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
    
    if ([neghProfileInfoModel.isAdded isEqualToString:@"0"]) {
        
        temp=1;
        cell.imageViewCheckMark.image=[UIImage imageNamed:@"empty"];
    }
    else {
        
        temp=2;
        cell.imageViewCheckMark.image=[UIImage imageNamed:@"tick"];
    }
    
    return  cell;
}

#pragma mark  UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    getIndexPath=indexPath;
    WHFriendListTableViewCell *cell= (WHFriendListTableViewCell *)[tableView cellForRowAtIndexPath:getIndexPath];
 
    neghProfileInfoModel=neghProfileData.profile[indexPath.row];
    if([neghProfileInfoModel.isAdded isEqualToString:@"1"]) {
        
        temp=2;
        cell.imageViewCheckMark.image=[UIImage imageNamed:@"empty"];
        neghProfileInfoModel.isAdded = @"0";
    }
    else
        
    {
        temp=1;
        cell.imageViewCheckMark.image=[UIImage imageNamed:@"tick"];
        neghProfileInfoModel.isAdded = @"1";
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)buttonAddPressed:(id)sender {
  
    [self serviceCallingAddingFriends:[neghProfileData toJSONString]];
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.getIndicatorValue==1) {
        if (buttonIndex==0) {
            if ([statusData.status isEqualToString:@"1"] || [messageStatus.Msg isEqualToString:@"0"]) {
                
                for (UIViewController *controller in self.navigationController.viewControllers)
                {
                    if ([controller isKindOfClass:[WHYourWeehiveViewController class]])
                    {
                        
                        [self.navigationController popToViewController:controller animated:YES];
                        
                        break;
                    }
                }
            }
            else if ([tokenStatus.error isEqualToString:@"0"]){
                sharedObject.singletonIsLoggedIn=0;
                
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else {
            
        }
    }
    else{
        if (buttonIndex==0) {
            if ([statusData.status isEqualToString:@"1"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if ([tokenStatus.error isEqualToString:@"0"]){
                sharedObject.singletonIsLoggedIn=0;

                        NSString *string=@"0";
                        [defaults setObject:string forKey:@"LOGGED"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }
            
        }
        else {
            
        }
        
    }
}

@end
