//
//  WHYourNeighborhoodViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHYourNeighborhoodViewController.h"

#import "WHYourNeighborsTableViewCell.h"

#import "Constant.h"
#import "SVProgressHUD.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"

#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"

#import "WHNeghbourFriendsViewController.h"

#import "WHYourNeghborDetailsViewController.h"
#import "WHYourNeighborhoodMsgsChattingViewController.h"

#import "UIImageView+WebCache.h"

@interface WHYourNeighborhoodViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    //json objects
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHProfileModel *neghProfileData;
    WHProfileDetailsModel *neghProfileInfoModel;
    WHSingletonClass *sharedObject;
    
    NSString *gettedUserId;
    NSString *gettedToken;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSIndexPath *getIndexPath;
    NSMutableArray *neghArray;
    NSArray *negFinalArray;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewYourNegList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *buttonTop;

@end

@implementation WHYourNeighborhoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    neghArray=[NSMutableArray new];
    negFinalArray=[NSArray new];
    self.tableViewYourNegList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewYourNegList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    titleView.text =@"Your Circle";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void)animateTableView {
    
    [self.tableViewYourNegList reloadData];
    NSArray *cells = self.tableViewYourNegList.visibleCells;
    CGFloat height = self.tableViewYourNegList.bounds.size.height;
    
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
    
    gettedUserId=[[WHSingletonClass sharedManager] singletonUserId];
    gettedToken=[[WHSingletonClass sharedManager]singletonToken];
    
}

//service calling for getting list of neghbours
- (void) serviceCallingForGettingListOfNeighbours{
    
    [neghArray removeAllObjects];
    negFinalArray = nil;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",gettedUserId,gettedToken,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_YOURNEGHBOR]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewYourNegList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewYourNegList.hidden=NO;
                     self.tableViewYourNegList.backgroundView = messageLabel;
                     self.tableViewYourNegList.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     
                     for (WHProfileDetailsModel *each in neghProfileData.profile) {
                         
                         
                         [neghArray addObject:[NSString stringWithFormat:@"%@ %@",each.first_name,each.last_name]];
                         
                     }
                     
                     negFinalArray = [neghArray mutableCopy];
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
    
    negFinalArray = nil;
    
    if (searchText.length != 0) {
        NSPredicate *predicate =[NSPredicate
                                 predicateWithFormat:@"SELF contains[c] %@",
                                 searchText];
        negFinalArray = [neghArray filteredArrayUsingPredicate:predicate];
  
        
    }
    else {
        
        negFinalArray = neghArray;
    }
    
    [self.tableViewYourNegList reloadData];
}



#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return negFinalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHYourNeighborsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:WHYOURNEG_CELL];
    neghProfileInfoModel=neghProfileData.profile[indexPath.row];
    
    cell.labelName.text=negFinalArray[indexPath.row];
    getInterest1=neghProfileInfoModel.interest1;
    getInterest2=neghProfileInfoModel.interest2;
    getInterest3=neghProfileInfoModel.interest3;
    
    if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length==0) {
        
        cell.labelAge.text=@"No Interests";
    }
    else{
        
        if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length!=0) {
            cell.labelAge.text=[NSString stringWithFormat:@" %@ / %@",getInterest2,getInterest3];
        }
        else if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length!=0){
            cell.labelAge.text=[NSString stringWithFormat:@"%@",getInterest3];
        }
        else if (getInterest2.length==0 && getInterest1.length!=0 && getInterest3.length!=0){
           cell.labelAge.text=[NSString stringWithFormat:@" %@ / %@",getInterest1,getInterest3];
        }
        else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length!=0){
            cell.labelAge.text=[NSString stringWithFormat:@" %@ / %@ / %@",getInterest1,getInterest2,getInterest3];
        }
        else if (getInterest1.length!=0 && getInterest2.length==0 && getInterest3.length==0){
            cell.labelAge.text=[NSString stringWithFormat:@"%@",getInterest1];
        }
        else if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length==0){
            cell.labelAge.text=[NSString stringWithFormat:@"%@",getInterest2];
        }
        else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length==0){
            cell.labelAge.text=[NSString stringWithFormat:@" %@ / %@",getInterest1,getInterest2];
        }
        else{
            
        }
    }
    
    cell.labelConnections.textColor = [UIColor lightGrayColor];
    cell.labelConnections.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
   if (neghProfileInfoModel.connections.length==0) {
        cell.labelConnections.text=@"No Connections";
    }
    else{
        
        cell.labelConnections.text=[NSString stringWithFormat:@"%@ Connections",neghProfileInfoModel.connections];
    }
    
    cell.buttonMessage.tag=indexPath.row;
    [cell.buttonMessage addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (neghProfileInfoModel.occupation.length!=0) {
        cell.labelOccupation.text=[NSString stringWithFormat:@"%@",neghProfileInfoModel.occupation];
    }
    else{
        cell.labelOccupation.text=@"Not mentioned";
    }
    
    
    cell.imageViewNegPic.layer.cornerRadius=cell.imageViewNegPic.frame.size.height/2;
    cell.imageViewNegPic.layer.masksToBounds=YES;
    cell.imageViewNegPic.layer.borderWidth=0;
    
    //LAZY LOADING.
    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,neghProfileInfoModel.image];
    [cell.imageViewNegPic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
    return  cell;
    
}

#pragma mark  UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    getIndexPath=indexPath;
    neghProfileInfoModel=neghProfileData.profile[indexPath.row];
    [self performSegueWithIdentifier:@"neghFriendsListSegueVC" sender:nil];
}

#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"neghFriendsListSegueVC"]) {
        
        WHNeghbourFriendsViewController *secondVC = segue.destinationViewController;
        secondVC.firstName=neghProfileInfoModel.first_name;
        secondVC.lastName=neghProfileInfoModel.last_name;
        secondVC.occupation=neghProfileInfoModel.occupation;
        secondVC.morningAct=neghProfileInfoModel.interest2;
        secondVC.eveningAct=neghProfileInfoModel.interest3;
        secondVC.weekendAct=neghProfileInfoModel.interest1;
        secondVC.purpose=neghProfileInfoModel.current_purpose;
        secondVC.age=neghProfileInfoModel.dob;
        secondVC.livingSince=neghProfileInfoModel.living_since;
        secondVC.help=neghProfileInfoModel.help_in_as;
        secondVC.gettingUserId=neghProfileInfoModel.user_id;
        secondVC.getImage=neghProfileInfoModel.image;
        secondVC.getCollege=neghProfileInfoModel.college;
        secondVC.getSchool=neghProfileInfoModel.school;
        secondVC.getOrigin=neghProfileInfoModel.origin;
        secondVC.getOriginCity=neghProfileInfoModel.origin_city;
        secondVC.gettingUserId=neghProfileInfoModel.user_id;
        secondVC.getWorkInterest=neghProfileInfoModel.work_interest;
        secondVC.getSpeciality=neghProfileInfoModel.speciality;
        secondVC.weehiveName=neghProfileInfoModel.weehives_name;
        
    }
    else if ([segue.identifier isEqualToString:@"directMessageSegueVC"]){
        WHYourNeighborhoodMsgsChattingViewController *secondVC = segue.destinationViewController;
        secondVC.firstName=neghProfileInfoModel.first_name;
        secondVC.lastName=neghProfileInfoModel.last_name;
        secondVC.weehiveName=neghProfileInfoModel.weehives_name;
        secondVC.age=neghProfileInfoModel.dob;
        secondVC.occupation=neghProfileInfoModel.occupation;
        secondVC.morningAct=neghProfileInfoModel.interest1;
        secondVC.eveningAct=neghProfileInfoModel.interest3;
        secondVC.weekendAct=neghProfileInfoModel.interest2;
        secondVC.help=neghProfileInfoModel.help_in_as;
        secondVC.getImage=neghProfileInfoModel.image;
        secondVC.getCollege=neghProfileInfoModel.college;
        secondVC.getSchool=neghProfileInfoModel.school;
        secondVC.getOrigin=neghProfileInfoModel.origin;
        secondVC.getOriginCity=neghProfileInfoModel.origin_city;
        secondVC.gettingUserId=neghProfileInfoModel.user_id;
        secondVC.getWorkInterest=neghProfileInfoModel.work_interest;
        secondVC.getSpeciality=neghProfileInfoModel.speciality;
        
    }
}

//button click action
-(void)addButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
    neghProfileInfoModel=neghProfileData.profile[senderButton.tag];
    [self performSegueWithIdentifier:@"directMessageSegueVC" sender:nil];
   
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {

                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
  
}

- (IBAction)buttonTopPressed:(id)sender {
}

@end
