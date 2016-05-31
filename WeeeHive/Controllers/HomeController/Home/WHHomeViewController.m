//
//  WHHomeViewController.m
//  WeeeHive
//
//  Created by Schoofi on 16/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHHomeViewController.h"
#import "WHHomeCollectionViewCell.h"
#import "WHSingletonClass.h"
#import "WHLoginModel.h"
#import "WHLoginDetailsModel.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHStatusModel.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "WHUpdateProfileViewController.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "JSONHTTPClient.h"
#import "WHUpdateProfileViewController.h"
#import "WHLoginViewController.h"
#import "WHLoginCodeViewController.h"
#import "WHBadgeListDetailsModel.h"
#import "WHBadgeListModel.h"

#import "ENMBadgedBarButtonItem.h"


//Array for PARENTS & STUDENTS
#define imageArray @[@"1",@"2",@"3",@"4",@"6",@"7",@"8",@"9"]

#define segueNames @[@"neighborKnowSegueVC", @"yourNeighborSegueVC", @"yourWeehiveSegueVC", @"neighborHoodTimes",  @"couponsSegueVC", @"helpInSegueVC", @"pulsePollSegueVC", @"settingsSegueVC"]

@interface WHHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    WHSingletonClass *sharedObject;
    //JSON Objects
    WHLoginModel *loginData;
    WHLoginDetailsModel *loginInfoModel;
    WHMessageModel *messageStatus;
    WHTokenErrorModel *tokenStatus;
    WHStatusModel *userStatus;
    
    WHBadgeListModel *badgeListData;
    WHBadgeListDetailsModel *badgeListInfoModel;
    
    NSString *gettedUserStatus;
    NSString *fileName;
    UIImage *getSelectedImage;
    NSString *getImageString;
    NSString *getOccupation;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSString *gettedStatus;
    NSString *userId;
    NSString *token;
    NSString *deviceId;
    NSString *currentDateString;
    NSString *getRegistrationDate;
    NSString *status;
    NSString *gettedIsAddressEntered;
    int indicator;
    NSUserDefaults *defaults;
    int count;
    
    int badgeValue;
}


@property (nonatomic, strong) ENMBadgedBarButtonItem *navButton1;
@property (nonatomic, strong) ENMBadgedBarButtonItem *navButton2;
@property (nonatomic, strong) ENMBadgedBarButtonItem *navButton3;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonGroupRequest;



@property (weak, nonatomic) IBOutlet UIView *viewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelInterest;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewHome;
@property (strong, nonatomic) IBOutlet UILabel *labelOccupation;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonNotification;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonMsg;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonFriendRequest;


@end

@implementation WHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden=NO;
    getRegistrationDate=[[[WHSingletonClass sharedManager] singletonRegistrationDate] substringToIndex:10];
    sharedObject=[WHSingletonClass sharedManager];
    userId=[[WHSingletonClass sharedManager] singletonUserId];
    token=[[WHSingletonClass sharedManager] singletonToken];
    deviceId=[[WHSingletonClass sharedManager] deviceId];
    self.collectionViewHome.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home4"]];
    [self customiseUI];
    [self addTapGesture];
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image1 = [UIImage imageNamed:@"bell"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0,0,20, 20);
    [button1 addTarget:self
                action:@selector(buttonPress1:)
      forControlEvents:UIControlEventTouchDown];
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    self.navButton1 = [[ENMBadgedBarButtonItem alloc] initWithCustomView:button1];
    
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image2 = [UIImage imageNamed:@"messagechats"];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0,0,20, 20);
    [button2 addTarget:self
                action:@selector(buttonPress2:)
      forControlEvents:UIControlEventTouchDown];
    [button2 setBackgroundImage:image2 forState:UIControlStateNormal];
    self.navButton2 = [[ENMBadgedBarButtonItem alloc] initWithCustomView:button2];
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image3 = [UIImage imageNamed:@"friendrequest"];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(0,0,20, 20);
    [button3 addTarget:self
                action:@selector(buttonPress3:)
      forControlEvents:UIControlEventTouchDown];
    [button3 setBackgroundImage:image3 forState:UIControlStateNormal];
    self.navButton3 = [[ENMBadgedBarButtonItem alloc] initWithCustomView:button3];
    
    // Create "Spacer" bar button items
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 20.0f; // or whatever you want
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.navigationItem.rightBarButtonItems=@[self.navButton1,fixedItem,self.navButton2,fixedItem,self.navButton3,flexibleItem];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self serviceCallingForGettingUserStatus];
    [self serviceCallingForGettingImageUrl];
    [self serviceCallingForGettingPushBadgeCount];
    gettedIsAddressEntered=[[WHSingletonClass sharedManager] singletonIsAddressEntered];
    
}

#pragma mark - Private
-(void)buttonPress1:(id)sender
{
    
    [self performSegueWithIdentifier:@"notificationSegueVC" sender:nil];
}

-(void)buttonPress2:(id)sender
{
    
    [self performSegueWithIdentifier:@"messagesSegueVC" sender:nil];
}

-(void)buttonPress3:(id)sender
{
    
    [self performSegueWithIdentifier:@"requestSegueVC" sender:nil];
}
- (void)compareDates{
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormat dateFromString:getRegistrationDate];
    NSDate *endDate = [dateFormat dateFromString:currentDateString];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    
    
    if ([components day] > 7) {
        
        if ([gettedIsAddressEntered isEqualToString:@"Yes"] || [gettedIsAddressEntered isEqualToString:@"yes"] || [gettedIsAddressEntered isEqualToString:@"YES"]) {
            status=@"5";
            [self serviceCallingForUpdatingStatus];
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You were provided temporary access. We have posted Verification code at your address. Please login again to enter the same to ensure permanent access." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else{
            
            status=@"6";
            [self serviceCallingForUpdatingStatus];
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You were provided temporary access. Please update your address to get verification code at your door. Please login again to enter the same to ensure permanent access." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        
    }
    else{
        
        if ([gettedIsAddressEntered isEqualToString:@"No"] || [gettedIsAddressEntered isEqualToString:@"no"] || [gettedIsAddressEntered isEqualToString:@"NO"]) {
            
            if (self.value==1) {
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please go to settings and update your address now, othwerwise your connection would be lost." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
            else{
                
            }
        }
    }
}

// method for calculating current date.
- (void) getCurrentDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    // convert it to a string
    NSString *dateString = [dateFormat stringFromDate:date];
    currentDateString=dateString;
    
}

- (void) customiseUI{
    self.viewProfile.backgroundColor=[UIColor whiteColor];
    self.viewProfile.layer.borderColor=[UIColor whiteColor].CGColor;
    self.viewProfile.layer.borderWidth=0.5f;
    self.viewProfile.layer.cornerRadius=2.0f;
    self.viewProfile.layer.masksToBounds=YES;
}

-(void) getValues{
    
    
    self.labelName.text=[NSString stringWithFormat:@"%@",[[WHSingletonClass sharedManager]singletonWeehiveName]];
    
    if ([[WHSingletonClass sharedManager] singletonOccupation].length!=0) {
        
        self.labelOccupation.text=[[WHSingletonClass sharedManager] singletonOccupation];
    }
    else{
        self.labelOccupation.text=@"Occupation not mentioned";
    }
    
    getInterest1=[[WHSingletonClass sharedManager]singletonInterestOne];
    getInterest2=[[WHSingletonClass sharedManager]singletonInterestTwo];
    getInterest3=[[WHSingletonClass sharedManager]singletonInterestThree];
    
    if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length==0) {
        
        self.labelInterest.text=@"No Interests";
    }
    else{
        
        if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length!=0) {
            self.labelInterest.text=[NSString stringWithFormat:@"%@/%@",getInterest2,getInterest3];
        }
        else if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length!=0){
            self.labelInterest.text=[NSString stringWithFormat:@"%@",getInterest3];
        }
        else if (getInterest2.length==0 && getInterest1.length!=0 && getInterest3.length!=0){
            self.labelInterest.text=[NSString stringWithFormat:@"%@/%@",getInterest1,getInterest3];
        }
        else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length!=0){
            self.labelInterest.text=[NSString stringWithFormat:@"%@/%@/%@",getInterest1,getInterest2,getInterest3];
        }
        else if (getInterest1.length!=0 && getInterest2.length==0 && getInterest3.length==0){
            self.labelInterest.text=[NSString stringWithFormat:@"%@",getInterest1];
        }
        else if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length==0){
            self.labelInterest.text=[NSString stringWithFormat:@"%@",getInterest2];
        }
        else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length==0){
            self.labelInterest.text=[NSString stringWithFormat:@"%@/%@",getInterest1,getInterest2];
        }
        else{
            
        }
    }
    
    
}

// Tap Gesture
- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCalled:)];
    [self.viewProfile addGestureRecognizer:tapGesture];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WHHomeCollectionViewCell *cell = (WHHomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"homeCustomCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.cornerRadius=2.0f;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.5f;
    cell.backgroundColor=[UIColor whiteColor];
    cell.alpha=0.5;
    cell.layer.masksToBounds=YES;
    cell.imageViewModules.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark  UICollectionView Delegate.

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Check that segue exist in array or not.
    if (indexPath.row < segueNames.count) {
        
        [self performSegueWithIdentifier:segueNames[indexPath.row] sender:nil];
    }
    else{
    }
}

#pragma mark  UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger width = collectionView.frame.size.width - 30;
    return CGSizeMake(width/2, width/3);
}

// UITapGestureRecognizer Selector
- (void)tapGestureCalled:(UITapGestureRecognizer *)sender {
    
    [self performSegueWithIdentifier:@"editProfileSegueVC" sender:nil];
}



//service calling for getting badges which has to be shown on bell icon.
- (void) serviceCallingForGettingPushBadgeCount{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&device_id=%@",userId,deviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_PUSHBADGE]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 badgeListData=[[WHBadgeListModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHBadgeListDetailsModel *each in badgeListData.badge) {
                     
                     badgeValue=each.badge;
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     
                     
                     self.navButton1.badgeBackgroundColor=[UIColor redColor];
                     self.navButton1.badgeValue=[NSString stringWithFormat:@"%d", badgeValue];
                     self.navButton1.badgeTextColor=[UIColor whiteColor];
                     //  }
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




//service calling for getting image url
- (void) serviceCallingForGettingImageUrl{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",userId,token,deviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_IMAGEURL]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 loginData=[[WHLoginModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHLoginDetailsModel *each in loginData.user_Details) {
                     
                     getImageString=each.image;
                     getOccupation=each.occupation;
                     getInterest1=each.interest1;
                     getInterest2=each.interest2;
                     getInterest3=each.interest3;
                     
                 }
                 
                 sharedObject.singletonImage=getImageString;
                 sharedObject.singletonOccupation=getOccupation;
                 sharedObject.singletonInterestOne=getInterest1;
                 sharedObject.singletonInterestTwo=getInterest2;
                 sharedObject.singletonInterestThree=getInterest3;
                 //  getImageString=[[WHSingletonClass sharedManager]singletonImage];
                 [self getValues];
                 
                 //LAZY LOADING.
                 NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,getImageString];
                 
                 [self.imageViewProfilePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
                 
             }];
            
        });
        
    }
    else {
        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
    }
    
}

//service calling for getting image url
- (void) serviceCallingForGettingUserStatus{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&device_id=%@",userId,token,deviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_USERSTATUS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 
                 
                 if (json!=0) {
                     
                     messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                     tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                     userStatus=[[WHStatusModel alloc]initWithDictionary:json error:&err];
                     
                     if ([tokenStatus.error isEqualToString:@"0"]) {
                         [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     }
                     else if ([messageStatus.Msg isEqualToString:@"0"]){
                         [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     }
                     else{
                         gettedUserStatus=userStatus.status;
                         sharedObject.singletonStatus=userStatus.status;
                         
                         if ([gettedUserStatus isEqualToString:@"4"]) {
                             
                         }
                         else{
                             [self getCurrentDate];
                             [self compareDates];
                             
                         }
                     }
                 }
                 else{
                     
                 }
                 
             }];
            
        });
        
    }
    
    
    else {
        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
    }
    
}




//service calling for updatingStatus
- (void) serviceCallingForUpdatingStatus{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        NSString *details = [NSString stringWithFormat:@"status=%@&token=%@&user_id=%@&device_id=%@",status,token,userId,deviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_STATUS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
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
        
        if ([tokenStatus.error isEqualToString:@"0"]) {
            NSString *string=@"0";
            [defaults setObject:string forKey:@"LOGGED"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    else{
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"editProfileSegueVC"]) {
        WHUpdateProfileViewController *secondVC = segue.destinationViewController;
        secondVC.getIndicatorTemp=1;
    }
    else{
        
    }
    
}

- (IBAction)barButtonGroupRequestPressed:(id)sender {
    
    
}

@end
