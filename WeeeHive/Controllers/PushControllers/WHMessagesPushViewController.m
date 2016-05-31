//
//  WHMessagesPushViewController.m
//  WeeeHive
//
//  Created by Schoofi on 02/02/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHMessagesPushViewController.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "WHSingletonClass.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHMessagesPushTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+DateTools.h"
#import "WHWeehiveDetailsViewController.h"
#import "WHYourNeighborhoodMsgsChattingViewController.h"

@interface WHMessagesPushViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    NSDate *originalDate;
    NSUserDefaults *defaults;
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableViewMessagesList;

@end

@implementation WHMessagesPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    self.tableViewMessagesList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewMessagesList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self serviceCallingForGettingMessagesList];
}

- (void)refresh {
    
    [self serviceCallingForGettingMessagesList];
    
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
    titleView.text =@"Messages";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
}

- (void)animateTableView {
    
    [self.tableViewMessagesList reloadData];
    NSArray *cells = self.tableViewMessagesList.visibleCells;
    CGFloat height = self.tableViewMessagesList.bounds.size.height;
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

//service calling for Messages List.
- (void) serviceCallingForGettingMessagesList{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",getUserId,getToken,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_MESSAGESLIST]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewMessagesList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No previous conversations. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewMessagesList.hidden=NO;
                     self.tableViewMessagesList.backgroundView = messageLabel;
                     self.tableViewMessagesList.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    WHMessagesPushTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:WHMESSAGES_CELL];
    profileInfoModel=profileData.profile[indexPath.row];
    if ([profileInfoModel.group_id isEqualToString:@""]) {
        //code for friend messages
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        cell.labelLastMessage.text=[NSString stringWithFormat:@"%@",profileInfoModel.message];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:profileInfoModel.date_time];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.shortTimeAgoSinceNow];
        
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return  cell;
    }
    else{
       //code for group messages
        cell.labelName.text=[NSString stringWithFormat:@"%@",profileInfoModel.group_name];
        cell.labelLastMessage.text=[NSString stringWithFormat:@"%@",profileInfoModel.message];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:profileInfoModel.date_time];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.shortTimeAgoSinceNow];
        
        cell.imageViewProfilePic.layer.cornerRadius=cell.imageViewProfilePic.frame.size.height/2;
        cell.imageViewProfilePic.layer.masksToBounds=YES;
        
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return  cell;
    }
    
}

#pragma mark  UITableView Delegtes

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    profileInfoModel=profileData.profile[indexPath.row];
    
    if ([profileInfoModel.group_id isEqualToString:@""] || profileInfoModel.group_id.length==0) {
         [self performSegueWithIdentifier:@"messageToChatScreenSegueVC" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"groupChatsPushSegueVC" sender:nil];
    }
}

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"messageToChatScreenSegueVC"]) {
        WHYourNeighborhoodMsgsChattingViewController *secondVC = segue.destinationViewController;
        secondVC.firstName=profileInfoModel.first_name;
        secondVC.lastName=profileInfoModel.last_name;
        secondVC.weehiveName=profileInfoModel.weehives_name;
        secondVC.age=profileInfoModel.dob;
        secondVC.occupation=profileInfoModel.occupation;
        secondVC.morningAct=profileInfoModel.interest1;
        secondVC.eveningAct=profileInfoModel.interest3;
        secondVC.weekendAct=profileInfoModel.interest2;
        secondVC.help=profileInfoModel.help_in_as;
        secondVC.getImage=profileInfoModel.image;
        secondVC.getCollege=profileInfoModel.college;
        secondVC.getSchool=profileInfoModel.school;
        secondVC.getOrigin=profileInfoModel.origin;
        secondVC.getOriginCity=profileInfoModel.origin_city;
        secondVC.gettingUserId=profileInfoModel.user_id;
        secondVC.getWorkInterest=profileInfoModel.work_interest;
        secondVC.getSpeciality=profileInfoModel.speciality;
    }
    else if ([segue.identifier isEqualToString:@"groupChatsPushSegueVC"]){
        WHWeehiveDetailsViewController *secondVC = segue.destinationViewController;
        secondVC.getGroupName=profileInfoModel.group_name;
        secondVC.getGroupId=profileInfoModel.group_id;
        secondVC.getImagePath=profileInfoModel.image;
        secondVC.getCreatedBy=profileInfoModel.created_by;
        secondVC.createdDate=profileInfoModel.created_date;
        secondVC.getFirstName=profileInfoModel.first_name;
        secondVC.getLastName=profileInfoModel.last_name;
        
    }
    else{
        
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
