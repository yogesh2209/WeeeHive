//
//  WHNeighborLikeKnowViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHNeighborLikeKnowViewController.h"

//Alert Class
#import "ASNetworkAlertClass.h"

//Constant file for URLs
#import "Constant.h"

//Progress View
#import "SVProgressHUD.h"

//Singleton Class
#import "WHSingletonClass.h"

//JSON Classes
#import "JSONHTTPClient.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHProfileModel.h"
#import "WHProfileDetailsModel.h"

#import "WHTypeModel.h"
#import "WHTypeDetailsModel.h"
#import "WHSchoolListModel.h"
#import "WHSchoolListDetailsModel.h"
#import "WHCollegeListModel.h"
#import "WHCollegeListDetailsModel.h"

//TableView Cells
#import "WHNegKnowListTableViewCell.h"
#import "WHSchoolNegKnowTableViewCell.h"
#import "WHCollegeNegKnowTableViewCell.h"

//Other ViewControllers
#import "WHNeighborKnowDetailsViewController.h"

#import "UIImageView+WebCache.h"


@interface WHNeighborLikeKnowViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    //JSON Objects
    WHMessageModel *messageStatus;
    WHTokenErrorModel *tokenStatus;
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHTypeModel *typeData;
    WHTypeDetailsModel *typeInfoModel;
    WHSingletonClass *sharedObject;
    
    NSUserDefaults *defaults;
    
    WHSchoolListModel *schoolData;
    WHSchoolListDetailsModel *schoolInfoModel;
    NSString *gettedDeviceId;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSString *getStatus;
    NSString *userId;
    NSString *token;
    NSIndexPath *getIndexPath;
    NSString *getFriendUserId;
    NSString *newString;
    NSMutableArray *collegeArray;
    NSMutableArray *schoolArray;
    NSMutableArray *typeArray;
    NSArray *ageArray;
    NSString *getMinimumAge;
    NSString *getMaximumAge;
    BOOL isClicked;
    BOOL isPressed;
    int temp;
    BOOL isOccupationSelected;
    BOOL isStateSelected;
    NSInteger indexValue;
    NSArray *neighorKnowFilterArray;
    NSArray *globalSearchArray;
    NSInteger getIndexPathRow;
    NSDictionary *jsonSchool;
    NSDictionary *jsonCollege;
    NSString *gettedIndicator;
    
    NSString *gettedFirstName;
    NSString *gettedLastName;
    NSString *gettedImageString;
    
    IBOutlet UITableView *tableViewNeghKnowList;
    IBOutlet UITableView *tableViewCollege;
    IBOutlet UITableView *tableViewSchool;
    
   
    NSString *sendIndicator;
    NSString *getOccupationId;
    NSString *codeInterest1;
    NSString *codeInterest2;
    NSString *codeInterest3;
    NSString *getStateId;
    NSString *getCityId;
    NSString *getWorkInterestId;
    NSString *getSchoolId;
    NSString *getCollegeId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSArray *autoSchoolArray;
    NSArray *autoCollegeArray;
    NSArray *values;
    NSDictionary *json1;
    NSMutableArray *tempArray;
    
    
}
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *labelDisplayAge;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAge;
@property (strong, nonatomic) IBOutlet UIButton *buttonAge;
@property (strong, nonatomic) IBOutlet UIView *viewAge;
@property (strong, nonatomic) IBOutlet UIView *viewState;
@property (strong, nonatomic) IBOutlet UITextField *textFieldState;
@property (strong, nonatomic) IBOutlet UIButton *buttonState;
@property (strong, nonatomic) IBOutlet UIView *viewCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) IBOutlet UIButton *buttonCity;
@property (strong, nonatomic) IBOutlet UIView *viewInterest1;
@property (strong, nonatomic) IBOutlet UITextField *textFieldInterest1;
@property (strong, nonatomic) IBOutlet UIButton *buttonInterest1;
@property (strong, nonatomic) IBOutlet UIView *viewInterest2;
@property (strong, nonatomic) IBOutlet UITextField *textFieldInterest2;
@property (strong, nonatomic) IBOutlet UIButton *buttonInterest2;
@property (strong, nonatomic) IBOutlet UIView *viewInterest3;
@property (strong, nonatomic) IBOutlet UITextField *textFieldInterest3;
@property (strong, nonatomic) IBOutlet UIButton *buttonInterest3;
@property (strong, nonatomic) IBOutlet UIView *viewOccupation;
@property (strong, nonatomic) IBOutlet UITextField *textFieldOccupation;
@property (strong, nonatomic) IBOutlet UIButton *buttonOccupation;
@property (strong, nonatomic) IBOutlet UIView *viewWorkInterest;
@property (strong, nonatomic) IBOutlet UITextField *textFieldWorkInterest;
@property (strong, nonatomic) IBOutlet UIButton *buttonWorkInterest;
@property (strong, nonatomic) IBOutlet UIView *viewSchool;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSchool;
@property (strong, nonatomic) IBOutlet UIButton *buttonSchool;
@property (strong, nonatomic) IBOutlet UIView *viewCollege;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCollege;
@property (strong, nonatomic) IBOutlet UIButton *buttonCollege;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCollegeList;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSchoolList;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNegKnowList;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *buttonDone;
@property (strong, nonatomic) IBOutlet UILabel *labelStateHeader;
@property (strong, nonatomic) IBOutlet UILabel *labelInterestHeader;
@property (strong, nonatomic) IBOutlet UILabel *labelOccuaptionHeader;
@property (strong, nonatomic) IBOutlet UILabel *labelSchoolHeader;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonFilter;


@end

@implementation WHNeighborLikeKnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    tempArray=[NSMutableArray new];
    values=[[NSArray alloc]init];
    globalSearchArray=[[NSArray alloc]init];
    [self getValues];
    autoCollegeArray=[[NSArray alloc]init];
    autoSchoolArray=[[NSArray alloc]init];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    schoolArray=[NSMutableArray new];
    neighorKnowFilterArray=[[NSArray alloc]init];
    collegeArray=[NSMutableArray new];
    typeArray=[NSMutableArray new];
    self.tableViewNegKnowList.tableFooterView = [UIView new];
     self.tableViewSchoolList.tableFooterView = [UIView new];
     self.tableViewCollegeList.tableFooterView = [UIView new];
    ageArray=[[NSArray alloc]initWithObjects:@"less than 10 years",@"10-14 years",@"15-18 years",@"19-24 years",@"25-35 years",@"36-50 years",@"above 50 years", nil];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewNegKnowList addSubview:refreshControl];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pickerView.hidden=YES;
    self.searchBar.hidden=NO;
    self.viewCity.hidden=YES;
    self.toolBar.hidden=YES;
    self.viewCollege.hidden=YES;
    self.viewInterest1.hidden=YES;
    self.viewInterest2.hidden=YES;
    self.viewInterest3.hidden=YES;
    self.viewOccupation.hidden=YES;
    self.viewSchool.hidden=YES;
    self.labelDisplayAge.hidden=YES;
    self.viewState.hidden=YES;
    self.viewWorkInterest.hidden=YES;
    self.tableViewCollegeList.hidden=YES;
    self.tableViewSchoolList.hidden=YES;
    self.tableViewNegKnowList.hidden=NO;
    self.labelInterestHeader.hidden=YES;
    self.labelOccuaptionHeader.hidden=YES;
    self.labelSchoolHeader.hidden=YES;
    self.labelStateHeader.hidden=YES;
    self.buttonDone.hidden=YES;
    self.viewAge.hidden=YES;
    self.textFieldAge.hidden=YES;
    self.buttonAge.hidden=YES;
    temp=10;
    
   
    if ([gettedIndicator isEqualToString:@"1"]) {
        
    }
    else{
       [self serviceCallingForGettingListOfNeighbours];
    }
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    isClicked=0;
    temp=10;
    self.buttonDone.hidden=NO;
    self.pickerView.hidden=YES;
    self.toolBar.hidden=NO;
    self.pickerView.hidden=YES;
    //self.buttonAdd.hidden=NO;
    self.tableViewCollegeList.hidden=YES;
    self.tableViewSchoolList.hidden=YES;
    self.pickerView.hidden=YES;
    //  self.viewHelpIn.hidden=NO;
    //  self.viewHelpInAs.hidden=NO;
    self.viewInterest1.hidden=NO;
    self.viewInterest2.hidden=NO;
    self.viewCity.hidden=NO;
    self.viewCollege.hidden=NO;
    self.viewAge.hidden=NO;
    self.viewInterest3.hidden=NO;
    self.viewOccupation.hidden=NO;
    self.viewWorkInterest.hidden=NO;
    self.toolBar.hidden=YES;
    self.labelDisplayAge.hidden=NO;
    self.labelInterestHeader.hidden=NO;
    self.labelStateHeader.hidden=NO;
    self.labelSchoolHeader.hidden=NO;
    self.labelOccuaptionHeader.hidden=NO;
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Find Friends";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textFieldWorkInterest.backgroundColor=[UIColor clearColor];
    self.textFieldWorkInterest.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldAge.backgroundColor=[UIColor clearColor];
    self.textFieldAge.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldState.backgroundColor=[UIColor clearColor];
    self.textFieldState.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldCity.backgroundColor=[UIColor clearColor];
    self.textFieldCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldCollege.backgroundColor=[UIColor clearColor];
    self.textFieldCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldInterest1.backgroundColor=[UIColor clearColor];
    self.textFieldInterest1.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldInterest2.backgroundColor=[UIColor clearColor];
    self.textFieldInterest2.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldOccupation.backgroundColor=[UIColor clearColor];
    self.textFieldOccupation.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldInterest3.backgroundColor=[UIColor clearColor];
    self.textFieldInterest3.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldSchool.backgroundColor=[UIColor clearColor];
    self.textFieldSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewCity.backgroundColor=[UIColor clearColor];
    self.viewCity.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCity.layer.borderWidth=0.5f;
    self.viewCity.layer.cornerRadius=2.0f;
    self.viewCity.layer.masksToBounds=YES;
    self.viewCollege.backgroundColor=[UIColor clearColor];
    self.viewCollege.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCollege.layer.borderWidth=0.5f;
    self.viewCollege.layer.cornerRadius=2.0f;
    self.viewCollege.layer.masksToBounds=YES;
    self.viewInterest1.backgroundColor=[UIColor clearColor];
    self.viewInterest1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewInterest1.layer.borderWidth=0.5f;
    self.viewInterest1.layer.cornerRadius=2.0f;
    self.viewInterest1.layer.masksToBounds=YES;
    self.viewInterest2.backgroundColor=[UIColor clearColor];
    self.viewInterest2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewInterest2.layer.borderWidth=0.5f;
    self.viewInterest2.layer.cornerRadius=2.0f;
    self.viewInterest2.layer.masksToBounds=YES;
    self.viewInterest3.backgroundColor=[UIColor clearColor];
    self.viewInterest3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewInterest3.layer.borderWidth=0.5f;
    self.viewInterest3.layer.cornerRadius=2.0f;
    self.viewInterest3.layer.masksToBounds=YES;
    self.viewSchool.backgroundColor=[UIColor clearColor];
    self.viewSchool.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewSchool.layer.borderWidth=0.5f;
    self.viewSchool.layer.cornerRadius=2.0f;
    self.viewSchool.layer.masksToBounds=YES;
    self.viewState.backgroundColor=[UIColor clearColor];
    self.viewState.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewState.layer.borderWidth=0.5f;
    self.viewState.layer.cornerRadius=2.0f;
    self.viewState.layer.masksToBounds=YES;
    self.viewOccupation.backgroundColor=[UIColor clearColor];
    self.viewOccupation.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewOccupation.layer.borderWidth=0.5f;
    self.viewOccupation.layer.cornerRadius=2.0f;
    self.viewOccupation.layer.masksToBounds=YES;
    self.viewWorkInterest.backgroundColor=[UIColor clearColor];
    self.viewWorkInterest.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewWorkInterest.layer.borderWidth=0.5f;
    self.viewWorkInterest.layer.cornerRadius=2.0f;
    self.viewWorkInterest.layer.masksToBounds=YES;
    self.viewAge.backgroundColor=[UIColor clearColor];
    self.viewAge.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewAge.layer.borderWidth=0.5f;
    self.viewAge.layer.cornerRadius=2.0f;
    self.viewAge.layer.masksToBounds=YES;
    self.buttonAge.backgroundColor=[UIColor clearColor];
    self.buttonAge.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonCity.backgroundColor=[UIColor clearColor];
    self.buttonCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonOccupation.backgroundColor=[UIColor clearColor];
    self.buttonOccupation.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonCollege.backgroundColor=[UIColor clearColor];
    self.buttonCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonInterest1.backgroundColor=[UIColor clearColor];
    self.buttonInterest1.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonInterest2.layer.cornerRadius=2.0f;
    self.buttonInterest2.layer.masksToBounds=YES;
    self.buttonInterest3.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonInterest3.backgroundColor=[UIColor clearColor];
    self.buttonSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSchool.backgroundColor=[UIColor clearColor];
    self.buttonState.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonState.backgroundColor=[UIColor clearColor];
    self.buttonWorkInterest.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonWorkInterest.backgroundColor=[UIColor clearColor];
    self.tableViewCollegeList.layer.cornerRadius=2.0f;
    self.tableViewCollegeList.layer.masksToBounds=YES;
    self.tableViewCollegeList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewCollegeList.layer.borderWidth=0.5f;
    self.tableViewSchoolList.layer.cornerRadius=2.0f;
    self.tableViewSchoolList.layer.masksToBounds=YES;
    self.tableViewSchoolList.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewSchoolList.layer.borderWidth=0.5f;
    self.buttonDone.layer.cornerRadius=2.0f;
    self.buttonDone.layer.masksToBounds=YES;
    self.labelInterestHeader.text=@"Find Neighbours based on their Interest";
    self.labelOccuaptionHeader.text=@"Find Neighbours based on their Work Interest";
    self.labelSchoolHeader.text=@"Find Neighbours based on their School/College";
    self.labelStateHeader.text=@"Find Neighbours based on their Origin";
    self.labelDisplayAge.text=@"Find Neighbours based on their Age";
    
}
- (void) getValues{
    
    userId=[[WHSingletonClass sharedManager]singletonUserId];
    token=[[WHSingletonClass sharedManager]singletonToken];
    gettedFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
    
}


- (void)animateSchoolTableView {
    
    [self.tableViewSchoolList reloadData];
    NSArray *cells = self.tableViewSchoolList.visibleCells;
    CGFloat height = self.tableViewSchoolList.bounds.size.height;
    
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

- (void)animateCollegeTableView {
    
    [self.tableViewCollegeList reloadData];
    NSArray *cells = self.tableViewCollegeList.visibleCells;
    CGFloat height = self.tableViewCollegeList.bounds.size.height;
    
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


- (void)animateTableView {
    
    [self.tableViewNegKnowList reloadData];
    NSArray *cells = self.tableViewNegKnowList.visibleCells;
    CGFloat height = self.tableViewNegKnowList.bounds.size.height;
    
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

//service calling for getting list of neghbours
- (void) serviceCallingForGettingListOfNeighbours{
    globalSearchArray=nil;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&token=%@&device_id=%@",userId,token,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_NEGKNOWLIST]
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
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewNegKnowList.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No data is currently available. Please pull down to refresh.";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewNegKnowList.hidden=NO;
                     self.tableViewNegKnowList.backgroundView = messageLabel;
                     self.tableViewNegKnowList.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     sendIndicator=@"2";
    
                      json1=json;
                     neighorKnowFilterArray = [json objectForKey:@"profile"];
                     globalSearchArray=neighorKnowFilterArray;
                     

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
        
        NSString *details = [NSString stringWithFormat:@"request_by=%@&token=%@&status=%@&request_to=%@&device_id=%@&first_name=%@&last_name=%@&image=%@",userId,token,getStatus,getFriendUserId,gettedDeviceId,gettedFirstName,gettedLastName,gettedImageString];
        
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
                     
                     [self serviceCallingForGettingListOfNeighbours];
                     
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
    if (tableView==tableViewCollege) {
        
        return autoCollegeArray.count;
        
    }
    else if (tableView==tableViewSchool){
        return autoSchoolArray.count;
    }
    else{
        return neighorKnowFilterArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==tableViewSchool) {
        static NSString *cellIdentifier=@"schoolCustomCell";
        WHSchoolNegKnowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.labelSchoolName.numberOfLines=0;
        cell.labelSchoolName.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelSchoolName.text= [[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_name"];
      
        
        
        return cell;
        
    }
    else if (tableView==tableViewCollege){
        static NSString *cellIdentifier=@"collegeCustomCell";
        WHCollegeNegKnowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.labelCollegeName.numberOfLines=0;
        cell.labelCollegeName.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelCollegeName.text=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_name"];
        
        
        return cell;
        
    }
    else{
        WHNegKnowListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:WHNEGLIKEKNOW_CELL];
      
        cell.labelName.text=[NSString stringWithFormat:@"%@ %@",[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
  NSString *connectionString =[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"connections"];
        
        if (connectionString == nil || connectionString == (id)[NSNull null]){
            
            connectionString=@"";
            
        }
        
     
        
        if (connectionString.length==0) {
           cell.labelConections.text=@"No Connections";
        }
        else{
            cell.labelConections.text=[NSString stringWithFormat:@"%@ Connections",connectionString];
        }
        
        
        NSString *occupationString = [[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"occupation"];
        
        if (occupationString == nil || occupationString == (id)[NSNull null]){
            
            occupationString=@"";
            
        }
        
        if (occupationString.length!=0) {
             cell.labelOccupation.text=[NSString stringWithFormat:@"%@",occupationString];
            
        }
        else{
            cell.labelOccupation.text=@"Not mentioned";
        }
        
      //  cell.labelName.text=[NSString stringWithFormat:@"%@ %@",profileInfoModel.first_name,profileInfoModel.last_name];
        cell.imageViewNegPic.layer.cornerRadius=cell.imageViewNegPic.frame.size.height/2;
        cell.imageViewNegPic.layer.masksToBounds=YES;
        cell.imageViewNegPic.layer.borderWidth=0;
        cell.labelConections.textColor = [UIColor lightGrayColor];
        cell.labelConections.font = [UIFont fontWithName:@"Palatino-Italic" size:14];
        cell.buttonAddFriend.tag=indexPath.row;
        [cell.buttonAddFriend addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (profileInfoModel.connections.length==0) {
//            cell.labelConections.text=@"No Connections";
//        }
//        else{
//            cell.labelConections.text=[NSString stringWithFormat:@"%@ Connections",profileInfoModel.connections];
//        }
        
//        if (profileInfoModel.occupation.length!=0) {
//            cell.labelOccupation.text=[NSString stringWithFormat:@"%@",profileInfoModel.occupation];
//        }
//        else{
//            cell.labelOccupation.text=@"Not mentioned";
//        }
        
        
        getInterest1=[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"interest1"];
        getInterest2=[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"interest2"];
        getInterest3=[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"interest3"];
        
   if (getInterest3 == nil || getInterest3 == (id)[NSNull null]){
        
            getInterest3=@"";
            
        }
        
        if (getInterest2 == nil || getInterest2 == (id)[NSNull null]){
            
            getInterest2=@"";
        }
        
        if (getInterest1 == nil || getInterest1 == (id)[NSNull null]){
            
            getInterest1=@"";
        }
    
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
        
        
        NSString *gettedStatus = [[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"status"];
        
        if (gettedStatus == nil || gettedStatus == (id)[NSNull null]){
            
            cell.buttonAddFriend.hidden=NO;
            cell.buttonAddFriend.userInteractionEnabled=YES;
            cell.labelIndicatorStatus.hidden=YES;
            
        }
        
        else if ([gettedStatus isEqualToString:@"0"]) {
            cell.buttonAddFriend.hidden=YES;
            cell.labelIndicatorStatus.hidden=NO;
            cell.buttonAddFriend.userInteractionEnabled=NO;
            cell.labelIndicatorStatus.textColor = [UIColor orangeColor];
            cell.labelIndicatorStatus.text=@"Request Sent";
        }
        else if ([gettedStatus isEqualToString:@"1"]){
            cell.buttonAddFriend.hidden=YES;
            cell.labelIndicatorStatus.hidden=NO;
            cell.buttonAddFriend.userInteractionEnabled=NO;
            cell.labelIndicatorStatus.textColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0];
            cell.labelIndicatorStatus.text=@"Friends";
        }
        else{
            cell.buttonAddFriend.hidden=NO;
            cell.buttonAddFriend.userInteractionEnabled=YES;
            cell.labelIndicatorStatus.hidden=YES;
            
        }
        
        //LAZY LOADING
        newString = [[[neighorKnowFilterArray objectAtIndex:indexPath.row] valueForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,newString];
        [cell.imageViewNegPic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
        
        return  cell;

    }
    
    
}

#pragma mark  UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    getIndexPath=indexPath;
    
    if (tableView==tableViewSchool) {
        
        getSchoolId=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_id"];
        self.tableViewSchoolList.hidden=YES;
        self.tableViewCollegeList.hidden=YES;
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.textFieldSchool.text=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_name"];
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterestHeader.hidden=NO;
        self.labelOccuaptionHeader.hidden=NO;
        self.labelDisplayAge.hidden=NO;
    }
    else if(tableView==tableViewCollege){
        
        getCollegeId=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_id"];
        self.tableViewCollegeList.hidden=YES;
        self.tableViewSchoolList.hidden=YES;
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.textFieldCollege.text=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_name"];
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewAge.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterestHeader.hidden=NO;
        self.labelOccuaptionHeader.hidden=NO;
        self.labelDisplayAge.hidden=NO;
        
        
        
    }
    else{
        profileInfoModel=neighorKnowFilterArray[indexPath.row];
      //  getIndexPath=indexPath;
     
        getIndexPathRow=indexPath.row;
        [self performSegueWithIdentifier:@"negKnowDetailsSegueVC" sender:nil];
        
    }
    
}

#pragma mark  UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (temp==18) {
        
        return [ageArray count];
    }
    else{
       return [typeArray count];
        
    }
    
    
}


//title for each row.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (temp==18) {
        indexValue=0;
        return [ageArray objectAtIndex:row];
    }
    else{
        indexValue=0;
        return [typeArray objectAtIndex:row];
    }
    
    
    
}

#pragma mark  UIPickerView Delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    indexValue=row;
}


#pragma mark  UINavigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    WHNegKnowListTableViewCell *cell = (WHNegKnowListTableViewCell *)[self.tableViewNegKnowList cellForRowAtIndexPath:getIndexPath];
    WHNeighborKnowDetailsViewController *secondVC = segue.destinationViewController;
    secondVC.getImage = cell.imageViewNegPic.image;
    secondVC.getIndicator=sendIndicator;
    secondVC.delegate = self;
  
    
    secondVC.firstName=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"first_name"];
    secondVC.lastName=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"last_name"];
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"occupation"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"occupation"] == (id)[NSNull null]){
        
        secondVC.occupation=@"";
        
    }
    else{
          secondVC.occupation=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"occupation"];
    }
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest2"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest2"] == (id)[NSNull null]){
        
        secondVC.morningAct=@"";
        
    }
    else{
        secondVC.morningAct=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest2"];
        
    }
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest3"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest3"] == (id)[NSNull null]){
        
        secondVC.eveningAct=@"";
        
    }
    else{
        secondVC.eveningAct=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest3"];
        
    }
    
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest1"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest1"] == (id)[NSNull null]){
        
        secondVC.weekendAct=@"";
        
    }
    else{
        secondVC.weekendAct=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"interest1"];
        
    }
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"current_purpose"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"current_purpose"] == (id)[NSNull null]){
        
        secondVC.purpose=@"";
        
    }
    else{
        secondVC.purpose=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"current_purpose"];
        
    }

    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"living_since"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"living_since"] == (id)[NSNull null]){
        
        secondVC.livingSince=@"";
        
    }
    else{
        secondVC.livingSince=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"living_since"];
        
    }
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"dob"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"dob"] == (id)[NSNull null]){
        
        secondVC.age=@"";
        
    }
    else{
        secondVC.age=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"dob"];
        
    }

    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"help_in_as"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"help_in_as"] == (id)[NSNull null]){
        
        secondVC.help=@"";
        
    }
    else{
        secondVC.help=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"help_in_as"];
        
    }

    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"status"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"status"] == (id)[NSNull null]){
        
        secondVC.status=@"";
        
    }
    else{
        secondVC.status=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"status"];
        
    }
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"user_id"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"user_id"] == (id)[NSNull null]){
        
        secondVC.friendUserId=@"";
        
    }
    else{
        secondVC.friendUserId=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"user_id"];
        
    }

    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"work_interest"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"work_interest"] == (id)[NSNull null]){
        
        secondVC.getWorkInterest=@"";
        
    }
    else{
        secondVC.getWorkInterest=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"work_interest"];
        
    }
    
    if ([[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"origin"] == nil || [[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"origin"] == (id)[NSNull null]){
        
        secondVC.getOrigin=@"";
        
    }
    else{
        secondVC.getOrigin=[[neighorKnowFilterArray objectAtIndex:getIndexPathRow] valueForKey:@"origin"];
        
    }
    
  
  
    
    
//    secondVC.firstName=profileInfoModel.first_name;
//    secondVC.lastName=profileInfoModel.last_name;
//    secondVC.occupation=profileInfoModel.occupation;
//    secondVC.morningAct=profileInfoModel.interest2;
//    secondVC.eveningAct=profileInfoModel.interest3;
//    secondVC.weekendAct=profileInfoModel.interest1;
//    secondVC.purpose=profileInfoModel.current_purpose;
//    secondVC.age=profileInfoModel.dob;
//    secondVC.livingSince=profileInfoModel.living_since;
//    secondVC.help=profileInfoModel.help_in_as;
//    secondVC.maritalStatus=profileInfoModel.marital_status;
//    secondVC.status=profileInfoModel.status;
//    secondVC.friendUserId=profileInfoModel.user_id;
//    secondVC.getWorkInterest=profileInfoModel.work_interest;
}

-(void)addButtonClick:(id)sender{
    UIButton *senderButton=(UIButton *)sender;
  getFriendUserId=[[neighorKnowFilterArray objectAtIndex:senderButton.tag] valueForKey:@"user_id"];
    getStatus=@"0";
    [self serviceCallingForSendingFriendRequest];
}
- (IBAction)barButtonFilterPressed:(id)sender {
    
    if (isPressed==0) {
        isPressed=1;
        self.tableViewNegKnowList.hidden=YES;
        self.searchBar.hidden=YES;
        self.viewCity.hidden=NO;
        self.viewCollege.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewSchool.hidden=NO;
        self.viewState.hidden=NO;
        self.tableViewSchoolList.hidden=YES;
        self.tableViewCollegeList.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterestHeader.hidden=NO;
        self.labelOccuaptionHeader.hidden=NO;
        self.labelSchoolHeader.hidden=NO;
        self.labelStateHeader.hidden=NO;
        self.viewAge.hidden=NO;
        self.textFieldAge.hidden=NO;
        self.buttonAge.hidden=NO;
        self.labelDisplayAge.hidden=NO;
        self.textFieldCity.text=@"";
        self.textFieldInterest1.text=@"";
        self.textFieldInterest2.text=@"";
        self.textFieldInterest3.text=@"";
        self.textFieldOccupation.text=@"";
        self.textFieldState.text=@"";
        self.textFieldAge.text=@"";
        self.textFieldWorkInterest.text=@"";
    }
    else{
        isPressed=0;
        self.tableViewNegKnowList.hidden=NO;
        self.searchBar.hidden=NO;
        self.viewCity.hidden=YES;
        self.viewCollege.hidden=YES;
        self.viewInterest1.hidden=YES;
        self.viewInterest2.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewSchool.hidden=YES;
        self.viewState.hidden=YES;
        self.tableViewSchoolList.hidden=YES;
        self.tableViewCollegeList.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewWorkInterest.hidden=YES;
        self.labelInterestHeader.hidden=YES;
        self.labelOccuaptionHeader.hidden=YES;
        self.labelSchoolHeader.hidden=YES;
        self.labelStateHeader.hidden=YES;
        self.viewAge.hidden=YES;
        self.textFieldAge.hidden=YES;
        self.buttonAge.hidden=YES;
        self.labelDisplayAge.hidden=YES;
    }
    
}


#pragma mark  DROPDOWN BUTTON ACTIONS
- (IBAction)buttonStatePressed:(id)sender {
    temp=10;
    if (isClicked==0) {
        isClicked=1;
        
        [self serviceCallingForGettingState];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonDone.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolBar.hidden=YES;
    }
    
}
- (IBAction)buttonCityPressed:(id)sender {
    
    if (isStateSelected==0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select State first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        
        temp=15;
        if (isClicked==0) {
            isClicked=1;
            
            [self serviceCallingForGettingCity];
            // default frame is set
            float pvHeight = self.pickerView.frame.size.height;
            float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
            [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
            } completion:nil];
            self.pickerView.hidden=NO;
            self.pickerView.showsSelectionIndicator=YES;
            self.pickerView.showsSelectionIndicator=YES;
            self.toolBar.hidden=NO;
            self.buttonDone.hidden=YES;
            
            
        }
        else if (isClicked==1){
            isClicked=0;
            self.pickerView.hidden=YES;
            self.buttonDone.hidden=NO;
            self.toolBar.hidden=YES;
        }
    }
}
- (IBAction)buttonInterest1:(id)sender {
    temp=2;
    if (isClicked==0) {
        isClicked=1;
        
        [self serviceCallingForGettingInterestsAndOccupation];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonDone.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolBar.hidden=YES;
    }
    
}

- (IBAction)buttonInterest2Pressed:(id)sender {
    temp=7;
    if (isClicked==0) {
        isClicked=1;
        
       [self serviceCallingForGettingInterestsAndOccupation];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonDone.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolBar.hidden=YES;
    }
    
}
- (IBAction)buttonInterest3Pressed:(id)sender {
    temp=6;
    if (isClicked==0) {
        isClicked=1;
        
       [self serviceCallingForGettingInterestsAndOccupation];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonDone.hidden=YES;
        
 
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolBar.hidden=YES;
    }
    
}



- (IBAction)buttonOccupationPressed:(id)sender {
    temp=5;
    if (isClicked==0) {
        isClicked=1;
        
        [self serviceCallingForGettingInterestsAndOccupation];
        
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonDone.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolBar.hidden=YES;
    }
    
}
- (IBAction)buttonWorkInterestPressed:(id)sender {
    
    if (isOccupationSelected==0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select Occupation first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        
        temp=16;
        if (isClicked==0) {
            isClicked=1;
            
            [self serviceCallingForGettingWorkInterest];
            // default frame is set
            float pvHeight = self.pickerView.frame.size.height;
            float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
            [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
            } completion:nil];
            self.pickerView.hidden=NO;
            self.pickerView.showsSelectionIndicator=YES;
            self.pickerView.showsSelectionIndicator=YES;
            self.toolBar.hidden=NO;
            self.buttonDone.hidden=YES;
            
        }
        else if (isClicked==1){
            isClicked=0;
            self.pickerView.hidden=YES;
            self.buttonDone.hidden=NO;
            self.toolBar.hidden=YES;
        }
    }
}
- (IBAction)buttonSchoolPressed:(id)sender {
    temp=9;
    if (isClicked == 0){
        
        [self serviceCallingForSchoolList];
        
        [UIView animateWithDuration:0.2f
                              delay:0.0
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect frame = self.tableViewSchoolList.frame;
                             frame.size.height = 116;
                             self.tableViewSchoolList.frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        self.tableViewSchoolList.hidden=NO;
        
        isClicked=1;
        self.tableViewSchoolList.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewSchoolList.layer.borderWidth=0.5f;
        self.tableViewSchoolList.layer.cornerRadius=2.0f;
        self.tableViewSchoolList.layer.masksToBounds=YES;
        self.buttonDone.hidden=YES;
        self.viewCity.hidden=YES;
        self.viewInterest1.hidden=YES;
        self.viewInterest2.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.labelInterestHeader.hidden=YES;
        self.labelOccuaptionHeader.hidden=YES;
        self.labelDisplayAge.hidden=YES;
    }
    else if (isClicked == 1){
        
        [ UIView animateWithDuration:0.2f
                               delay:0.0
                             options: UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              CGRect frame = self.tableViewSchoolList.frame;
                              frame.size.height = 0;
                              self.tableViewSchoolList.frame = frame;
                          }
                          completion:^(BOOL finished){
                             
                          }];
        self.tableViewSchoolList.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewSchoolList.layer.borderWidth=0.5f;
        self.tableViewSchoolList.hidden=YES;
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterestHeader.hidden=NO;
        self.labelOccuaptionHeader.hidden=NO;
        self.labelDisplayAge.hidden=NO;
    }
    else{
        
    }
    
    
}
- (IBAction)buttonCollegePressed:(id)sender {
    temp=8;
    if (isClicked == 0){
        
        [self serviceCallingForCollegeList];
        
        [UIView animateWithDuration:0.2f
                              delay:0.0
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect frame = self.tableViewCollegeList.frame;
                             frame.size.height = 116;
                             self.tableViewCollegeList.frame = frame;
                         }
                         completion:^(BOOL finished){
                           
                         }];
        
        self.tableViewCollegeList.hidden=NO;
        self.tableViewSchoolList.hidden=YES;
        isClicked=1;
        self.tableViewCollegeList.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewCollegeList.layer.borderWidth=0.5f;
        self.tableViewCollegeList.layer.cornerRadius=2.0f;
        self.tableViewCollegeList.layer.masksToBounds=YES;
        self.buttonDone.hidden=YES;
        self.viewCity.hidden=YES;
        self.viewInterest1.hidden=YES;
        self.viewInterest2.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.labelInterestHeader.hidden=YES;
        self.labelOccuaptionHeader.hidden=YES;
        self.labelDisplayAge.hidden=YES;
    }
    else if (isClicked == 1){
        
        [ UIView animateWithDuration:0.2f
                               delay:0.0
                             options: UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              CGRect frame = self.tableViewCollegeList.frame;
                              frame.size.height = 0;
                              self.tableViewCollegeList.frame = frame;
                          }
                          completion:^(BOOL finished){
                             
                          }];
        self.tableViewCollegeList.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewCollegeList.layer.borderWidth=0.5f;
        self.tableViewCollegeList.hidden=YES;
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterestHeader.hidden=NO;
        self.labelOccuaptionHeader.hidden=NO;
        self.labelDisplayAge.hidden=NO;
        
    }
    else{
        
    }
    
    
}




#pragma mark  SERVICE CALLING

//service calling for getting School List
- (void) serviceCallingForSchoolList{
    
    [schoolArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"value=%d",temp];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_SCHOOLLIST]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
               
                 schoolData=[[WHSchoolListModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHSchoolListDetailsModel *each in schoolData.school_List) {
                     
                     [schoolArray addObject:each.school_name];
                   
                     
                 }
                 
                 //autoSchoolArray=[schoolArray mutableCopy];
                 jsonSchool=json;
                 
                 
                 autoSchoolArray = [json objectForKey:@"school_List"];
                
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateSchoolTableView];
                     
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


//service calling for getting College List
- (void) serviceCallingForCollegeList{
    
    
    [collegeArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"value=%d",temp];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_TYPES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                     typeData=[[WHTypeModel alloc]initWithDictionary:json error:&err];
                     
                     for (WHTypeDetailsModel *each in typeData.type) {
                         
                         [collegeArray addObject:each.college_name];
                         
                     }
                 
                 jsonCollege=json;
                 
                 
                 autoCollegeArray = [json objectForKey:@"type"];
               //  totalSchoolArray=autoSchoolArray;
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self animateCollegeTableView];
                     
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

//service calling for getting Fields
- (void) serviceCallingForGettingState{
    
    [typeArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"value=%d",temp];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_TYPES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
            
                 typeData=[[WHTypeModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHTypeDetailsModel *each in typeData.type) {
                     
                     [typeArray addObject:each.state];
                     
                 }
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.pickerView reloadAllComponents];
                     
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

//service calling for getting Fields
- (void) serviceCallingForGettingInterestsAndOccupation{
    
    [typeArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"value=%d",temp];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_TYPES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
               
                 typeData=[[WHTypeModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHTypeDetailsModel *each in typeData.type) {
                     
                     [typeArray addObject:each.full_name];
                     
                 }
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.pickerView reloadAllComponents];
                     
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

//service calling for getting Work Interest
- (void) serviceCallingForGettingWorkInterest{
    
    [typeArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"value=%d&occupation_id=%@",temp,getOccupationId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_TYPES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
             
                 typeData=[[WHTypeModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHTypeDetailsModel *each in typeData.type) {
                     
                     [typeArray addObject:each.work_interest];
                     
                 }
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.pickerView reloadAllComponents];
                     
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


//service calling for getting City
- (void) serviceCallingForGettingCity{
    
    [typeArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"value=%d&state_id=%@",temp,getStateId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_TYPES]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
              
                 typeData=[[WHTypeModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHTypeDetailsModel *each in typeData.type) {
                     
                     [typeArray addObject:each.city];
                     
                 }
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.pickerView reloadAllComponents];
                     
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


//service calling for getting Filtered List
- (void) serviceCallingForGettingFilteredtList{
    
    globalSearchArray=nil;
    
     if (getCityId == nil || getCityId == (id)[NSNull null]){
        
        getCityId=@"";
        
    }
    else{
        
    }
    
    if (getStateId == nil || getStateId == (id)[NSNull null]){
        
        getStateId=@"";
        
    }
    else{
        
    }
    
    if (codeInterest3 == nil || codeInterest3 == (id)[NSNull null]){
        
        codeInterest3=@"";
        
    }
    else{
        
    }
    
    if (codeInterest1 == nil || codeInterest1 == (id)[NSNull null]){
        
        codeInterest1=@"";
        
    }
    else{
        
    }
    
    if (getWorkInterestId == nil || getWorkInterestId == (id)[NSNull null]){
        
        getWorkInterestId=@"";
        
    }
    else{
        
    }
    
    if (getMinimumAge == nil || getMinimumAge == (id)[NSNull null]){
        
        getMinimumAge=@"";
        
    }
    else{
        
    }
    
    if (getMaximumAge == nil || getMaximumAge == (id)[NSNull null]){
        
        getMaximumAge=@"";
        
    }
    else{
        
    }
    
   if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&origin=%@&origin_city=%@&interest1=%@&interest2=%@&interest3=%@&work_interest=%@&occupation=%@&min_age=%@&max_age=%@",userId,getStateId,getCityId,codeInterest1,codeInterest2,codeInterest3,getWorkInterestId,getOccupationId,getMinimumAge,getMaximumAge];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_FILTEREDNEGHKNOW]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     self.viewCity.hidden=YES;
                     self.viewCollege.hidden=YES;
                     self.viewInterest1.hidden=YES;
                     self.viewInterest2.hidden=YES;
                     self.viewInterest3.hidden=YES;
                     self.viewOccupation.hidden=YES;
                     self.viewSchool.hidden=YES;
                     self.viewState.hidden=YES;
                     self.viewWorkInterest.hidden=YES;
                     self.tableViewCollegeList.hidden=YES;
                     self.tableViewSchoolList.hidden=YES;
                     self.tableViewNegKnowList.hidden=YES;
                     self.labelInterestHeader.hidden=YES;
                     self.labelOccuaptionHeader.hidden=YES;
                     self.labelSchoolHeader.hidden=YES;
                     self.labelStateHeader.hidden=YES;
                     self.labelDisplayAge.hidden=YES;
                     self.viewAge.hidden=YES;
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     self.tableViewNegKnowList.hidden=YES;
                     self.textFieldCity.text=@"";
                     self.textFieldCollege.text=@"";
                     self.textFieldInterest1.text=@"";
                     self.textFieldInterest2.text=@"";
                     self.textFieldInterest3.text=@"";
                     self.textFieldOccupation.text=@"";
                     self.textFieldSchool.text=@"";
                     self.textFieldState.text=@"";
                     self.textFieldAge.text=@"";
                     self.textFieldWorkInterest.text=@"";
                     self.textFieldWorkInterest.text=@"";
                     self.labelInterestHeader.hidden=NO;
                     self.labelOccuaptionHeader.hidden=NO;
                     self.labelSchoolHeader.hidden=NO;
                     self.labelStateHeader.hidden=NO;
                     self.labelDisplayAge.hidden=NO;
                     self.textFieldAge.hidden=NO;
                     self.viewAge.hidden=NO;
                    
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No record found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else{
                     sendIndicator=@"1";
                     isPressed=0;
                     json1=json;
                     neighorKnowFilterArray = [json objectForKey:@"profile"];
                     globalSearchArray=neighorKnowFilterArray;
                     
                     self.viewCity.hidden=YES;
                     self.viewCollege.hidden=YES;
                     self.viewInterest1.hidden=YES;
                     self.viewInterest2.hidden=YES;
                     self.viewInterest3.hidden=YES;
                     self.viewOccupation.hidden=YES;
                     self.viewAge.hidden=YES;
                     self.viewSchool.hidden=YES;
                     self.viewState.hidden=YES;
                     self.viewWorkInterest.hidden=YES;
                     self.tableViewCollegeList.hidden=YES;
                     self.tableViewSchoolList.hidden=YES;
                     self.tableViewNegKnowList.hidden=NO;
                     self.labelInterestHeader.hidden=YES;
                     self.labelOccuaptionHeader.hidden=YES;
                     self.labelSchoolHeader.hidden=YES;
                     self.labelStateHeader.hidden=YES;
                     self.labelDisplayAge.hidden=YES;
                     self.searchBar.hidden=NO;
                     
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
- (IBAction)buttonDonePressed:(id)sender {
    if (self.textFieldCity.text.length==0 && self.textFieldCollege.text.length==0 && self.textFieldInterest1.text.length==0 && self.textFieldInterest2.text.length==0 && self.textFieldInterest3.text.length==0 && self.textFieldOccupation.text.length==0 && self.textFieldSchool.text.length==0 && self.textFieldState.text.length==0 && self.textFieldWorkInterest.text.length==0 && self.textFieldAge.text.length==0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select atleast one of the fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        
        [self serviceCallingForGettingFilteredtList];
    }
    
}

- (IBAction)buttonAgePressed:(id)sender {
    temp=18;
    if (isClicked==0) {
        isClicked=1;
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonDone.hidden=YES;
        [self.pickerView reloadAllComponents];
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolBar.hidden=YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.textFieldSchool) {
    
        temp=9;
        [self serviceCallingForSchoolList];
        self.tableViewSchoolList.hidden=NO;
        self.tableViewCollegeList.hidden=YES;
    }
    else if (textField==self.textFieldCollege){
      
        temp=8;
        [self serviceCallingForCollegeList];
        self.tableViewCollegeList.hidden=NO;
        self.tableViewSchoolList.hidden=YES;
    }
    else{
        
    }
    
    
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    autoSchoolArray=nil;
    autoCollegeArray=nil;
    
    if (textField==self.textFieldSchool) {
        
        NSString * searchStr = [self.textFieldSchool.text stringByReplacingCharactersInRange:range withString:string];
        NSString * match = searchStr;
        if (match.length == 0) {
            
            autoSchoolArray=[jsonSchool objectForKey:@"school_List"];
            
        } else {
            
            self.tableViewSchoolList.hidden=NO;
            self.tableViewCollegeList.hidden=YES;
            NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                                       @"school_name BEGINSWITH[c] %@", match];
            autoSchoolArray = [[jsonSchool objectForKey:@"school_List"] filteredArrayUsingPredicate:sPredicate ];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewSchoolList reloadData];
        });
        
    }
    else if (textField==self.textFieldCollege){
        
        NSString * searchStrCollege = [self.textFieldSchool.text stringByReplacingCharactersInRange:range withString:string];
        NSString * matchCollege = searchStrCollege;
        
        if (matchCollege.length==0) {
            autoCollegeArray=[jsonCollege objectForKey:@"type"];
            
        }
        
        else{
            
            self.tableViewCollegeList.hidden=NO;
            self.tableViewSchoolList.hidden=YES;
            NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                                       @"college_name BEGINSWITH[c] %@", matchCollege];
            autoCollegeArray = [[jsonCollege objectForKey:@"type"] filteredArrayUsingPredicate:sPredicate ];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewCollegeList reloadData];
        });
        
    }
    else{
        
    }
    return YES;
}



- (IBAction)pickerDoneButtonPressed:(id)sender {
    
    if (temp==2) {
        //weekend activity i.e Interest1
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterest1.text=typeInfoModel.full_name;
        codeInterest1=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        //self.viewHelpIn.hidden=NO;
        //self.viewHelpInAs.hidden=NO;
        // self.viewSpecialisation.hidden=NO;
        self.toolBar.hidden=YES;
        self.viewAge.hidden=NO;
     //   self.labelDisplayAge.hidden=YES;
        
    }
    else if (temp==6){
        //evening activity i.e Interest3
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterest3.text=typeInfoModel.full_name;
        codeInterest2=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.pickerView.hidden=YES;
       // self.buttonAdd.hidden=NO;
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.toolBar.hidden=YES;
        self.viewAge.hidden=NO;
           self.labelDisplayAge.hidden=NO;
   
        
    }
    else if (temp==7){
        //morning activity i.e Interest2
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterest2.text=typeInfoModel.full_name;
        codeInterest2=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.viewInterest3.hidden=NO;
        //  self.viewHelpIn.hidden=NO;
        //  self.viewHelpInAs.hidden=NO;
        self.viewAge.hidden=NO;
        self.toolBar.hidden=YES;
           self.labelDisplayAge.hidden=NO;
      //  self.labelDisplayAge.hidden=YES;
  
        
        
    }
    else if (temp==5){
        //occupation
        typeInfoModel=typeData.type[indexValue];
        self.textFieldOccupation.text=typeInfoModel.full_name;
        getOccupationId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        isOccupationSelected=1;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.textFieldWorkInterest.text=@"";
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        
        self.viewAge.hidden=NO;
        self.labelDisplayAge.hidden=NO;
        
        self.toolBar.hidden=YES;
    
        
    }
    else if (temp==10){
        //state list code
        typeInfoModel=typeData.type[indexValue];
        self.textFieldState.text=typeInfoModel.state;
        getStateId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isStateSelected=1;
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.labelDisplayAge.hidden=YES;
        isStateSelected=1;
        isClicked=0;
        self.textFieldCity.text=@"";
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        // self.viewHelpIn.hidden=NO;
        //self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewAge.hidden=NO;
        //    self.viewSpecialisation.hidden=NO;
        self.toolBar.hidden=YES;


        
    }
    else if (temp==15){
        //city list code
        typeInfoModel=typeData.type[indexValue];
        self.textFieldCity.text=typeInfoModel.city;
        getCityId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.labelDisplayAge.hidden=YES;
        self.viewInterest2.hidden=NO;
        // self.viewHelpIn.hidden=NO;
        // self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewAge.hidden=NO;
        //  self.viewSpecialisation.hidden=NO;
        self.toolBar.hidden=YES;

        
    }
    else if (temp==16){
        //work interest
        typeInfoModel=typeData.type[indexValue];
        self.textFieldWorkInterest.text=typeInfoModel.work_interest;
        getWorkInterestId=typeInfoModel.work_interest_id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.labelDisplayAge.hidden=YES;
        self.viewInterest3.hidden=NO;
        self.viewAge.hidden=NO;
        // self.viewHelpIn.hidden=NO;
        // self.viewHelpInAs.hidden=NO;
        // self.viewSpecialisation.hidden=NO;
        self.toolBar.hidden=YES;
  
        
    }
    else if (temp==18){
        if (indexValue==0) {
            getMinimumAge=@"0";
            getMaximumAge=@"9";
        }
        else if (indexValue==1){
            getMinimumAge=@"10";
            getMaximumAge=@"14";
        }
        else if (indexValue==2){
            getMinimumAge=@"15";
            getMaximumAge=@"18";
        }
        else if (indexValue==3){
            getMinimumAge=@"19";
            getMaximumAge=@"24";
        }
        else if (indexValue==4){
            getMinimumAge=@"25";
            getMaximumAge=@"35";
        }
        else if (indexValue==5){
            getMinimumAge=@"36";
            getMaximumAge=@"50";
        }
        else{
            getMinimumAge=@"50";
            getMaximumAge=@"100";
        }
        
        self.pickerView.hidden=YES;
        temp=27;
        self.textFieldAge.text=ageArray[indexValue];
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolBar.hidden=YES;
        
    }
}

#pragma mark  UISearchBar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    neighorKnowFilterArray = nil;
    
    if (searchText.length != 0) {
        
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"first_name CONTAINS[c] %@ OR last_name CONTAINS[c] %@",
                               searchText,searchText];
      
        NSArray *filteredArray = [[json1 objectForKey:@"profile"] filteredArrayUsingPredicate:filter];
    
        neighorKnowFilterArray=filteredArray;
    }
    else {
        
       neighorKnowFilterArray = globalSearchArray;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableViewNegKnowList reloadData];
    });
   
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textFieldSchool) {
       [theTextField resignFirstResponder];
    } else if (theTextField == self.textFieldCollege) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

//data pass back from present view controller portion
-(void)sendDataToA:(NSString *)indicatorValue
{
    gettedIndicator=indicatorValue;
    
}
@end
