//
//  WHHelpInViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHHelpInViewController.h"
#import "Constant.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHSingletonClass.h"
#import "WHHelpInTableViewCell.h"
#import "WHHelpInDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "WHHelpFilterViewController.h"
#import "WHHelpInFilterTableViewCell.h"
#import "WHStatusModel.h"
#import "WHMessageModel.h"

@interface WHHelpInViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHStatusModel *statusData;
    WHSingletonClass *sharedObject;
    
    NSInteger finalCount;
    NSString *getUserId;
    NSString *getToken;
    NSIndexPath *getIndexPath;
    int temp;
    BOOL isCount;
    NSString *gettedDeviceId;
    
    NSUserDefaults *defaults;
    
    IBOutlet UITableView *tableViewFilter;
    
    IBOutlet UITableView *tableViewHelpInList;
    
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    
}

@property (strong, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonReset;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonFilter;
@property (weak, nonatomic) IBOutlet UITableView *tableViewHelpIn;
@property (strong, nonatomic) IBOutlet UITableView *tableViewFilterList;
@property (strong, nonatomic) IBOutlet UILabel *labelDisplayHeader;

@end

@implementation WHHelpInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
   self.tableViewHelpIn.tableFooterView = [UIView new];
    self.tableViewFilterList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewFilterList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tableViewFilterList.hidden=YES;
    self.buttonDone.hidden=YES;
    self.labelDisplayHeader.hidden=YES;
    self.labelDisplayHeader.text=@"Help in List";
    //self.tableViewHelpIn.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self serviceCallingForGettingListOfHelpIn];
    
}


- (void)refresh {
    
    
    [self serviceCallingForFilterHelpIn];
    
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
    titleView.text =@"Neighbourhood Help";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.tableViewFilterList.backgroundColor=[UIColor clearColor];
    self.tableViewFilterList.layer.cornerRadius=2.0f;
    self.tableViewFilterList.layer.masksToBounds=YES;
    self.tableViewFilterList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewFilterList.layer.borderWidth=0.5f;
}

- (void)animateHelpInTableView {
    
    [self.tableViewHelpIn reloadData];
    NSArray *cells = self.tableViewHelpIn.visibleCells;
    CGFloat height = self.tableViewHelpIn.bounds.size.height;
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

- (void)animateHelpInFilterListTableView {
    
    [self.tableViewFilterList reloadData];
    NSArray *cells = self.tableViewFilterList.visibleCells;
    CGFloat height = self.tableViewFilterList.bounds.size.height;
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

- (IBAction)barButtonResetPressed:(id)sender {
    
    self.tableViewFilterList.hidden=YES;
    self.tableViewHelpIn.hidden=NO;
    self.buttonDone.hidden=YES;
    self.labelDisplayHeader.hidden=YES;
    [self serviceCallingForGettingListOfHelpIn];
}
- (IBAction)barButtonFilterPressed:(id)sender {
    
    if (isCount==0) {
        isCount=1;
        self.labelDisplayHeader.hidden=NO;
        self.tableViewHelpIn.hidden=YES;
        self.tableViewFilterList.hidden=NO;
        self.buttonDone.hidden=NO;
        [self serviceCallingForFilterHelpIn];
    }
    else{
        isCount=0;
        self.labelDisplayHeader.hidden=YES;
        self.tableViewHelpIn.hidden=NO;
        self.tableViewFilterList.hidden=YES;
        self.buttonDone.hidden=YES;
        [self serviceCallingForGettingListOfHelpIn];
        
    }
    
}

-(void)addButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
    profileInfoModel=profileData.profile[senderButton.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",profileInfoModel.mobile]]];
}
- (IBAction)buttonDonePressed:(id)sender {
    
    self.labelDisplayHeader.hidden=YES;
    self.tableViewFilterList.hidden=YES;
    self.tableViewHelpIn.hidden=NO;
    self.buttonDone.hidden=YES;
    [self serviceCallingForFilter:[profileData toJSONString]];
}

//service calling for getting HelpIn.
- (void) serviceCallingForGettingListOfHelpIn{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",getUserId,getToken,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_HELPIN]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewFilterList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewFilterList.hidden=NO;
                     self.tableViewFilterList.backgroundView = messageLabel;
                     self.tableViewFilterList.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateHelpInTableView];
                     
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
    if (tableView==tableViewHelpInList) {
        
        return profileData.profile.count;
    }
    else{
        finalCount=profileData.profile.count;
        return profileData.profile.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==tableViewHelpInList) {
        
        WHHelpInTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:WHHELP_CELL];
        profileInfoModel=profileData.profile[indexPath.row];
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        CGFloat strFloat = (CGFloat)[profileInfoModel.rating floatValue];
        cell.labelRating.text=[NSString stringWithFormat:@"Rating: %.1f/5.0",strFloat];
        cell.imageViewPic.layer.cornerRadius=cell.imageViewPic.frame.size.height/2;
        cell.imageViewPic.layer.masksToBounds=YES;
        cell.imageViewPic.layer.borderWidth=0;
        cell.buttonCall.tag=indexPath.row;
        [cell.buttonCall addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.labelOccupation.text=[NSString stringWithFormat:@"Occupation: %@",profileInfoModel.occupation];
        cell.labelHelpInAs.text=[NSString stringWithFormat:@"%@",profileInfoModel.help_in_as];
        
        if (profileInfoModel.speciality.length==0) {
          
            cell.labelPhoneNumber.text=@"Specialisation not mentioned";
        }
        else{
            
            cell.labelPhoneNumber.text=[NSString stringWithFormat:@"Specialisation: %@",profileInfoModel.speciality];
        }
        
        //LAZY LOADING.
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,profileInfoModel.image];
        [cell.imageViewPic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return  cell;
    }
    else{
        WHHelpInFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHHELPFILTER_CELL];
        profileInfoModel=profileData.profile[indexPath.row];
        profileInfoModel.count=(int) finalCount;
        cell.labelHelpInAs.text=[NSString stringWithFormat:@"%@",profileInfoModel.help_in_as];
        
        if ([profileInfoModel.isAdded isEqualToString:@"0"]) {
            temp=1;
            cell.imageViewCheckmark.image=[UIImage imageNamed:@"empty"];
            
        }
        else if ([profileInfoModel.isAdded isEqualToString:@"1"]){
            temp=2;
            cell.imageViewCheckmark.image=[UIImage imageNamed:@"tick"];
        }
        
        
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    getIndexPath=indexPath;
    if (tableView==tableViewHelpInList) {
        
        profileInfoModel=profileData.profile[indexPath.row];
        [self performSegueWithIdentifier:@"helpInDetailsSegueVC" sender:nil];
    }
    else{
        
        WHHelpInFilterTableViewCell *cell= (WHHelpInFilterTableViewCell *)[tableView cellForRowAtIndexPath:getIndexPath];
        
        profileInfoModel=profileData.profile[indexPath.row];
        
        if([profileInfoModel.isAdded isEqualToString:@"1"]) {
            
            temp=2;
            cell.imageViewCheckmark.image=[UIImage imageNamed:@"empty"];
            profileInfoModel.isAdded = @"0";
        }
        else
            
        {
            temp=1;
            cell.imageViewCheckmark.image=[UIImage imageNamed:@"tick"];
            profileInfoModel.isAdded = @"1";
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
}
#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    WHHelpInTableViewCell *cell = (WHHelpInTableViewCell *)[self.tableViewHelpIn cellForRowAtIndexPath:getIndexPath];
    WHHelpInDetailsViewController *secondVC = segue.destinationViewController;
    secondVC.getImage = cell.imageViewPic.image;
    secondVC.firstName=profileInfoModel.first_name;
    secondVC.lastName=profileInfoModel.last_name;
    secondVC.occupation=profileInfoModel.occupation;
    secondVC.morningAct=profileInfoModel.interest2;
    secondVC.eveningAct=profileInfoModel.interest3;
    secondVC.weekendAct=profileInfoModel.interest1;
    secondVC.purpose=profileInfoModel.current_purpose;
    secondVC.age=profileInfoModel.dob;
    secondVC.livingSince=profileInfoModel.living_since;
    secondVC.help=profileInfoModel.help_in_as;
    secondVC.maritalStatus=profileInfoModel.marital_status;
    secondVC.mobile=profileInfoModel.mobile;
    secondVC.getUserId=profileInfoModel.user_id;
    secondVC.getRating=profileInfoModel.rating;
    secondVC.getCollege=profileInfoModel.college;
    secondVC.getSchool=profileInfoModel.school;
    secondVC.getOrigin=profileInfoModel.origin;
    secondVC.getOriginCity=profileInfoModel.origin_city;
    secondVC.getWorkInterest=profileInfoModel.work_interest;
    secondVC.getSpeciality=profileInfoModel.speciality;
    secondVC.getWeehiveName=profileInfoModel.weehives_name;
}

//service calling for getting HelpInAs List.
- (void) serviceCallingForFilterHelpIn{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",getUserId,getToken,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FILTERHELP_IN_AS]
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
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else{
                     
                     
                     
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateHelpInFilterListTableView];
                     
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




//service calling for sending selected help in list server.
- (void) serviceCallingForFilter : (NSString *) Filter {
    
    self.tableViewFilterList.hidden=YES;
    self.tableViewHelpIn.hidden=NO;
    self.labelDisplayHeader.hidden=YES;
    
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FILTEREDHELP_IN]
                                           bodyString:Filter
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
              
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]){
                     
                     [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No record found!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                     
                 }
                 else if ([tokenStatus.error isEqualToString:@"0"]){
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                 }
                 
                 // Hide Progress bar.
                 [SVProgressHUD dismiss];
                 [self animateHelpInTableView];
                 
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



@end
