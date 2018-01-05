//
//  WHPulsePollViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHPulsePollViewController.h"

#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "WHPollListTableViewCell.h"
#import "WHPollListModel.h"
#import "WHPollListDetailsModel.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "NSDate+DateTools.h"


@interface WHPulsePollViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    WHPollListModel *pollListData;
    WHPollListDetailsModel *pollListInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSIndexPath *getIndexPath;
    NSDate *originalDate;
    NSString *finalDate;
    NSString *pollId;
    NSString *answer;
    NSString *count;
    NSMutableArray *countArray;
    NSString *temp;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSString *getCityId;
    NSString *getNeighbourhoodId;
    int indicator;
    NSUserDefaults *defaults;
    
    NSString *getFirstName;
    NSString *getLastName;
    NSString *tableName;
    NSString *getName;
    NSString *gettedContentId;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewPollList;

@end

@implementation WHPulsePollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    getCityId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    getFirstName=[[WHSingletonClass sharedManager] singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager] singletonLastName];
    tableName=@"Table Name: poll";
    getName=[NSString stringWithFormat:@"%@ %@",getFirstName,getLastName];
    
    countArray=[NSMutableArray new];
    self.tableViewPollList.tableFooterView = [UIView new];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewPollList addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Poll";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [countArray removeAllObjects];
    [self serviceCallingForGettingPolls];
    
   
}

- (void)refresh {
    
    [self serviceCallingForGettingPolls];
    
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


- (void)animateTableView {
    
    [self.tableViewPollList reloadData];
    NSArray *cells = self.tableViewPollList.visibleCells;
    CGFloat height = self.tableViewPollList.bounds.size.height;
    
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

//service calling for getting Polls
- (void) serviceCallingForGettingPolls{
    
    [countArray removeAllObjects];
    indicator=1;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@&city_id=%@&neg_id=%@",getUserId,getToken,gettedDeviceId,getCityId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_POLLLIST]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
              
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 pollListData=[[WHPollListModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewPollList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewPollList.hidden=NO;
                     self.tableViewPollList.backgroundView = messageLabel;
                     self.tableViewPollList.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     
                     for (WHPollListDetailsModel *each in pollListData.polls){
                         
                         if ([each.answer isEqualToString:@"0"]) {
                             count=@"1";
                             [countArray addObject:count];
                         }
                         else if ([each.answer isEqualToString:@"1"]){
                             count=@"1";
                             [countArray addObject:count];
                         }
                         else{
                             count=@"2";
                             [countArray addObject:count];
                         }
                     }
                     
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

#pragma mark  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return pollListData.polls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    WHPollListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHPOLL_CELL];
        pollListInfoModel=pollListData.polls[indexPath.row];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        originalDate   =  [dateFormatter dateFromString:pollListInfoModel.date];
        cell.labelDate.text=[NSString stringWithFormat:@"%@",originalDate.timeAgoSinceNow];
        cell.labelQuestion.text=[NSString stringWithFormat:@"%@",pollListInfoModel.question];
        cell.labelLikeVote.text=[NSString stringWithFormat:@"%@",pollListInfoModel.likes];
        cell.labelDislike.text=[NSString stringWithFormat:@"%@",pollListInfoModel.unlikes];
        cell.labelLikeVote.textAlignment=NSTextAlignmentCenter;
        cell.labelDislike.textAlignment=NSTextAlignmentCenter;
        int x = ([pollListInfoModel.likes intValue]);
        int y = ([pollListInfoModel.unlikes intValue]);
        
        cell.labelQuestion.numberOfLines=0;
        cell.labelQuestion.lineBreakMode=NSLineBreakByWordWrapping;
        
        cell.buttonLike.enabled=YES;
        cell.buttonDisLike.enabled=YES;
        cell.buttonLike.alpha=1.0f;
        cell.buttonDisLike.alpha=1.0f;
        
        cell.labelTotalVotes.text=[NSString stringWithFormat:@"Total votes: %i",(x+y)];
        cell.buttonDisLike.tag=indexPath.row;
        [cell.buttonDisLike addTarget:self action:@selector(buttonDislikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.buttonReport.tag=indexPath.row;
    [cell.buttonReport addTarget:self action:@selector(buttonReportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
        cell.buttonLike.tag=indexPath.row;
        [cell.buttonLike addTarget:self action:@selector(buttonLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
        if ([pollListInfoModel.answer isEqualToString:@"0"]) {
            
          cell.buttonDisLike.enabled=NO;
            cell.buttonLike.enabled=YES;
            cell.buttonDisLike.alpha=0.5f;
            cell.buttonLike.alpha=1.0f;
           
        }
        else if ([pollListInfoModel.answer isEqualToString:@"1"]){
            
           
            cell.buttonLike.enabled=NO;
            cell.buttonDisLike.enabled=YES;
            cell.buttonLike.alpha=0.5f;
            cell.buttonDisLike.alpha=1.0f;
        }
        else{
            
            cell.buttonLike.enabled=YES;
            cell.buttonDisLike.enabled=YES;
          
        }
    
    return  cell;
}

- (void)buttonReportClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
    pollListInfoModel=pollListData.polls[senderButton.tag];
    gettedContentId=[NSString stringWithFormat:@"Poll Id: %@",pollListInfoModel.poll_id];
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to report this content as inappropriate?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil]show];

}

-(void)buttonDislikeClick:(id)sender{
    indicator=2;
    UIButton *senderButton=(UIButton *)sender;
    pollListInfoModel=pollListData.polls[senderButton.tag];
    pollId=pollListInfoModel.poll_id;

    answer=@"0";
    temp= [countArray objectAtIndex:senderButton.tag];

    if ([temp isEqualToString:@"2"]) {
        [self serviceCallingForSubmittingPollAction];
    }
    else{
        
        [self serviceCallingForSubmittingPollActionOfDislike];
        
    }
}

-(void)buttonLikeClick:(id)sender{
      indicator=2;
    UIButton *senderButton=(UIButton *)sender;
    pollListInfoModel=pollListData.polls[senderButton.tag];

    pollId=pollListInfoModel.poll_id;
    answer=@"1";
    temp=[countArray objectAtIndex:senderButton.tag];
    
    if ([temp isEqualToString:@"2"]) {
       [self serviceCallingForSubmittingPollAction];
    }
    else{
        [self serviceCallingForSubmittingPollActionOfDislike];
    }
}

//service calling for submitting poll action
- (void) serviceCallingForSubmittingPollAction{
    
      indicator=2;
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&poll_id=%@&answer=%@&device_id=%@",getUserId,getToken,pollId,answer,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_POLLACTION]
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
                     [countArray removeAllObjects];
                     [self serviceCallingForGettingPolls];
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

//service calling for submitting poll action
- (void) serviceCallingForSubmittingPollActionOfDislike{
    
      indicator=2;
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&poll_id=%@&answer=%@&device_id=%@",getUserId,getToken,pollId,answer,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_POLLACTION2]
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
                       [countArray removeAllObjects];
                     [self serviceCallingForGettingPolls];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    pollListInfoModel=pollListData.polls[indexPath.row];
    
    
        CGSize constraint = CGSizeMake(225, 20000);
        
        // Size for Name
        
        NSString *name = [NSString stringWithFormat:@"%@",pollListInfoModel.question];
        
        CGFloat heightName = 0.0;
        
        if (name.length > 0) {
            
            NSAttributedString *attributedTextName =  [[NSAttributedString alloc] initWithString:name];
            
            CGRect rectName= [attributedTextName boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            CGSize sizeName   = rectName.size;
            
            heightName = MAX(sizeName.height, 46.0f);
            
        }
        
    
    return 15 + heightName + 21  + 21 + 20;
    
}



- (IBAction)barButtonAddPollPressed:(id)sender {
    [self performSegueWithIdentifier:@"addPollSegueVC" sender:nil];
}

//service calling for reporting content as inappropriate
- (void) serviceCallingForReportingContent{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&u_name=%@&table_name=%@&content_id=%@",getUserId,getName,tableName,gettedContentId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_REPORT_CONTENT]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your response has been received! Thank you for the same!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                 }
                 else{
                     
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


#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        if ([tokenStatus.error isEqualToString:@"0"]) {
            
            NSString *string=@"0";
            [defaults setObject:string forKey:@"LOGGED"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            //service to be hit for sending this as report
            [self serviceCallingForReportingContent];
        }
    }
    
    
}

@end
