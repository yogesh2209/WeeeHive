//
//  WHWeehiveGroupMembersViewController.m
//  WeeeHive
//
//  Created by Schoofi on 25/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHWeehiveGroupMembersViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHWeehiveGroupMembersTableViewCell.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "UIImageView+WebCache.h"
#import "WHMemberProfileViewController.h"
#import "WHFriendListToAddGroupViewController.h"

@interface WHWeehiveGroupMembersViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHSingletonClass *sharedObject;
    
    NSUserDefaults *defaults;
    NSString *getUserId;
    NSString *getToken;
    NSString *gettedGroupId;
    NSIndexPath *getIndexPath;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSDate *originalDate;
    NSString *finalDate;
    NSString *getCreatedById;
    NSString *gettedFirstName;
    NSString *gettedLastName;
    NSString *gettedImageString;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonAddFriends;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGroupPic;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGroupMembers;
@property (strong, nonatomic) IBOutlet UILabel *labelCreatedBy;
@property (strong, nonatomic) IBOutlet UILabel *labelCreatedOn;
@property (strong, nonatomic) IBOutlet UIButton *buttonRequestJoin;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewGroupPicSecondWay;
@property (strong, nonatomic) IBOutlet UITextView *textViewGroupDesc;

@end

@implementation WHWeehiveGroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    
    gettedFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
    
    //self.tableViewGroupMembers.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewGroupMembers addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getValues];
    self.imageViewGroupPicSecondWay.hidden=YES;
    self.imageViewGroupPic.hidden=NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    originalDate   =  [dateFormatter dateFromString:self.createdDate];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    finalDate = [dateFormatter stringFromDate:originalDate];
    self.labelCreatedOn.text=[NSString stringWithFormat:@"Created on %@",finalDate];
    [self serviceCallingForGettingMembers];
    self.textViewGroupDesc.text=self.groupDesc;
    [self.textViewGroupDesc setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    self.textViewGroupDesc.textColor = [UIColor blackColor];
    self.textViewGroupDesc.textAlignment=NSTextAlignmentCenter;
    
    if ([self.createdBy isEqualToString:[NSString stringWithFormat:@"%@",[[WHSingletonClass sharedManager] singletonUserId]]]) {
        
        self.navigationItem.rightBarButtonItem=self.barButtonAddFriends;
        self.barButtonAddFriends.enabled=YES;
        [self.barButtonAddFriends setTintColor:[UIColor blackColor]];
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.indicatorJoinGroup==1) {
        self.buttonRequestJoin.hidden=NO;
        self.imageViewGroupPic.hidden=YES;
        self.imageViewGroupPicSecondWay.hidden=NO;
        if (self.getRequestSent==1) {
            self.buttonRequestJoin.userInteractionEnabled=false;
            [self.buttonRequestJoin setTitle:@"Request sent" forState:UIControlStateNormal];
            self.buttonRequestJoin.backgroundColor=[UIColor clearColor];
            [self.buttonRequestJoin setTitleColor:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else{
            self.buttonRequestJoin.userInteractionEnabled=true;
            [self.buttonRequestJoin setTitle:@"Join" forState:UIControlStateNormal];
            [self.buttonRequestJoin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    else{
        
        self.buttonRequestJoin.hidden=YES;
        self.imageViewGroupPic.hidden=NO;
        self.imageViewGroupPicSecondWay.hidden=YES;
    }
    
}
- (void)refresh {
    
    [self serviceCallingForGettingMembers];
    
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
    titleView.text =@"Weehive Members";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.buttonRequestJoin.layer.cornerRadius=2.0f;
    self.buttonRequestJoin.layer.masksToBounds=YES;
}
-(void) getValues{
    
    gettedGroupId=self.getGroupId;
    getCreatedById=self.createdBy;
    self.imageViewGroupPic.layer.cornerRadius=self.imageViewGroupPic.frame.size.height/2;
    self.imageViewGroupPic.layer.masksToBounds=YES;
    self.imageViewGroupPic.layer.borderWidth=0;
    
    self.imageViewGroupPicSecondWay.layer.cornerRadius=self.imageViewGroupPicSecondWay.frame.size.height/2;
    self.imageViewGroupPicSecondWay.layer.masksToBounds=YES;
    self.imageViewGroupPicSecondWay.layer.borderWidth=0;
    
    
    //LAZY LOADING.
    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,self.imagePath];
    [self.imageViewGroupPic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
    
    //LAZY LOADING FOR SECONDD WAY IMAGE
    [self.imageViewGroupPicSecondWay sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
}

- (void)animateTableView {
    
    [self.tableViewGroupMembers reloadData];
    NSArray *cells = self.tableViewGroupMembers.visibleCells;
    CGFloat height = self.tableViewGroupMembers.bounds.size.height;
    
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

//service calling for sending group enter request
- (void) serviceCallingForSendingRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"request_by=%@&token=%@&group_id=%@&device_id=%@&created_by=%@&first_name=%@&last_name=%@&image=%@",getUserId,getToken,gettedGroupId,gettedDeviceId,getCreatedById,gettedFirstName,gettedLastName,gettedImageString];
        
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
                     
                     [self.buttonRequestJoin setTitle:@"Request sent" forState:UIControlStateNormal];
                     self.buttonRequestJoin.userInteractionEnabled=false;
                     self.buttonRequestJoin.backgroundColor=[UIColor clearColor];
                     [self.buttonRequestJoin setTitleColor:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                     
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



//service calling for getting Members
- (void) serviceCallingForGettingMembers{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&group_id=%@&device_id=%@",getUserId,getToken,gettedGroupId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_GROUPMEMBERS]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewGroupMembers.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewGroupMembers.hidden=NO;
                     self.tableViewGroupMembers.backgroundView = messageLabel;
                     self.tableViewGroupMembers.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    return profileData.profile.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHWeehiveGroupMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHWEEHIVEGROUPMEMBERS_CELL];
    profileInfoModel=profileData.profile[indexPath.row];
    
    
    if (indexPath.row==0) {
        cell.hidden=YES;
        if ([profileInfoModel.created_by isEqualToString:@"admin"] || [profileInfoModel.created_by isEqualToString:@"Admin"]) {
            NSString *tempString=@"WeeeHive";
            self.labelCreatedBy.text=[NSString stringWithFormat:@"Created by %@",tempString];
        }
        else{
            self.labelCreatedBy.text=[NSString stringWithFormat:@"Created by %@ %@",profileInfoModel.admin_first_name,profileInfoModel.admin_last_name];
            
        }
        
    }
    else{
        
        cell.hidden=NO;
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name, profileInfoModel.last_name];
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        cell.imageViewProfilePic.layer.borderWidth=0;
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    }
    
    return cell;
}

#pragma mark  UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    profileInfoModel=profileData.profile[indexPath.row];
    getIndexPath=indexPath;
    [self performSegueWithIdentifier:@"memberDetailsSegueVC" sender:nil];
}

#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"memberDetailsSegueVC"]) {
        WHWeehiveGroupMembersTableViewCell *cell = (WHWeehiveGroupMembersTableViewCell *)[self.tableViewGroupMembers cellForRowAtIndexPath:getIndexPath];
        WHMemberProfileViewController *secondVC = segue.destinationViewController;
        secondVC.getImage = cell.imageViewProfilePic.image;
        secondVC.firstName=profileInfoModel.first_name;
        secondVC.lastName=profileInfoModel.last_name;
        secondVC.occupation=profileInfoModel.occupation;
        secondVC.morningAct=profileInfoModel.interest2;
        secondVC.eveningAct=profileInfoModel.interest3;
        secondVC.weekendAct=profileInfoModel.interest1;
        secondVC.age=profileInfoModel.dob;
        secondVC.livingSince=profileInfoModel.living_since;
        secondVC.getCollege=profileInfoModel.college;
        secondVC.getSchool=profileInfoModel.school;
        secondVC.getOrigin=profileInfoModel.origin;
        secondVC.getOriginCity=profileInfoModel.origin_city;
        secondVC.getWorkInterest=profileInfoModel.work_interest;
        secondVC.getSpeciality=profileInfoModel.speciality;
        secondVC.weehiveName=profileInfoModel.weehives_name;
        secondVC.help=profileInfoModel.help_in_as;
        
    }
    else if ([segue.identifier isEqualToString:@"addFriendListSegueVC"]){
        
        WHFriendListToAddGroupViewController *secondVC = segue.destinationViewController;
        secondVC.getGroupId=gettedGroupId;
    }
}

- (IBAction)buttonAddFriendsPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"addFriendListSegueVC" sender:nil];
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}
- (IBAction)buttonRequestJoinGroupPressed:(id)sender {
    [self serviceCallingForSendingRequest];
}

@end
