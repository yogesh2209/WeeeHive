//
//  WHProfileViewController.m
//  WeeeHive
//
//  Created by Schoofi on 17/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHProfileFillViewController.h"

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
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHTypeModel.h"
#import "WHTypeDetailsModel.h"
#import "WHSchoolListModel.h"
#import "WHSchoolListDetailsModel.h"
#import "WHCollegeListModel.h"
#import "WHCollegeListDetailsModel.h"
#import "WHLoginModel.h"
#import "WHLoginDetailsModel.h"
#import "WHLoginViewController.h"

//TableView Cells
#import "WHSchoolListTableViewCell.h"
#import "WHCollegeListTableViewCell.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"

//Singleton Class
#import "WHSingletonClass.h"

#import "WHHomeViewController.h"


#import <QuartzCore/QuartzCore.h>

//Framework
#import <AssetsLibrary/AssetsLibrary.h>

@interface WHProfileFillViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    //JSON Objects
    WHLoginModel *loginData;
    WHLoginDetailsModel *loginInfoModel;
    WHMessageModel *messageStatus;
    WHTokenErrorModel *tokenStatus;
    WHTypeModel *typeData;
    WHTypeDetailsModel *typeInfoModel;
    WHSingletonClass *sharedObject;
    
    WHSchoolListModel *schoolData;
    WHSchoolListDetailsModel *schoolInfoModel;
    
    
    NSUserDefaults *defaults;
    //NSArray *schoolTempArray;
    NSArray *school;
    int indicator;
    UIPickerView *picker;
    NSData *imageData;
    NSArray *genderArray;
    NSMutableArray *typeArray;
    NSMutableArray *schoolArray;
    NSMutableArray *collegeArray;
    NSMutableArray *ageYearArray;
    NSMutableArray *years;
    UIDatePicker *datePicker;
    UIDatePicker *datePicker1;
    NSString *getFirstName;
    NSString *getLastName;
    NSString *getLivingSince;
    NSString *getWeehiveName;
    NSString *getDob;
    NSString *getOccupation;
    NSString *getInterestOne;
    NSString *getInterestTwo;
    NSString *getInterestThree;
    NSString *getHelpIn;
    NSString *email;
    NSString *userId;
    NSString *token;
    NSString *city;
    NSString *pinCode;
    NSString *address;
    NSString *value;
    NSString *status;
    NSString *codeInterest1;
    NSString *codeInterest2;
    NSString *codeInterest3;
    NSString *codeOccupation;
    NSString *fileName;
    UIImage *getSelectedImage;
    NSString *getSchoolId;
    NSString *getCollegeId;
    NSString *getSpecialisation;
    NSString *getSchoolName;
    NSString *getCollegeName;
    NSString *getImageString;
    NSString *getGender;
    BOOL isFlag;
    int temp;
    BOOL isClicked;
    int count;
    int var;
    BOOL isPressed;
    NSInteger year;
    BOOL isOccupationSelected;
    BOOL isStateSelected;
    NSString *getStateId;
    NSString *getOccupationId;
    NSString *getCityId;
    NSString *getWorkInterestId;
    NSString *gethelpInAs;
    NSString *gettedDeviceId;
    NSArray *autoSchoolArray;
    NSArray *autoCollegeArray;
    NSInteger indexValue;
    NSString *getCitySingletonId;
    NSString *getNeighbourhoodId;
    NSDictionary *jsonSchool;
    NSDictionary *jsonCollege;
    int heightView;
    
    __weak IBOutlet UITableView *tableViewCollege;
    __weak IBOutlet UITableView *tableViewSchool;
}

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSchoolList;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCollegeList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCollege;
@property (weak, nonatomic) IBOutlet UIView *viewCollege;
@property (weak, nonatomic) IBOutlet UIButton *buttonCollege;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOrigin;
@property (weak, nonatomic) IBOutlet UIButton *buttonDropDownOrigin;
@property (weak, nonatomic) IBOutlet UIView *viewOrigin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSpecialisation;
@property (weak, nonatomic) IBOutlet UIView *viewSpecialisation;
@property (weak, nonatomic) IBOutlet UIView *viewSchool;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSchool;
@property (weak, nonatomic) IBOutlet UIButton *buttonSchool;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDisplayPic;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLivingSince;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWeehiveName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDOB;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOccupation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInterestOne;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInterestTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIButton *buttonOccupation;
@property (weak, nonatomic) IBOutlet UIButton *buttonInterestTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonHelpIn;
@property (weak, nonatomic) IBOutlet UIView *viewOccupation;
@property (weak, nonatomic) IBOutlet UIView *buttonInterestOne;
@property (weak, nonatomic) IBOutlet UIView *viewInterestOne;
@property (weak, nonatomic) IBOutlet UIView *viewInterestTwo;
@property (weak, nonatomic) IBOutlet UIView *viewDisplayData;
@property (weak, nonatomic) IBOutlet UIView *viewHelpIn;
@property (weak, nonatomic) IBOutlet UIView *viewFirstName;
@property (weak, nonatomic) IBOutlet UIView *viewDOB;
@property (weak, nonatomic) IBOutlet UIView *viewLastName;
@property (weak, nonatomic) IBOutlet UIView *viewLivingSince;
@property (weak, nonatomic) IBOutlet UIView *viewWeeHiveName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UIButton *buttonCity;
@property (weak, nonatomic) IBOutlet UIView *viewCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWorkInterest;
@property (weak, nonatomic) IBOutlet UIButton *buttonWorkInterest;
@property (weak, nonatomic) IBOutlet UIView *viewWorkInterest;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGender;
@property (weak, nonatomic) IBOutlet UIButton *buttonGender;
@property (weak, nonatomic) IBOutlet UIView *viewGender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHelpInAs;
@property (weak, nonatomic) IBOutlet UIView *viewHelpInAs;
@property (weak, nonatomic) IBOutlet UIButton *buttonHelpInAs;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInterest3;
@property (weak, nonatomic) IBOutlet UIButton *buttonInterest3;
@property (weak, nonatomic) IBOutlet UIView *viewInterest3;
@property (weak, nonatomic) IBOutlet UIButton *buttonLivingSince;
@property (weak, nonatomic) IBOutlet UIButton *buttonDob;

@end

@implementation WHProfileFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //   schoolTempArray=[[NSArray alloc]init];
    self.navigationItem.hidesBackButton = YES;
    ageYearArray=[NSMutableArray new];
    autoCollegeArray=[[NSArray alloc]init];
    autoSchoolArray=[[NSArray alloc]init];
    defaults=[NSUserDefaults standardUserDefaults];
    genderArray=[[NSArray alloc]initWithObjects:@"Male",@"Female", nil];
    typeArray=[NSMutableArray new];
    schoolArray=[NSMutableArray new];
    collegeArray=[NSMutableArray new];
    years=[NSMutableArray new];
    sharedObject=[WHSingletonClass sharedManager];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWasShown:)
    //                                                 name:UIKeyboardDidShowNotification
    //                                               object:nil];
    
    
    [self.buttonHelpIn setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    [self customiseUI];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    //  [self setPickerStartingDate];
    [self addImageTapGesture];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self allocation];
    self.tableViewCollegeList.hidden=YES;
    self.tableViewSchoolList.hidden=YES;
    self.pickerView.hidden=YES;
    self.viewHelpInAs.hidden=YES;
    self.viewSpecialisation.hidden=YES;
    //[typeArray removeAllObjects];
    temp=10;
    self.toolbar.hidden=YES;
    self.navigationController.navigationBarHidden=NO;
    getCitySingletonId=[[WHSingletonClass sharedManager] singletonCity];
    getNeighbourhoodId=[[WHSingletonClass sharedManager] singletonNeighbourhoodId];
    [self serviceCallingForGettingState];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    temp=10;
    isClicked=0;
    self.pickerView.hidden=YES;
    self.buttonDone.hidden=NO;
    self.tableViewCollegeList.hidden=YES;
    self.tableViewSchoolList.hidden=YES;
    self.pickerView.hidden=YES;
    self.viewHelpIn.hidden=NO;
    self.viewHelpInAs.hidden=NO;
    self.viewInterestOne.hidden=NO;
    self.viewInterest3.hidden=NO;
    self.viewCity.hidden=NO;
    self.viewCollege.hidden=NO;
    self.viewGender.hidden=NO;
    self.viewInterestTwo.hidden=NO;
    self.viewOccupation.hidden=NO;
    self.viewWorkInterest.hidden=NO;
    self.toolbar.hidden=YES;
}



-(void) customiseUI{
    
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Profile";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textFieldFirstName.backgroundColor=[UIColor clearColor];
    self.textFieldFirstName.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldLastName.backgroundColor=[UIColor clearColor];
    self.textFieldLastName.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldDOB.backgroundColor=[UIColor clearColor];
    self.textFieldDOB.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldLivingSince.backgroundColor=[UIColor clearColor];
    self.textFieldLivingSince.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldWeehiveName.backgroundColor=[UIColor clearColor];
    self.textFieldWeehiveName.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldOccupation.backgroundColor=[UIColor clearColor];
    self.textFieldOccupation.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldInterestOne.backgroundColor=[UIColor clearColor];
    self.textFieldInterestOne.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldInterestTwo.backgroundColor=[UIColor clearColor];
    self.textFieldInterestTwo.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldInterest3.backgroundColor=[UIColor clearColor];
    self.textFieldInterest3.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldCity.backgroundColor=[UIColor clearColor];
    self.textFieldCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldCollege.backgroundColor=[UIColor clearColor];
    self.textFieldCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldGender.backgroundColor=[UIColor clearColor];
    self.textFieldGender.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldHelpInAs.backgroundColor=[UIColor clearColor];
    self.textFieldHelpInAs.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldSchool.backgroundColor=[UIColor clearColor];
    self.textFieldSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldSpecialisation.backgroundColor=[UIColor clearColor];
    self.textFieldSpecialisation.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldHelpInAs.backgroundColor=[UIColor clearColor];
    self.textFieldHelpInAs.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldWorkInterest.backgroundColor=[UIColor clearColor];
    self.textFieldWorkInterest.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewFirstName.backgroundColor=[UIColor clearColor];
    self.viewFirstName.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewFirstName.layer.borderWidth=0.5f;
    self.viewFirstName.layer.cornerRadius=2.0f;
    self.viewFirstName.layer.masksToBounds=YES;
    self.viewLastName.backgroundColor=[UIColor clearColor];
    self.viewLastName.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewLastName.layer.borderWidth=0.5f;
    self.viewLastName.layer.cornerRadius=2.0f;
    self.viewLastName.layer.masksToBounds=YES;
    self.viewDOB.backgroundColor=[UIColor clearColor];
    self.viewDOB.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewDOB.layer.borderWidth=0.5f;
    self.viewDOB.layer.cornerRadius=2.0f;
    self.viewDOB.layer.masksToBounds=YES;
    self.viewLivingSince.backgroundColor=[UIColor clearColor];
    self.viewLivingSince.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewLivingSince.layer.borderWidth=0.5f;
    self.viewLivingSince.layer.cornerRadius=2.0f;
    self.viewLivingSince.layer.masksToBounds=YES;
    self.viewWeeHiveName.backgroundColor=[UIColor clearColor];
    self.viewWeeHiveName.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewWeeHiveName.layer.borderWidth=0.5f;
    self.viewWeeHiveName.layer.cornerRadius=2.0f;
    self.viewWeeHiveName.layer.masksToBounds=YES;
    self.viewDisplayData.backgroundColor=[UIColor clearColor];
    self.viewDisplayData.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewDisplayData.layer.borderWidth=0.5f;
    self.viewDisplayData.layer.cornerRadius=2.0f;
    self.viewDisplayData.layer.masksToBounds=YES;
    self.viewOccupation.backgroundColor=[UIColor clearColor];
    self.viewOccupation.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewOccupation.layer.borderWidth=0.5f;
    self.viewOccupation.layer.cornerRadius=2.0f;
    self.viewOccupation.layer.masksToBounds=YES;
    self.viewInterestOne.backgroundColor=[UIColor clearColor];
    self.viewInterestOne.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewInterestOne.layer.borderWidth=0.5f;
    self.viewInterestOne.layer.cornerRadius=2.0f;
    self.viewInterestOne.layer.masksToBounds=YES;
    self.viewInterestTwo.backgroundColor=[UIColor clearColor];
    self.viewInterestTwo.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewInterestTwo.layer.borderWidth=0.5f;
    self.viewInterestTwo.layer.cornerRadius=2.0f;
    self.viewInterestTwo.layer.masksToBounds=YES;
    self.viewHelpIn.backgroundColor=[UIColor clearColor];
    self.viewHelpIn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewHelpIn.layer.borderWidth=0.5f;
    self.viewHelpIn.layer.cornerRadius=2.0f;
    self.viewHelpIn.layer.masksToBounds=YES;
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
    self.viewGender.backgroundColor=[UIColor clearColor];
    self.viewGender.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewGender.layer.borderWidth=0.5f;
    self.viewGender.layer.cornerRadius=2.0f;
    self.viewGender.layer.masksToBounds=YES;
    self.viewHelpInAs.backgroundColor=[UIColor clearColor];
    self.viewHelpInAs.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewHelpInAs.layer.borderWidth=0.5f;
    self.viewHelpInAs.layer.cornerRadius=2.0f;
    self.viewHelpInAs.layer.masksToBounds=YES;
    self.viewInterest3.backgroundColor=[UIColor clearColor];
    self.viewInterest3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewInterest3.layer.borderWidth=0.5f;
    self.viewInterest3.layer.cornerRadius=2.0f;
    self.viewInterest3.layer.masksToBounds=YES;
    self.viewSpecialisation.backgroundColor=[UIColor clearColor];
    self.viewSpecialisation.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewSpecialisation.layer.borderWidth=0.5f;
    self.viewSpecialisation.layer.cornerRadius=2.0f;
    self.viewSpecialisation.layer.masksToBounds=YES;
    self.viewWorkInterest.backgroundColor=[UIColor clearColor];
    self.viewWorkInterest.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewWorkInterest.layer.borderWidth=0.5f;
    self.viewWorkInterest.layer.cornerRadius=2.0f;
    self.viewWorkInterest.layer.masksToBounds=YES;
    self.buttonOccupation.backgroundColor=[UIColor clearColor];
    self.buttonOccupation.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonInterestOne.backgroundColor=[UIColor clearColor];
    self.buttonInterestOne.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonInterestTwo.backgroundColor=[UIColor clearColor];
    self.buttonInterestTwo.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDone.layer.cornerRadius=2.0f;
    self.buttonDone.layer.masksToBounds=YES;
    self.buttonHelpIn.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonHelpIn.backgroundColor=[UIColor clearColor];
    self.textFieldCollege.backgroundColor=[UIColor clearColor];
    self.textFieldCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldSchool.backgroundColor=[UIColor clearColor];
    self.textFieldSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldSpecialisation.backgroundColor=[UIColor clearColor];
    self.textFieldSpecialisation.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldOrigin.backgroundColor=[UIColor clearColor];
    self.textFieldOrigin.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewSchool.backgroundColor=[UIColor clearColor];
    self.viewSchool.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewSchool.layer.borderWidth=0.5f;
    self.viewSchool.layer.cornerRadius=2.0f;
    self.viewSchool.layer.masksToBounds=YES;
    self.viewCollege.backgroundColor=[UIColor clearColor];
    self.viewCollege.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCollege.layer.borderWidth=0.5f;
    self.viewCollege.layer.cornerRadius=2.0f;
    self.viewCollege.layer.masksToBounds=YES;
    self.viewSpecialisation.backgroundColor=[UIColor clearColor];
    self.viewSpecialisation.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewSpecialisation.layer.borderWidth=0.5f;
    self.viewSpecialisation.layer.cornerRadius=2.0f;
    self.viewSpecialisation.layer.masksToBounds=YES;
    self.viewOrigin.backgroundColor=[UIColor clearColor];
    self.viewOrigin.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewOrigin.layer.borderWidth=0.5f;
    self.viewOrigin.layer.cornerRadius=2.0f;
    self.viewOrigin.layer.masksToBounds=YES;
    self.buttonCollege.backgroundColor=[UIColor clearColor];
    self.buttonCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSchool.backgroundColor=[UIColor clearColor];
    self.buttonSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDropDownOrigin.backgroundColor=[UIColor clearColor];
    self.buttonDropDownOrigin.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonCity.backgroundColor=[UIColor clearColor];
    self.buttonCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonCollege.backgroundColor=[UIColor clearColor];
    self.buttonCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonGender.backgroundColor=[UIColor clearColor];
    self.buttonGender.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonHelpInAs.backgroundColor=[UIColor clearColor];
    self.buttonHelpInAs.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonInterest3.backgroundColor=[UIColor clearColor];
    self.buttonInterest3.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonSchool.backgroundColor=[UIColor clearColor];
    self.buttonSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonWorkInterest.backgroundColor=[UIColor clearColor];
    self.buttonWorkInterest.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDob.backgroundColor=[UIColor clearColor];
    self.buttonDob.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonLivingSince.backgroundColor=[UIColor clearColor];
    self.buttonLivingSince.layer.borderColor=[UIColor clearColor].CGColor;
}

-(void)calculateAge{
    
    if (self.textFieldDOB.text.length==0) {
    }
    else{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSDate *startD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.textFieldDOB.text]];
        NSDate *endD = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
        year  = [components year];
        
    }
    
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

- (void) livingSincePicker{
    [years removeAllObjects];
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    
    //Create Years Array from 1950 to This year
    for (int i=1940; i<=i2; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.buttonDone.hidden=YES;
    [self.pickerView reloadAllComponents];
    
}

- (void) ageYearPicker{
    [ageYearArray removeAllObjects];
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    //Create Years Array from 1950 to This year
    for (int i=1940; i<=i2; i++) {
        [ageYearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    self.buttonDone.hidden=YES;
    [self.pickerView reloadAllComponents];
    
}

-(void)allocation{
    
    value=@"1";
    getHelpIn=@"No";
    token=[[WHSingletonClass sharedManager]singletonToken];
    city=[[WHSingletonClass sharedManager]singletonCity];
    pinCode=[[WHSingletonClass sharedManager]singletonPinCode];
    address=[[WHSingletonClass sharedManager]singletonAddress];
    userId=[[WHSingletonClass sharedManager]singletonUserId];
    email=[[WHSingletonClass sharedManager]singletonEmail];
    self.textFieldFirstName.text=[[WHSingletonClass sharedManager]singletonFirstName];
    self.textFieldLastName.text=[[WHSingletonClass sharedManager]singletonLastName];
}

-(void)getValues{
    
    getFirstName=self.textFieldFirstName.text;
    getLastName=self.textFieldLastName.text;
    getWeehiveName=self.textFieldWeehiveName.text;
    getDob=self.textFieldDOB.text;
    getLivingSince=self.textFieldLivingSince.text;
    sharedObject.singletonDob=getDob;
    sharedObject.singletonFirstName=getFirstName;
    sharedObject.singletonLastName=getLastName;
}
#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textFieldFirstName) {
        [self.textFieldLastName becomeFirstResponder];
    }
    else if (theTextField == self.textFieldLastName) {
        [self.textFieldDOB becomeFirstResponder];
    }
    else if (theTextField == self.textFieldLivingSince){
        [self.textFieldWeehiveName becomeFirstResponder];
    }
    else if (theTextField == self.textFieldWeehiveName){
        [self.textFieldOrigin becomeFirstResponder];
    }
    
    else if (theTextField == self.textFieldOccupation){
        [self.textFieldInterestOne becomeFirstResponder];
    }
    else if (theTextField == self.textFieldInterestOne){
        [self.textFieldInterestTwo becomeFirstResponder];
    }
    else if (theTextField == self.textFieldInterestTwo){
        [theTextField resignFirstResponder];
    }
    else if (theTextField == self.textFieldSchool) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.textFieldCollege) {
        [theTextField resignFirstResponder];
    }
    
    return YES;
}
-(void)serviceCallProfile{
    
    // Show Progress bar.
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    [self getValues];
    
    defaults = [NSUserDefaults standardUserDefaults];
    gettedDeviceId=[defaults objectForKey:@"TOKEN"];
    sharedObject.deviceId=gettedDeviceId;
    
    if (isFlag==0) {
        
        self.textFieldHelpInAs.text=@"";
        gethelpInAs=@"";
        self.textFieldSpecialisation.text=@"";
        getSpecialisation=@"";
    }
    else{
        
    }
    if (self.textFieldWeehiveName.text.length==0) {
        getWeehiveName=@"";
        
    }
    else{
        getWeehiveName=self.textFieldWeehiveName.text;
        
    }
    if (self.textFieldDOB.text.length==0) {
        getDob=@"";
    }
    else{
        getDob=self.textFieldDOB.text;
    }
    
    if (self.textFieldSpecialisation.text.length==0) {
        getSpecialisation=@"";
    }
    else{
        
        getSpecialisation=self.textFieldSpecialisation.text;
    }
    
    if (self.textFieldLivingSince.text.length==0) {
        getLivingSince=@"";
    }
    else{
        getLivingSince=self.textFieldLivingSince.text;
    }
    
    NSString *url=[NSString stringWithFormat:@"%@%@",MAIN_URL,POST_EDITPROFILE];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:getFirstName forKey:@"f_name"];
    [parameters setValue:getLastName forKey:@"l_name"];
    [parameters setValue:getLivingSince forKey:@"living_since"];
    [parameters setValue:getWeehiveName forKey:@"weehive_name"];
    [parameters setValue:getDob forKey:@"dob"];
    [parameters setValue:codeInterest1 forKey:@"int1"];
    [parameters setValue:codeInterest2 forKey:@"int2"];
    [parameters setValue:codeInterest3 forKey:@"int3"];
    [parameters setValue:getCityId forKey:@"city_id"];
    [parameters setValue:address forKey:@"address"];
    [parameters setValue:pinCode forKey:@"pincode"];
    [parameters setValue:value forKey:@"value"];
    [parameters setValue:getHelpIn forKey:@"help_in"];
    [parameters setValue:gethelpInAs forKey:@"help_in_as"];
    [parameters setValue:status forKey:@"status"];
    [parameters setValue:getSchoolId forKey:@"sch_id"];
    [parameters setValue:getCollegeId forKey:@"clg_id"];
    [parameters setValue:gettedDeviceId forKey:@"device_id"];
    [parameters setValue:getOccupationId forKey:@"occupation_id"];
    [parameters setValue:city forKey:@"city"];
    [parameters setValue:userId forKey:@"user_id"];
    [parameters setValue:email forKey:@"email"];
    [parameters setValue:getStateId forKey:@"state_id"];
    [parameters setValue:getSpecialisation forKey:@"speciality"];
    [parameters setValue:getWorkInterestId forKey:@"work_interest_id"];
    [parameters setValue:getGender forKey:@"gender"];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        imageData = UIImageJPEGRepresentation(getSelectedImage, 0.5);
        if (imageData) {
            
            
            NSString *initialTemp=@"IMG";
            NSInteger randomNumber = arc4random() % 16;
            NSString *finalTemp=@".JPG";
            
            fileName=[NSString stringWithFormat:@"%@%ld%@",initialTemp,(long)randomNumber,finalTemp]
            ;
            
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpg"];
        }
        else{
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:nil];
        
        
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        
        
        
        messageStatus=[[WHMessageModel alloc]initWithDictionary:jsonResponse error:nil];
        tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:jsonResponse error:nil];
        
        if (jsonResponse!=0) {
            
            if ([tokenStatus.error isEqualToString:@"0"]) {
                // Hide Progress bar.
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Session expired" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
            
            else if ([messageStatus.Msg isEqualToString:@"0"]) {
                // Hide Progress bar.
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
            else{
                
                loginData=[[WHLoginModel alloc]initWithDictionary:jsonResponse error:nil];
                for (WHLoginDetailsModel *each in loginData.user_Details) {
                    
                    sharedObject.singletonEmail=each.email;
                    sharedObject.singletonVrfCode=each.verification_code;
                    sharedObject.singletonStatus=each.status;
                    sharedObject.singletonFirstName=each.first_name;
                    sharedObject.singletonLastName=each.last_name;
                    sharedObject.singletonUserId=each.id;
                    sharedObject.singletonToken=each.token;
                    sharedObject.singletonLocality=each.locality;
                    sharedObject.singletonPinCode=each.pincode;
                    sharedObject.singletonState=each.state;
                    sharedObject.singletonCity=each.city;
                    sharedObject.singletonAddress=each.address;
                    sharedObject.singletonDob=each.dob;
                    sharedObject.singletonOccupation=each.occupation;
                    sharedObject.singletonImage=each.image;
                    sharedObject.singletonMobile=each.mobile;
                    sharedObject.singletonWeehiveName=each.weehives_name;
                    sharedObject.singletonInterestOne=each.interest1;
                    sharedObject.singletonInterestTwo=each.interest2;
                    sharedObject.singletonInterestThree=each.interest3;
                    sharedObject.singletonRegistrationDate=each.date;
                    sharedObject.singletonToken=each.token;
                }
                
                [self calculateAge];
                [self serviceCallingForGettingDefaultGroups];
                
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Successful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
        }
        else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Hide Progress bar.
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }];
    
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    else {
        
        [self performSegueWithIdentifier:@"profileToHomeSegueVC" sender:nil];
    }
}
//- (void) setPickerStartingDate{
//
//    datePicker = [[UIDatePicker alloc] init];
//    [datePicker setDatePickerMode:UIDatePickerModeDate];
//    [self.textFieldDOB setInputView:datePicker];
//    UIToolbar *dateBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    [dateBar1 setBarStyle:UIBarStyleBlack];
//    [dateBar1 sizeToFit];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
//    UIBarButtonItem *setButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showSelectedStartDate)];
//    setButton.tintColor=[UIColor whiteColor];
//    [dateBar1 setItems:[NSArray arrayWithObjects:spacer, setButton, nil]animated:NO];
//    [self.textFieldDOB setInputAccessoryView:dateBar1];
//    datePicker.maximumDate=[NSDate date];
//
//}
//-(void) showSelectedStartDate{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    self.textFieldDOB.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePicker.date]];
//    [self.textFieldDOB resignFirstResponder];
//}

- (void) setPickerStarting354Date{
    
    picker = [[UIPickerView alloc] init];
    
    [self.textFieldDOB setInputView:datePicker];
    UIToolbar *dateBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [dateBar1 setBarStyle:UIBarStyleBlack];
    [dateBar1 sizeToFit];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showSelectedStart354Date)];
    setButton.tintColor=[UIColor whiteColor];
    [dateBar1 setItems:[NSArray arrayWithObjects:spacer, setButton, nil]animated:NO];
    [self.textFieldDOB setInputAccessoryView:dateBar1];
    datePicker.maximumDate=[NSDate date];
    
}
-(void) showSelectedStart354Date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.textFieldDOB.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePicker.date]];
    [self.textFieldDOB resignFirstResponder];
}


- (IBAction)buttonDonePressed:(id)sender {
    status=@"2";
    
    if (isFlag==1) {
        
        if (self.textFieldHelpInAs.text.length==0) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Help-In-As cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else{
            
            if (self.textFieldWeehiveName.text.length==0) {
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Weehive name is mandatory" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
            else{
                [self serviceCallProfile];
            }
            
            
        }
    }
    else{
        if (self.textFieldWeehiveName.text.length==0) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Weehive name is mandatory" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else{
            [self serviceCallProfile];
        }
    }
}





- (IBAction)buttonHelpInPressed:(id)sender {
    
    if (isFlag==0) {
        
        isFlag=1;
        getHelpIn=@"Yes";
        // Update UI in main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewHelpInAs.hidden=NO;
            self.viewSpecialisation.hidden=NO;
            [self.buttonHelpIn setImage:[UIImage imageNamed:@"terms"] forState:UIControlStateNormal];
        });
    
    }
    else if (isFlag==1){
        isFlag=0;
        getHelpIn=@"No";
        
        // Update UI in main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewHelpInAs.hidden=YES;
            self.viewSpecialisation.hidden=YES;
            [self.buttonHelpIn setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
        });
        
        
    }
    
}

#pragma mark  UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (temp==12) {
        
        return [years count];
    }
    else if (temp==13){
        
        return [ageYearArray count];
    }
    
    else{
        
        return [typeArray count];
    }
}

//title for each row.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (temp==12) {
        indexValue=0;
        return [years objectAtIndex:row];
    }
    else if (temp==13){
        indexValue=0;
        return [ageYearArray objectAtIndex:row];
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

- (IBAction)pickerDoneButtonPressed:(UIBarButtonItem *)sender {
    
    if (temp==2) {
        //weekend activity i.e Interest1
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterestOne.text=typeInfoModel.full_name;
        codeInterest1=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
    }
    else if (temp==6){
        //evening activity i.e Interest3
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterest3.text=typeInfoModel.full_name;
        codeInterest3=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
        
    }
    else if (temp==7){
        //morning activity i.e Interest2
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterestTwo.text=typeInfoModel.full_name;
        codeInterest2=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.toolbar.hidden=YES;
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
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
    }
    else if (temp==10){
        //state list code
        typeInfoModel=typeData.type[indexValue];
        self.textFieldOrigin.text=typeInfoModel.state;
        getStateId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isStateSelected=1;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
    }
    else if (temp==15){
        //city list code
        typeInfoModel=typeData.type[indexValue];
        self.textFieldCity.text=typeInfoModel.city;
        getCityId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
    }
    else if (temp==16){
        //work interest
        typeInfoModel=typeData.type[indexValue];
        self.textFieldWorkInterest.text=typeInfoModel.work_interest;
        getWorkInterestId=typeInfoModel.work_interest_id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
    }
    else if (temp==12){
        //living since code
        getLivingSince=years[indexValue];
        self.pickerView.hidden=YES;
        temp=20;
        self.textFieldLivingSince.text=years[indexValue];
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
    }
    else if (temp==13){
        //Date of birth
        getDob=ageYearArray[indexValue];
        self.pickerView.hidden=YES;
        temp=21;
        self.textFieldDOB.text=ageYearArray[indexValue];
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
    }
    else if (temp==18){
        //gender code
        typeInfoModel=typeData.type[indexValue];
        // getGender=genderArray[row];
        self.pickerView.hidden=YES;
        temp=29;
        getGender=typeInfoModel.code;
        self.textFieldGender.text=typeInfoModel.full_name;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.toolbar.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
    }
    else if (temp==17){
        //code for help-in-as
        typeInfoModel=typeData.type[indexValue];
        gethelpInAs=typeInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        isClicked=0;
        self.textFieldHelpInAs.text=typeInfoModel.help_in_as;
        gethelpInAs=typeInfoModel.id;
        self.toolbar.hidden=YES;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.tableViewCollegeList.hidden=YES;
        self.tableViewSchoolList.hidden=YES;
        self.pickerView.hidden=YES;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewCity.hidden=NO;
        self.viewCollege.hidden=NO;
        self.viewGender.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.toolbar.hidden=YES;
        
    }
    
}

#pragma mark  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tableViewSchool) {
        
        return autoSchoolArray.count;
    }
    else {
        
        return autoCollegeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==tableViewSchool) {
        
        static NSString *cellIdentifier=@"schoolListCustomCell";
        WHSchoolListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.labelSchoolName.text=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_name"];
        
        return cell;
    }
    else {
        
        static NSString *cellIdentifier=@"collegeListCustomCell";
        WHCollegeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.labelCollegeName.text=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_name"];
        
        return cell;
    }
}
#pragma mark  UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==tableViewSchool) {
        
        getSchoolId=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_id"];
        self.tableViewSchoolList.hidden=YES;
        self.tableViewCollegeList.hidden=YES;
        isPressed=false;
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewCity.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.textFieldSchool.text=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_name"];
        
    }
    else{
        
        getCollegeId=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_id"];
        self.tableViewCollegeList.hidden=YES;
        self.tableViewSchoolList.hidden=YES;
        isPressed=false;
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.viewCity.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.textFieldCollege.text=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_name"];
        
    }
    
}

// Tap Gesture
- (void)addImageTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageGestureCalled:)];
    [self.imageViewDisplayPic addGestureRecognizer:tapGesture];
}

// UITapGestureRecognizer Selector
- (void)tapImageGestureCalled:(UITapGestureRecognizer *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Select the image you want to upload"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Camera"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              //    NSLog(@"You pressed button one");
                                                              
                                                              // Open the Camera if available.
                                                              if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                  //[self pickImageOfSourceType:UIImagePickerControllerSourceTypeCamera];
                                                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                      [self pickImageOfSourceType:UIImagePickerControllerSourceTypeCamera];
                                                                      
                                                                      
                                                                  }];
                                                              } else {
                                                                  [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Camera not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                                              }
                                                              
                                                              
                                                              
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Image Gallery"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               // NSLog(@"You pressed button two");
                                                               
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   [self pickImageOfSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                               }];
                                                               
                                                           }]; // 3
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              // NSLog(@"You pressed button two");
                                                          }];
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}

- (void)pickImageOfSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate                    = self;
    imagePickerController.sourceType               =  sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark  UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Dismiss presented view controller.
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        fileName = [representation filename];
        [self dismissViewControllerAnimated:YES completion:nil];
        self.imageViewDisplayPic.image = [info valueForKey:UIImagePickerControllerOriginalImage];
        getSelectedImage=self.imageViewDisplayPic.image;
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
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
        self.buttonDone.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        self.buttonDone.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        self.toolbar.hidden=NO;
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolbar.hidden=YES;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.toolbar.hidden=YES;
        self.viewSpecialisation.hidden=NO;
    }
    
}

//Weekend activity
- (IBAction)buttonInterestOnePressed:(id)sender {
    
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
        self.buttonDone.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        // self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewSpecialisation.hidden=YES;
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.toolbar.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewSpecialisation.hidden=NO;
    }
    
}


//Morning activity
- (IBAction)buttonInterestTwoPressed:(id)sender {
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
        
        self.buttonDone.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        self.viewSpecialisation.hidden=YES;
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.toolbar.hidden=YES;
        self.viewSpecialisation.hidden=NO;
    }
    
    
    
}

- (IBAction)buttonDropDownOriginPressed:(id)sender {
    
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
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        self.buttonDone.hidden=YES;
        self.buttonDone.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        self.viewSpecialisation.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolbar.hidden=YES;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
    }
    
    
}

- (IBAction)buttonSchoolPressed:(id)sender {
    temp=9;
    if (isPressed == false){
        
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
        self.buttonDone.hidden=YES;
        isPressed=true;
        self.tableViewSchoolList.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewSchoolList.layer.borderWidth=0.5f;
        self.tableViewSchoolList.layer.cornerRadius=2.0f;
        self.tableViewSchoolList.layer.masksToBounds=YES;
        self.viewCity.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        
    }
    else if (isPressed == true){
        
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
        self.buttonDone.hidden=NO;
        isPressed=false;
        self.viewCity.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        
    }
    else{
        
    }
    
}
- (IBAction)buttonCollegePressed:(id)sender {
    temp=8;
    if (isPressed == false){
        
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
        isPressed=true;
        self.buttonDone.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.tableViewCollegeList.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewCollegeList.layer.borderWidth=0.5f;
        self.tableViewCollegeList.layer.cornerRadius=2.0f;
        self.tableViewCollegeList.layer.masksToBounds=YES;
        self.viewCity.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.viewSpecialisation.hidden=YES;
    }
    else if (isPressed == true){
        
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
        self.buttonDone.hidden=NO;
        isPressed=false;
        self.viewCity.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        
    }
    else{
        
    }
}


//#pragma - mark TextField Delegate Methods
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    if(textField==self.textFieldLivingSince){
//
//        temp=12;
//        if (isClicked==0) {
//            isClicked=1;
//
//            [self livingSincePicker];
//            // default frame is set
//            float pvHeight = self.pickerView.frame.size.height;
//            float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
//            [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//                self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
//            } completion:nil];
//            self.pickerView.hidden=NO;
//            self.pickerView.showsSelectionIndicator=YES;
//            UIToolbar *dateBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//            [dateBar1 setBarStyle:UIBarStyleBlack];
//            [dateBar1 sizeToFit];
//            [self.pickerView addSubview:dateBar1];
//            [self.pickerView reloadAllComponents];
//
//
//        }
//        else if (isClicked==1){
//            isClicked=0;
//            self.pickerView.hidden=YES;
//            self.buttonDone.hidden=NO;
//        }
//    }
//    else if (textField==self.textFieldDOB){
//        temp=13;
//        if (isClicked==0) {
//            isClicked=1;
//
//            [self ageYearPicker];
//            // default frame is set
//            float pvHeight = self.pickerView.frame.size.height;
//            float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
//            [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//                self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
//            } completion:nil];
//            self.pickerView.hidden=NO;
//            self.pickerView.showsSelectionIndicator=YES;
//            UIToolbar *dateBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//            [dateBar1 setBarStyle:UIBarStyleBlack];
//            [dateBar1 sizeToFit];
//            self.buttonDone.hidden=YES;
//            [self.pickerView addSubview:dateBar1];
//            [self.pickerView reloadAllComponents];
//
//        }
//        else if (isClicked==1){
//            isClicked=0;
//            self.pickerView.hidden=YES;
//            self.buttonDone.hidden=NO;
//        }
//
//
//    }
//}
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
        self.toolbar.hidden=NO;
        self.buttonDone.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        
        self.viewSpecialisation.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.toolbar.hidden=YES;
        self.viewSpecialisation.hidden=NO;
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
            self.toolbar.hidden=NO;
            self.buttonDone.hidden=YES;
            self.buttonDone.hidden=YES;
            self.viewInterestOne.hidden=YES;
            self.viewInterestTwo.hidden=YES;
            self.viewInterest3.hidden=YES;
            self.viewHelpIn.hidden=YES;
            self.viewHelpInAs.hidden=YES;
            self.pickerView.showsSelectionIndicator=YES;
            self.toolbar.hidden=NO;
            self.viewSpecialisation.hidden=YES;
            
        }
        else if (isClicked==1){
            isClicked=0;
            self.pickerView.hidden=YES;
            self.buttonDone.hidden=NO;
            self.toolbar.hidden=YES;
            self.pickerView.hidden=YES;
            self.buttonDone.hidden=NO;
            self.viewInterestOne.hidden=NO;
            self.viewInterestTwo.hidden=NO;
            self.viewInterest3.hidden=NO;
            self.viewHelpIn.hidden=NO;
            self.viewHelpInAs.hidden=NO;
            self.viewSpecialisation.hidden=NO;
            self.toolbar.hidden=YES;
        }
    }
    
}
- (IBAction)buttonGenderPressed:(id)sender {
    temp=18;
    if (isClicked==0) {
        isClicked=1;
        [self serviceCallingForGettingGender];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        [self.pickerView reloadAllComponents];
        self.buttonDone.hidden=YES;
        self.buttonDone.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        
        
    }
    else{
        // [genderArray removeAllObjects];
        
        isClicked=0;
        self.buttonDone.hidden=NO;
        self.pickerView.hidden=YES;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
        
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
            self.toolbar.hidden=NO;
            self.buttonDone.hidden=YES;
            self.buttonDone.hidden=YES;
            self.viewInterestOne.hidden=YES;
            self.viewInterestTwo.hidden=YES;
            self.viewHelpIn.hidden=YES;
            self.viewHelpInAs.hidden=YES;
            self.viewInterest3.hidden=YES;
            self.viewOccupation.hidden=YES;
            self.viewWorkInterest.hidden=YES;
            self.viewSpecialisation.hidden=YES;
            self.pickerView.showsSelectionIndicator=YES;
            self.toolbar.hidden=NO;
            
            
        }
        else if (isClicked==1){
            isClicked=0;
            self.pickerView.hidden=YES;
            self.buttonDone.hidden=NO;
            self.toolbar.hidden=YES;
            self.pickerView.hidden=YES;
            self.buttonDone.hidden=NO;
            self.viewInterestOne.hidden=NO;
            self.viewInterestTwo.hidden=NO;
            self.viewHelpIn.hidden=NO;
            self.viewHelpInAs.hidden=NO;
            self.viewInterest3.hidden=NO;
            self.viewOccupation.hidden=NO;
            self.viewWorkInterest.hidden=NO;
            self.viewSpecialisation.hidden=NO;
            self.toolbar.hidden=YES;
            
        }
    }
    
}


- (IBAction)buttonDobPressed:(id)sender {
    
    temp=13;
    if (isClicked==0) {
        isClicked=1;
        
        [self ageYearPicker];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        [self.pickerView reloadAllComponents];
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        self.buttonDone.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolbar.hidden=YES;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
    }
    
}

- (IBAction)buttonLivingSincePressed:(id)sender {
    
    temp=12;
    if (isClicked==0) {
        
        isClicked=1;
        [self livingSincePicker];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        self.buttonDone.hidden=YES;
        // self.buttonUpdate.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        
    }
    else {
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolbar.hidden=YES;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
    }
    
}


- (IBAction)buttonHelpInAsPressed:(id)sender {
    
    temp=17;
    if (isClicked==0) {
        
        isClicked=1;
        [self serviceCallingForGettingHelpInAs];
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
        // [self.pickerView reloadAllComponents];
        self.buttonDone.hidden=YES;
        self.buttonDone.hidden=YES;
        self.viewCity.hidden=YES;
        self.viewHelpIn.hidden=YES;
        self.viewHelpInAs.hidden=YES;
        self.viewInterestOne.hidden=YES;
        self.viewInterestTwo.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        self.viewSpecialisation.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
        self.toolbar.hidden=NO;
    }
    else {
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.toolbar.hidden=YES;
        self.pickerView.hidden=YES;
        self.buttonDone.hidden=NO;
        self.viewCity.hidden=NO;
        self.viewHelpIn.hidden=NO;
        self.viewHelpInAs.hidden=NO;
        self.viewInterestOne.hidden=NO;
        self.viewInterestTwo.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.viewSpecialisation.hidden=NO;
        self.toolbar.hidden=YES;
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
                 
                 autoSchoolArray=[schoolArray mutableCopy];
                 
                 
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
                 
                 autoCollegeArray=[collegeArray mutableCopy];
                 
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

//service calling for getting help in as
- (void) serviceCallingForGettingHelpInAs{
    
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
                     
                     [typeArray addObject:each.help_in_as];
                     
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

//service calling for sending user id so as to make this user as member of default groups assosciated with him.
- (void) serviceCallingForGettingDefaultGroups{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&age=%ld&city_id=%@&neg_id=%@",userId,(long)year,getCitySingletonId,getNeighbourhoodId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDGROUPDEFAULT]
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

- (IBAction)barButtonLogoutPressed:(id)sender {
    
    sharedObject.singletonIsLoggedIn=0;
    NSString *string=@"0";
    [defaults setObject:string forKey:@"LOGGED"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
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

//service calling for getting Gneder
- (void) serviceCallingForGettingGender{
    
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

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    return YES;
//}
//
//
////- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
////
////    [self.view endEditing:YES];
////    return YES;
////}
//
//
//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    
//    // Code to animate view down.
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        // Assign new frame to your view
//        [self.viewSpecialisation setFrame:CGRectMake(30 + self.viewHelpInAs.frame.size.width,self.view.frame.size.height-49-heightView,self.viewSpecialisation.frame.size.width,30)];
//    }];
//}
//
//
//- (void)keyboardWasShown:(NSNotification *)notification
//{
//    // Get the size of the keyboard.
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    //Given size may not account for screen rotation
//    heightView = MIN(keyboardSize.height,keyboardSize.width);
//    
//}

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"profileToHomeSegueVC"]) {
        WHHomeViewController *secondVC = segue.destinationViewController;
        secondVC.value=1;
    }
    
}




@end
