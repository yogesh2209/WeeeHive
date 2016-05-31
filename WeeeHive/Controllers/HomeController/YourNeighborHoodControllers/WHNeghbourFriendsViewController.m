//
//  WHNeghbourFriendsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 07/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHNeghbourFriendsViewController.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHSingletonClass.h"
#import "JSONHTTPClient.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"

#import "UIImageView+WebCache.h"
#import "WHNeghborFriendsProfileViewController.h"
#import "WHNeghborFriendsTableViewCell.h"
#import "WHYourNeighborhoodMsgsChattingViewController.h"
#import "WHYourNeghborDetailsViewController.h"


@interface WHNeghbourFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    WHMessageModel *messageStatus;
    WHTokenErrorModel *tokenStatus;
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHSingletonClass *sharedObject;
    
    NSString *gettedUserId;
    NSString *gettedToken;
    NSString *getFriendsUserId;
    NSString *getFriendsName;
    NSIndexPath *getIndexPath;
    NSString *neghFriendUserId;
    NSString *getStatus;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSString *getFirstName;
    NSString *getLastName;
    NSString *gettedImageString;
    
    NSUserDefaults *defaults;
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableViewNeghFriendsList;

@property (strong, nonatomic) IBOutlet UIButton *buttonTop;



@end

@implementation WHNeghbourFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    self.tableViewNeghFriendsList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewNeghFriendsList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customizeUI];
    getFriendsUserId=self.gettingUserId;
    [self serviceCallingForGettingListOfFriendsNeighbours];
}

- (void) getValues{
    
    gettedToken=[[WHSingletonClass sharedManager]singletonToken];
    gettedUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
}

- (void)refresh {
    
    [self serviceCallingForGettingListOfFriendsNeighbours];
    
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
//    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
//   // getFriendsName=[NSString stringWithFormat:@"%@",self.firstName];
//    titleView.text =[NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
//    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
//    titleView.textColor = [UIColor blackColor];
//    titleView.tintColor=[UIColor blackColor];
//    // Your color here
//    self.navigationItem.titleView = titleView;
//    [titleView sizeToFit];
//    
    [self.buttonTop setTitle:[NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName] forState:UIControlStateNormal];

    
    [self.buttonTop setTintColor:[UIColor blackColor]];
    self.buttonTop.backgroundColor=[UIColor clearColor];
}

- (void)animateTableView {
    
    [self.tableViewNeghFriendsList reloadData];
    NSArray *cells = self.tableViewNeghFriendsList.visibleCells;
    CGFloat height = self.tableViewNeghFriendsList.bounds.size.height;
    
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

- (IBAction)barButtonMessagePressed:(id)sender {
    
    [self performSegueWithIdentifier:@"neghChatSegueVC" sender:nil];
    
}

//service calling for getting list of neghbours
- (void) serviceCallingForGettingListOfFriendsNeighbours{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&friends_u_id=%@&device_id=%@",gettedUserId,gettedToken,getFriendsUserId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_NEGHFRIENDSLIST]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewNeghFriendsList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewNeghFriendsList.hidden=NO;
                     self.tableViewNeghFriendsList.backgroundView = messageLabel;
                     self.tableViewNeghFriendsList.separatorStyle = UITableViewCellSeparatorStyleNone;
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

//service calling for sending friend request
- (void) serviceCallingForSendingFriendRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"request_by=%@&token=%@&status=%@&request_to=%@&device_id=%@&first_name=%@&last_name=%@&image=%@",gettedUserId,gettedToken,getStatus,neghFriendUserId,gettedDeviceId,getFirstName,getLastName,gettedImageString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_USERREQUEST]
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
                     
                     [self serviceCallingForGettingListOfFriendsNeighbours];
                     
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

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
 
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
    
}

#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return profileData.profile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHNeghborFriendsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:WHNEGHFRIENDS_CELL];
    profileInfoModel=profileData.profile[indexPath.row];
    cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
    
    getInterest1=profileInfoModel.interest1;
    getInterest2=profileInfoModel.interest2;
    getInterest3=profileInfoModel.interest3;
    
    if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length==0) {
        
        cell.labelInterests.text=@"No Interests";
    }
    else{
        
        if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length!=0) {
            cell.labelInterests.text=[NSString stringWithFormat:@" %@ / %@",getInterest2,getInterest3];
        }
        else if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length!=0){
            cell.labelInterests.text=[NSString stringWithFormat:@"%@",getInterest3];
        }
        else if (getInterest2.length==0 && getInterest1.length!=0 && getInterest3.length!=0){
            cell.labelInterests.text=[NSString stringWithFormat:@" %@ / %@",getInterest1,getInterest3];
        }
        else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length!=0){
            cell.labelInterests.text=[NSString stringWithFormat:@" %@ / %@ / %@",getInterest1,getInterest2,getInterest3];
        }
        else if (getInterest1.length!=0 && getInterest2.length==0 && getInterest3.length==0){
            cell.labelInterests.text=[NSString stringWithFormat:@"%@",getInterest1];
        }
        else if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length==0){
            cell.labelInterests.text=[NSString stringWithFormat:@"%@",getInterest2];
        }
        else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length==0){
            cell.labelInterests.text=[NSString stringWithFormat:@" %@ / %@",getInterest1,getInterest2];
        }
        else{
            
        }
    }
    
    if (profileInfoModel.occupation.length!=0) {
        cell.labelOccupation.text=[NSString stringWithFormat:@"%@",profileInfoModel.occupation];
    }
    else{
        cell.labelOccupation.text=@"Not mentioned";
    }
    
    cell.labelConnections.textColor = [UIColor lightGrayColor];
    cell.labelConnections.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
    if (profileInfoModel.connections.length==0) {
        cell.labelConnections.text=@"No Connections";
    }
    else{
        
        cell.labelConnections.text=[NSString stringWithFormat:@"%@ Connections",profileInfoModel.connections];
    }
    
       if ([profileInfoModel.status isEqualToString:@"0"]) {
        cell.buttonAddFriend.hidden=YES;
        cell.labelStatus.hidden=NO;
        cell.buttonAddFriend.userInteractionEnabled=NO;
        cell.labelStatus.textColor = [UIColor orangeColor];
        cell.labelStatus.text=@"Request sent";

    }
    else if ([profileInfoModel.status isEqualToString:@"1"]){
        cell.buttonAddFriend.hidden=YES;
        cell.labelStatus.hidden=NO;
        cell.buttonAddFriend.userInteractionEnabled=NO;
        cell.labelStatus.textColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0];
        cell.labelStatus.text=@"Friends";
    }
    else{
        cell.buttonAddFriend.hidden=NO;
        cell.buttonAddFriend.userInteractionEnabled=YES;
        cell.labelStatus.hidden=YES;
    }
    
    cell.imageViewProfile.layer.cornerRadius=cell.imageViewProfile.frame.size.height/2;
    cell.imageViewProfile.layer.masksToBounds=YES;
    cell.imageViewProfile.layer.borderWidth=0;
    cell.buttonAddFriend.tag=indexPath.row;
    [cell.buttonAddFriend addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //LAZY LOADING.
    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
    [cell.imageViewProfile sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
    return  cell;
    
}

#pragma mark  UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    getIndexPath=indexPath;
    profileInfoModel=profileData.profile[indexPath.row];
    [self performSegueWithIdentifier:@"neghFriendsDetailsSegueVC" sender:nil];
}

#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"neghFriendsDetailsSegueVC"]) {
        WHNeghborFriendsTableViewCell *cell = (WHNeghborFriendsTableViewCell *)[self.tableViewNeghFriendsList cellForRowAtIndexPath:getIndexPath];
        WHNeghborFriendsProfileViewController *secondVC = segue.destinationViewController;
        secondVC.getImage = cell.imageViewProfile.image;
        secondVC.firstName=profileInfoModel.first_name;
        secondVC.lastName=profileInfoModel.last_name;
        secondVC.occupation=profileInfoModel.occupation;
        secondVC.morningAct=profileInfoModel.interest2;
        secondVC.eveningAct=profileInfoModel.interest3;
        secondVC.weekendAct=profileInfoModel.interest1;
        secondVC.purpose=profileInfoModel.current_purpose;
        secondVC.age=profileInfoModel.dob;
        secondVC.livingSince=profileInfoModel.living_since;
        secondVC.help=profileInfoModel.help_in;
        secondVC.maritalStatus=profileInfoModel.marital_status;
        secondVC.status=profileInfoModel.status;
        secondVC.friendUserId=profileInfoModel.user_id;
        secondVC.getCollege=profileInfoModel.college;
        secondVC.getSchool=profileInfoModel.school;
        secondVC.getOrigin=profileInfoModel.origin;
        secondVC.getOriginCity=profileInfoModel.origin_city;
        secondVC.getWorkInterest=profileInfoModel.work_interest;
        secondVC.getSpeciality=profileInfoModel.speciality;
        secondVC.getWeehiveName=profileInfoModel.weehives_name;
        secondVC.getUserStatus=profileInfoModel.status;
    }
    else if ([segue.identifier isEqualToString:@"neghChatSegueVC"]){
        WHYourNeighborhoodMsgsChattingViewController *secondVC = segue.destinationViewController;
        secondVC.firstName=self.firstName;
        secondVC.lastName=self.lastName;
        secondVC.age=self.age;
        secondVC.occupation=self.occupation;
        secondVC.purpose=self.purpose;
        secondVC.livingSince=self.livingSince;
        secondVC.morningAct=self.morningAct;
        secondVC.eveningAct=self.eveningAct;
        secondVC.weekendAct=self.weekendAct;
        secondVC.help=self.help;
        secondVC.getImage=self.getImage;
        secondVC.gettingUserId=self.gettingUserId;
        secondVC.weehiveName=self.weehiveName;
        secondVC.help=self.help;
        secondVC.getCollege=self.getCollege;
        secondVC.getSchool=self.getSchool;
        secondVC.getOrigin=self.getOrigin;
        secondVC.getOriginCity=self.getOriginCity;
        secondVC.getWorkInterest=self.getWorkInterest;
        secondVC.getSpeciality=self.getSpeciality;
        
    }
    else if ([segue.identifier isEqualToString:@"neghDetailsDirectSegueVC"]){
        WHYourNeghborDetailsViewController *secondVC = segue.destinationViewController;
        secondVC.firstName=self.firstName;
        secondVC.lastName=self.lastName;
        secondVC.occupation=self.occupation;
        secondVC.morningAct=self.morningAct;
        secondVC.eveningAct=self.eveningAct;
        secondVC.weekendAct=self.weekendAct;
        secondVC.purpose=self.purpose;
        secondVC.age=self.age;
        secondVC.livingSince=self.livingSince;
        secondVC.getImage=self.getImage;
        secondVC.getSchool=self.getSchool;
        secondVC.getCollege=self.getCollege;
        secondVC.getWeehiveName=self.weehiveName;
        secondVC.getOriginCity=self.getOriginCity;
        secondVC.getOrigin=self.getOrigin;
        secondVC.getWorkInterest=self.getWorkInterest;
        secondVC.getSpeciality=self.getSpeciality;
        secondVC.help=self.help;
        
    }
  
}

-(void)addButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
 profileInfoModel=profileData.profile[senderButton.tag];
    neghFriendUserId=profileInfoModel.user_id;
    getStatus=@"0";
    
    [self serviceCallingForSendingFriendRequest];
}

- (IBAction)buttonTopPressed:(id)sender {
    [self performSegueWithIdentifier:@"neghDetailsDirectSegueVC" sender:nil];
}


@end
