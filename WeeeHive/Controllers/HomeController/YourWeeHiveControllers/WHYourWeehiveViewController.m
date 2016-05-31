//
//  WHYourWeehiveViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHYourWeehiveViewController.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "ASNetworkAlertClass.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHYourWeehiveModel.h"
#import "WHYourWeehiveDetailsModel.h"
#import "WHYourWeehiveTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WHWeehiveDetailsViewController.h"
#import "WHWeehiveGroupMembersViewController.h"


@interface WHYourWeehiveViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    WHYourWeehiveModel *weehiveData;
    WHYourWeehiveDetailsModel *weehiveInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    BOOL isClicked;
    NSString *getUserId;
    NSString *getToken;
    NSString *getExitedGroupId;
    NSMutableArray *weehiveArray;
    NSArray *weehiveFinalArray;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSString *getGroupId;
    NSString *getCityId;
    NSString *getNeighbourhoodId;
    NSString *getCreatedById;
    int isRequestSent;
    
    NSString *gettedFirstName;
    NSString *gettedLastName;
    NSString *gettedImageString;
    NSUserDefaults *defaults;
}


@property (weak, nonatomic) IBOutlet UITableView *tableViewWeehives;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *viewFilter;
@property (strong, nonatomic) IBOutlet UIButton *buttonOwnWeehives;
@property (strong, nonatomic) IBOutlet UIButton *buttonAllWeehives;


@end

@implementation WHYourWeehiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    weehiveArray=[NSMutableArray new];
    weehiveFinalArray=[[NSArray alloc]init];
    [self customizeUI];
    self.tableViewWeehives.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewWeehives addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.viewFilter.hidden=YES;
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    self.buttonAllWeehives.hidden=YES;
    self.buttonOwnWeehives.hidden=YES;
    [self serviceCallingForWeehive];
    
}

- (void)refresh {
    
    [self serviceCallingForWeehive];
    
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
    titleView.text =@"Your Weehives";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.viewFilter.backgroundColor=[UIColor clearColor];
    self.viewFilter.layer.cornerRadius=2.0f;
    self.viewFilter.layer.masksToBounds=YES;
    self.viewFilter.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewFilter.layer.borderWidth=0.5f;
    
    
    self.buttonAllWeehives.backgroundColor=[UIColor clearColor];
    self.buttonAllWeehives.layer.cornerRadius=2.0f;
    self.buttonAllWeehives.layer.masksToBounds=YES;
    self.buttonAllWeehives.layer.borderWidth=0.5f;
    self.buttonAllWeehives.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.buttonOwnWeehives.backgroundColor=[UIColor clearColor];
    self.buttonOwnWeehives.layer.cornerRadius=2.0f;
    self.buttonOwnWeehives.layer.masksToBounds=YES;
    self.buttonOwnWeehives.layer.borderWidth=0.5f;
    self.buttonOwnWeehives.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
}

- (void)animateTableView {
    
    [self.tableViewWeehives reloadData];
    NSArray *cells = self.tableViewWeehives.visibleCells;
    CGFloat height = self.tableViewWeehives.bounds.size.height;
    
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
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    gettedFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
   
}

//service calling for Weehive
- (void) serviceCallingForWeehive{
    
    [weehiveArray removeAllObjects];
    weehiveFinalArray = nil;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&city_id=%@&neg_id=%@",getUserId,getToken,gettedDeviceId,getCityId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_YOURWEEHIVE]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
     
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 weehiveData=[[WHYourWeehiveModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewWeehives.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewWeehives.hidden=NO;
                     self.tableViewWeehives.backgroundView = messageLabel;
                     self.tableViewWeehives.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     
                     for (WHYourWeehiveDetailsModel *each in weehiveData.group) {
                         
                         
                         [weehiveArray addObject:[NSString stringWithFormat:@"%@",each.group_name]];
                         
                     }
                     
                     weehiveFinalArray = [weehiveArray mutableCopy];
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

//service calling for sending group enter request
- (void) serviceCallingForSendingRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"request_by=%@&token=%@&group_id=%@&device_id=%@&created_by=%@&first_name=%@&last_name=%@&image=%@",getUserId,getToken,getGroupId,gettedDeviceId,getCreatedById,gettedFirstName,gettedLastName,gettedImageString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_SENDGROUPREQUEST]
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
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                     [self serviceCallingForWeehive];
                     
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


//service calling for Own Weehives i.e Groups
- (void) serviceCallingForOwnWeehive{
    
    [weehiveArray removeAllObjects];
    weehiveFinalArray = nil;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&city_id=%@&neg_id=%@",getUserId,getToken,gettedDeviceId,getCityId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FILTEREDWEEHIVE]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
              
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 weehiveData=[[WHYourWeehiveModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewWeehives.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewWeehives.hidden=NO;
                     self.tableViewWeehives.backgroundView = messageLabel;
                     self.tableViewWeehives.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     
                     for (WHYourWeehiveDetailsModel *each in weehiveData.group) {
                         
                         [weehiveArray addObject:[NSString stringWithFormat:@"%@",each.group_name]];
                     }
                     
                     weehiveFinalArray = [weehiveArray mutableCopy];
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


//service calling for exiting group
- (void) serviceCallingForExitingGroup{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&group_id=%@&device_id=%@",getUserId,getToken,getExitedGroupId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_EXITGROUP]
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
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No record found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                     [self serviceCallingForWeehive];
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


#pragma mark  UISearchBar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    weehiveFinalArray = nil;
    
    if (searchText.length != 0) {
        NSPredicate *predicate =[NSPredicate
                                 predicateWithFormat:@"SELF contains[c] %@",
                                 searchText];
        weehiveFinalArray = [weehiveArray filteredArrayUsingPredicate:predicate];
      
    }
    else {
        
        weehiveFinalArray = weehiveArray;
    }
    
    [self.tableViewWeehives reloadData];
}

#pragma mark  CellButton Action

-(void)addButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
    weehiveInfoModel=weehiveData.group[senderButton.tag];
    getGroupId=weehiveInfoModel.group_id;
    getCreatedById=weehiveInfoModel.created_by;
    [self serviceCallingForSendingRequest];
}



#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return weehiveData.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHYourWeehiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHYOURWEEHIVE_CELL];
    weehiveInfoModel=weehiveData.group[indexPath.row];
    cell.labelName.text=[NSString stringWithFormat:@"%@",weehiveInfoModel.group_name];
    cell.imageViewProfile.layer.cornerRadius=cell.imageViewProfile.frame.size.height/2;
    cell.imageViewProfile.layer.masksToBounds=YES;
    cell.imageViewProfile.layer.borderWidth=0;
    cell.labelCountNeighbors.textColor = [UIColor lightGrayColor];
    //cell.labelCountNeighbors.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
    cell.labelDesc.text=[NSString stringWithFormat:@"%@",weehiveInfoModel.description];
    
    cell.buttonRequest.tag=indexPath.row;
    [cell.buttonRequest addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([weehiveInfoModel.created_by isEqualToString:@"admin"] || [weehiveInfoModel.created_by isEqualToString:@"Admin"]) {
        cell.labelName.text=@"WeeeHive Team";
        cell.imageViewProfile.image=[UIImage imageNamed:@"logo"];
        cell.buttonRequest.hidden=YES;
        
    
    }
    else{
          cell.buttonRequest.hidden=NO;
        
    }
    
    
    if ([weehiveInfoModel.status isEqualToString:@"admin"]) {
        cell.buttonRequest.hidden=YES;
        cell.labelStatus.hidden=NO;
        cell.labelStatus.text=@"weehive admin";
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,weehiveInfoModel.picture];
        [cell.imageViewProfile sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        
    }
    else if ([weehiveInfoModel.status isEqualToString:@"member"]){
        cell.buttonRequest.hidden=YES;
        cell.labelStatus.hidden=NO;
        cell.labelStatus.text=@"member";
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,weehiveInfoModel.picture];
        [cell.imageViewProfile sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    }
    else if ([weehiveInfoModel.status isEqualToString:@"request"]){
        cell.buttonRequest.hidden=YES;
        cell.labelStatus.hidden=NO;
        cell.labelStatus.text=@"Request sent";
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,weehiveInfoModel.picture];
        [cell.imageViewProfile sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    }
    else{
        cell.buttonRequest.hidden=NO;
        cell.labelStatus.hidden=YES;
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,weehiveInfoModel.picture];
        [cell.imageViewProfile sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
    }
    if ([weehiveInfoModel.cmnconn isEqualToString:@"0"]) {
        cell.labelCountNeighbors.text=@"No common connection";
    }
    else{
        cell.labelCountNeighbors.text=[NSString stringWithFormat:@"%@ common connections",weehiveInfoModel.cmnconn];
    }
    
    
   
    
    return cell;
}



#pragma mark  UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    weehiveInfoModel=weehiveData.group[indexPath.row];
    
    if ([weehiveInfoModel.status isEqualToString:@"admin"] || [weehiveInfoModel.status isEqualToString:@"Admin"]) {
         [self performSegueWithIdentifier:@"weehiveDetailsSegueVC" sender:nil];
    }
    else if ([weehiveInfoModel.status isEqualToString:@"member"]){
         [self performSegueWithIdentifier:@"weehiveDetailsSegueVC" sender:nil];
    }
    else if ([weehiveInfoModel.status isEqualToString:@"request"]){
        
        isRequestSent=1;
        [self performSegueWithIdentifier:@"groupListToMembersSegueVC" sender:nil];
    }
    else{
        isRequestSent=2;
        [self performSegueWithIdentifier:@"groupListToMembersSegueVC" sender:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    weehiveInfoModel=weehiveData.group[indexPath.row];
    
    if ([weehiveInfoModel.status isEqualToString:@"admin"] || [weehiveInfoModel.status isEqualToString:@"member"]) {
        
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        // [fields removeObjectAtIndex:indexPath.row];
        weehiveInfoModel=weehiveData.group[indexPath.row];
        getExitedGroupId=weehiveInfoModel.group_id;
        [weehiveData.group removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self serviceCallingForExitingGroup];
    }
    }
    else{
        
    }
}

#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"weehiveDetailsSegueVC"]) {
        WHWeehiveDetailsViewController *secondVC = segue.destinationViewController;
        secondVC.getGroupName=weehiveInfoModel.group_name;
        secondVC.getGroupId=weehiveInfoModel.group_id;
        secondVC.getImagePath=weehiveInfoModel.picture;
        secondVC.getCreatedBy=weehiveInfoModel.created_by;
        secondVC.createdDate=weehiveInfoModel.created_date;
        secondVC.getFirstName=weehiveInfoModel.first_name;
        secondVC.getLastName=weehiveInfoModel.last_name;
        secondVC.groupDesc=weehiveInfoModel.description;
       
    }
    else if ([segue.identifier isEqualToString:@"groupListToMembersSegueVC"]){
        WHWeehiveGroupMembersViewController *secondVC = segue.destinationViewController;
        secondVC.getGroupId=weehiveInfoModel.group_id;
        secondVC.getGroupName=weehiveInfoModel.group_name;
        secondVC.imagePath=weehiveInfoModel.picture;
      //  secondVC.createdBy=weehiveInfoModel.created_by;
        secondVC.createdDate=weehiveInfoModel.created_date;
        secondVC.indicatorJoinGroup=1;
        secondVC.getRequestSent=isRequestSent;
        secondVC.getStatus=weehiveInfoModel.status;
        secondVC.groupDesc=weehiveInfoModel.description;
        
        if ([weehiveInfoModel.created_by isEqualToString:@"admin"] || [weehiveInfoModel.created_by isEqualToString:@"Admin"]) {
            
            secondVC.getFirstName=@"WeeeHive Team";
        }
        else{
            
            secondVC.getFirstName=weehiveInfoModel.first_name;
            secondVC.getLastName=weehiveInfoModel.last_name;
        }
        
      
        
    }
    else{
        
    }
}

- (IBAction)buttonAddGroupPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addGroupSegueVC" sender:nil];
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
 
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
    
}
- (IBAction)barButtonFilterPressed:(id)sender {
    
    if (isClicked==0) {
        isClicked=1;
        self.searchBar.hidden=YES;
        self.tableViewWeehives.hidden=YES;
        self.viewFilter.hidden=NO;
        self.buttonOwnWeehives.hidden=NO;
        self.buttonAllWeehives.hidden=NO;
    }
    else{
        isClicked=0;
        self.searchBar.hidden=NO;
        self.tableViewWeehives.hidden=NO;
        self.viewFilter.hidden=YES;
        self.buttonOwnWeehives.hidden=YES;
        self.buttonAllWeehives.hidden=YES;
       
    }
}

- (IBAction)buttonOwnWeehivesPressed:(id)sender {
    self.viewFilter.hidden=YES;
    self.buttonAllWeehives.hidden=YES;
    self.buttonOwnWeehives.hidden=YES;
    self.tableViewWeehives.hidden=NO;
    self.searchBar.hidden=NO;
    isClicked=0;
    [self serviceCallingForOwnWeehive];
}

- (IBAction)buttonAllWeehivesPressed:(id)sender {
    self.viewFilter.hidden=YES;
    self.buttonAllWeehives.hidden=YES;
    self.buttonOwnWeehives.hidden=YES;
    self.tableViewWeehives.hidden=NO;
    self.searchBar.hidden=NO;
    isClicked=0;
    [self serviceCallingForWeehive];
}

@end
