//
//  WHNeighborKnowDetailsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 06/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHNeighborKnowDetailsViewController.h"

#import "WHNegKnowDetailsTableViewCell.h"

#import "Constant.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"

@interface WHNeighborKnowDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    WHMessageModel *messageStatus;
    WHTokenErrorModel *tokenStatus;
    WHSingletonClass *sharedObject;
    
    NSString *getStatus;
    NSString *userId;
    NSString *token;
    NSString *getFriendUserId;
    NSString *sendStatus;
    BOOL isFlag;
    NSString *tempString;
    int value;
    NSInteger ageValue;
    NSString *ageBracket;
    NSString *getLivingFor;
    NSString *variable;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSString *gettedDeviceId;
    
    NSString *gettedFirstName;
    NSString *gettedLastName;
    NSString *gettedImageString;
    
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonSendRequest;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNeghKnowDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imageFullSize;
@property (nonatomic, assign) id<SecondDelegate>  myDelegate;
@end

@implementation WHNeighborKnowDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    [self getValuesFromLastScreen];
    variable=@"Not mentioned";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getValues];
    if ([self.status isEqualToString:@"0"]) {
        self.buttonSendRequest.userInteractionEnabled=NO;
        [self.buttonSendRequest setBackgroundColor:[UIColor clearColor]];
        [self.buttonSendRequest setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.buttonSendRequest setTitle:@"Request Sent" forState:UIControlStateNormal];
    }
    else if ([self.status isEqualToString:@"1"]){
        self.buttonSendRequest.userInteractionEnabled=NO;
        [self.buttonSendRequest setBackgroundColor:[UIColor clearColor]];
        [self.buttonSendRequest setTitleColor:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.buttonSendRequest setTitle:@"Friends" forState:UIControlStateNormal];
    }
    else{
        self.buttonSendRequest.userInteractionEnabled=YES;
        [self.buttonSendRequest setTitle:@"Send Request" forState:UIControlStateNormal];
    }
    
    //code for age
    tempString = self.age;
    value = [tempString intValue];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *startD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.age]];
    NSDate *endD = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
    NSInteger year  = [components year];
 
    ageValue= year;
   
    
    if (ageValue<10) {
        ageBracket=@"less than 10 years";
    }
    
    else if (ageValue>=10 && ageValue<=14) {
        ageBracket=@"10-14 years";
    }
    else if (ageValue>=15 &&  ageValue<=18){
        ageBracket=@"15-18 years";
        
    }
    else if (ageValue>=19 && ageValue<=24){
        ageBracket=@"19-24 years";
        
    }
    else if (ageValue>=25 && ageValue<=35){
        ageBracket=@"25-35 years";
        
    }
    else if (ageValue>=36 && ageValue<=50){
        ageBracket=@"36-50 years";
        
    }
    else if (ageValue>50){
        ageBracket=@"above 50 years";
        
    }
    else{
        ageBracket=@"Not mentioned";
        
    }
    
    if (self.livingSince.length==0) {
        getLivingFor=@"Not mentioned";
    }
    else{
        [self calculateLivingSinceYears];
    }
    
    [self animateTableView];
}

-(void)calculateLivingSinceYears{
    
    if (self.livingSince.length==0) {
        
    }
    else{
     
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSDate *startD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.livingSince]];
        NSDate *endD = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
    getLivingFor=[NSString stringWithFormat:@"%ld",(long)[components year]];
     

    }
    
    
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Detail";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    self.buttonSendRequest.layer.cornerRadius=2.0f;
    self.buttonSendRequest.layer.masksToBounds=YES;
    
}

- (void) getValuesFromLastScreen{
    
    userId=[[WHSingletonClass sharedManager]singletonUserId];
    token=[[WHSingletonClass sharedManager]singletonToken];
    
    gettedFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
}

- (void)animateTableView {
    
    [self.tableViewNeghKnowDetails reloadData];
    NSArray *cells = self.tableViewNeghKnowDetails.visibleCells;
    CGFloat height = self.tableViewNeghKnowDetails.bounds.size.height;
    
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
    getStatus=self.status;
    getFriendUserId=self.friendUserId;
    self.imageFullSize.layer.cornerRadius=self.imageFullSize.frame.size.height/2;
    self.imageFullSize.layer.masksToBounds=YES;
    self.imageFullSize.layer.borderWidth=0;
    self.imageFullSize.image=self.getImage;
}

#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHNegKnowDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:WHNEGKNOWDETAILS_CELL];
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.5f;
    cell.layer.cornerRadius=2.0f;
    cell.layer.masksToBounds=YES;
    
    if (indexPath.row == 0) {
        
        cell.labelMainFieldName.text=[NSString stringWithFormat:@"Name: %@ %@",self.firstName,self.lastName];
    }
    else if (indexPath.row==1){
        cell.labelMainFieldName.text=[NSString stringWithFormat:@"Age: %@",ageBracket];
    }
    else if (indexPath.row==2){
        if (getLivingFor.length==0) {
            cell.labelMainFieldName.text=[NSString stringWithFormat:@"Living for: %@",variable];
        }
        else{
            cell.labelMainFieldName.text=[NSString stringWithFormat:@"Living for: %@ years",getLivingFor];
        }
    }
    else if (indexPath.row==3){
        
        if (self.getOrigin.length==0 && self.getOriginCity.length==0) {
            cell.labelMainFieldName.text=[NSString stringWithFormat:@"Origin: %@",variable];
        }
        else{
            
            if (self.getOrigin.length!=0 && self.getOriginCity.length==0) {
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Origin: %@",self.getOrigin];
            }
            else if (self.getOrigin.length==0 && self.getOriginCity.length!=0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Origin: %@",self.getOriginCity];
            }
            else{
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Origin: %@ / %@",self.getOrigin,self.getOriginCity];
            }
            
        }
    }
    else if (indexPath.row==4){
        if (self.getWorkInterest.length!=0 && self.occupation.length!=0) {
            cell.labelMainFieldName.text=[NSString stringWithFormat:@"Occupation/Work Interest: %@ / %@",self.occupation,self.getWorkInterest];
        }
        else{
            if (self.getWorkInterest.length!=0 && self.occupation.length==0) {
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Work Interest: %@",self.getWorkInterest];
            }
            else if (self.getWorkInterest.length==0 && self.occupation.length!=0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Occupation: %@",self.occupation];
            }
            
        }
    }
    else if (indexPath.row==5){
        //code for interest.
        getInterest1=self.morningAct;
        getInterest2=self.weekendAct;
        getInterest3=self.eveningAct;
        
        if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length==0) {
            
            cell.labelMainFieldName.text=@"No Interests";
        }
        else{
            
            if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length!=0) {
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest2,getInterest3];
            }
            else if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length!=0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@",getInterest3];
            }
            else if (getInterest2.length==0 && getInterest1.length!=0 && getInterest3.length!=0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest1,getInterest3];
            }
            else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length!=0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@ / %@ / %@",getInterest1,getInterest2,getInterest3];
            }
            else if (getInterest1.length!=0 && getInterest2.length==0 && getInterest3.length==0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@",getInterest1];
            }
            else if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length==0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@",getInterest2];
            }
            else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length==0){
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest1,getInterest2];
            }
            else{
                
            }
        }
    }
    else if (indexPath.row==6){
        if (self.getSpeciality.length!=0 && self.help.length!=0) {
            cell.labelMainFieldName.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@ / %@",self.help,self.getSpeciality];
        }
        else {
            
            if (self.getSpeciality.length==0 && self.help.length!=0) {
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@",self.help];
            }
            else {
                cell.labelMainFieldName.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@",variable];
            }
            
        }
        
    }
    return cell;
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    
    if ([self.getIndicator isEqualToString:@"1"]) {
        [self.delegate sendDataToA:@"1"];
    }
    else{
        
    }
    
    
    [super viewWillDisappear:animated];
}

//


//service calling for sending friend request
- (void) serviceCallingForSendingFriendRequest{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"request_by=%@&token=%@&status=%@&request_to=%@&device_id=%@&first_name=%@&last_name=%@&image=%@",userId,token,sendStatus,getFriendUserId,gettedDeviceId,gettedFirstName,gettedLastName,gettedImageString];
        
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
                     
                     [self.buttonSendRequest setTitle:@"Send Request" forState:UIControlStateNormal];
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     
                     isFlag=1;
                     
                     [self.buttonSendRequest setTitle:@"Request Sent" forState:UIControlStateNormal];
                     [self.buttonSendRequest setBackgroundColor:[UIColor clearColor]];
                     [self.buttonSendRequest setTitleColor:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0] forState:UIControlStateNormal];
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
- (IBAction)buttonSendRequestPressed:(id)sender {
    
    if (isFlag==0) {
        sendStatus=@"0";
        [self serviceCallingForSendingFriendRequest];
    }
    else{
        
        
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
