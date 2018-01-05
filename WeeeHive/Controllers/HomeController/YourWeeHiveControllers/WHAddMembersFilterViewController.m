//
//  WHAddMembersFilterViewController.m
//  WeeeHive
//
//  Created by Schoofi on 23/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHAddMembersFilterViewController.h"
#import "Constant.h"
#import "JSONHTTPClient.h"
#import "ASNetworkAlertClass.h"
#import "SVProgressHUD.h"
#import "WHSingletonClass.h"
#import "WHStatesModel.h"
#import "WHStatesDetailsModel.h"
#import "WHTypeModel.h"
#import "WHTypeDetailsModel.h"
#import "WHSchoolListModel.h"
#import "WHSchoolListDetailsModel.h"
#import "WHCollegeListModel.h"
#import "WHCollegeListDetailsModel.h"
#import "WHGroupCollegeListTableViewCell.h"
#import "WHGroupSchoolListTableViewCell.h"
#import "WHMessageModel.h"
#import "WHTokenErrorModel.h"
#import "WHYourWeehiveViewController.h"

@interface WHAddMembersFilterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    WHStatesModel *stateListData;
    WHStatesDetailsModel *stateListInfoModel;
    WHSchoolListModel *schoolData;
    WHSchoolListDetailsModel *schoolInfoModel;
    WHTypeModel *typeData;
    WHTypeDetailsModel *typeInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    NSString *gettedFirstName;
    NSString *gettedLastName;
    NSString *gettedImage;
    NSString *gettedGroupName;
    
    
    NSUserDefaults *defaults;
    BOOL isClicked;
    int temp;
    BOOL isPressed;
    NSString *getMinimumAge;
    NSString *getMaximumAge;
    NSMutableArray *collegeArray;
    NSMutableArray *schoolArray;
    NSMutableArray *statesArray;
    NSMutableArray *typeArray;
    NSString *getOccupationId;
    NSString *codeInterest1;
    NSString *codeInterest2;
    NSString *codeInterest3;
    NSString *getStateId;
    NSString *getCityId;
    NSString *getWorkInterestId;
    NSString *getSchoolId;
    NSString *getCollegeId;
    BOOL isOccupationSelected;
    BOOL isStateSelected;
    NSString *gettedDeviceId;
    NSString *userId;
    NSString *token;
    NSArray *ageArray;
    NSArray *autoCollegeArray;
    NSArray *autoSchoolArray;
    NSInteger indexValue;
    NSDictionary *jsonSchool;
    NSDictionary *jsonCollege;
    NSString *gettedGroupId;
    
    IBOutlet UITableView *tableViewObjectSchool;
    IBOutlet UITableView *tableViewObjectCollege;
}
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UILabel *labelDisplayAge;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAge;
@property (strong, nonatomic) IBOutlet UIView *viewAge;
@property (strong, nonatomic) IBOutlet UIButton *buttonAge;
@property (strong, nonatomic) IBOutlet UIButton *buttonState;
@property (strong, nonatomic) IBOutlet UITextField *textFieldState;
@property (strong, nonatomic) IBOutlet UIView *viewState;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *viewCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) IBOutlet UIButton *dropDownCity;
@property (strong, nonatomic) IBOutlet UILabel *labelOrigin;
@property (strong, nonatomic) IBOutlet UILabel *labelSchoolCollege;
@property (strong, nonatomic) IBOutlet UIButton *dropDownCollege;
@property (strong, nonatomic) IBOutlet UIView *viewSchool;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSchool;
@property (strong, nonatomic) IBOutlet UIButton *dropDownSchool;
@property (strong, nonatomic) IBOutlet UIView *viewCollege;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCollege;
@property (strong, nonatomic) IBOutlet UILabel *labelInterest;
@property (strong, nonatomic) IBOutlet UIView *viewInterest1;
@property (strong, nonatomic) IBOutlet UITextField *textFieldInterest1;
@property (strong, nonatomic) IBOutlet UIButton *dropDownInterest1;
@property (strong, nonatomic) IBOutlet UITextField *textFieldInterest2;
@property (strong, nonatomic) IBOutlet UIButton *dropDownInterest2;
@property (strong, nonatomic) IBOutlet UIView *viewInterest2;
@property (strong, nonatomic) IBOutlet UIView *viewInterest3;
@property (strong, nonatomic) IBOutlet UITextField *textFieldInterest3;
@property (strong, nonatomic) IBOutlet UIButton *dropDownInterest3;
@property (strong, nonatomic) IBOutlet UILabel *labelWork;
@property (strong, nonatomic) IBOutlet UIView *viewOccupation;
@property (strong, nonatomic) IBOutlet UITextField *textFieldOccupation;
@property (strong, nonatomic) IBOutlet UIButton *dropDownOccupation;
@property (strong, nonatomic) IBOutlet UITextField *textFieldWorkInterest;
@property (strong, nonatomic) IBOutlet UIView *viewWorkInterest;
@property (strong, nonatomic) IBOutlet UIButton *dropDownWorkInterest;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSchool;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCollege;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;

@end

@implementation WHAddMembersFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    autoSchoolArray=[[NSArray alloc]init];
    autoCollegeArray=[[NSArray alloc]init];
        ageArray=[[NSArray alloc]initWithObjects:@"less than 10 years",@"10-14 years",@"15-18 years",@"19-24 years",@"25-35 years",@"36-50 years",@"above 50 years", nil];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    collegeArray=[NSMutableArray new];
    statesArray=[NSMutableArray new];
    schoolArray=[NSMutableArray new];
    typeArray=[NSMutableArray new];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    gettedGroupId=self.getGroupId;
    gettedGroupName=self.getGroupName;
    self.pickerView.hidden=YES;
    self.tableViewCollege.hidden=YES;
    self.tableViewSchool.hidden=YES;
    self.toolBar.hidden=YES;
    self.pickerView.hidden=YES;
    self.buttonAdd.hidden=NO;
    self.tableViewCollege.hidden=YES;
    self.tableViewSchool.hidden=YES;
    self.pickerView.hidden=YES;
   // self.viewHelpIn.hidden=NO;
   // self.viewHelpInAs.hidden=NO;
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
    self.labelInterest.hidden=NO;
    self.labelOrigin.hidden=NO;
    self.labelSchoolCollege.hidden=NO;
    self.labelWork.hidden=NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    isClicked=0;
    self.buttonAdd.hidden=NO;
    self.pickerView.hidden=YES;
    self.toolBar.hidden=NO;
    self.pickerView.hidden=YES;
    self.buttonAdd.hidden=NO;
    self.tableViewCollege.hidden=YES;
    self.tableViewSchool.hidden=YES;
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
    self.labelInterest.hidden=NO;
    self.labelOrigin.hidden=NO;
    self.labelSchoolCollege.hidden=NO;
    self.labelWork.hidden=NO;
}

- (void) getValues{
    
    userId=[[WHSingletonClass sharedManager]singletonUserId];
    token=[[WHSingletonClass sharedManager]singletonToken];
    gettedFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImage=[[WHSingletonClass sharedManager]singletonImage];
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Add Members";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textFieldWorkInterest.backgroundColor=[UIColor clearColor];
    self.textFieldWorkInterest.layer.borderColor=[UIColor clearColor].CGColor;
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
    self.dropDownCity.backgroundColor=[UIColor clearColor];
    self.dropDownCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownOccupation.backgroundColor=[UIColor clearColor];
    self.dropDownOccupation.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownCollege.backgroundColor=[UIColor clearColor];
    self.dropDownCollege.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownInterest1.backgroundColor=[UIColor clearColor];
    self.dropDownInterest1.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownInterest2.layer.cornerRadius=2.0f;
    self.dropDownInterest2.layer.masksToBounds=YES;
    self.dropDownInterest3.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownInterest3.backgroundColor=[UIColor clearColor];
    self.dropDownSchool.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownSchool.backgroundColor=[UIColor clearColor];
    self.buttonState.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonState.backgroundColor=[UIColor clearColor];
    self.dropDownWorkInterest.layer.borderColor=[UIColor clearColor].CGColor;
    self.dropDownWorkInterest.backgroundColor=[UIColor clearColor];
    self.tableViewCollege.layer.cornerRadius=2.0f;
    self.tableViewCollege.layer.masksToBounds=YES;
    self.tableViewCollege.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewCollege.layer.borderWidth=0.5f;
    self.tableViewSchool.layer.cornerRadius=2.0f;
    self.tableViewSchool.layer.masksToBounds=YES;
    self.tableViewSchool.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tableViewSchool.layer.borderWidth=0.5f;
    self.viewAge.backgroundColor=[UIColor clearColor];
    self.viewAge.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewAge.layer.borderWidth=0.5f;
    self.viewAge.layer.cornerRadius=2.0f;
    self.viewAge.layer.masksToBounds=YES;
    self.buttonAge.backgroundColor=[UIColor clearColor];
    self.buttonAge.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldAge.backgroundColor=[UIColor clearColor];
    self.textFieldAge.layer.borderColor=[UIColor clearColor].CGColor;
    self.labelInterest.text=@"Add members based on Interest";
    self.labelWork.text=@"Add members based on Work Interest";
    self.labelSchoolCollege.text=@"Add members based on School/College";
    self.labelOrigin.text=@"Add members based on Origin";
    self.labelDisplayAge.text=@"Add members based on Age";
}


- (void)animateSchoolTableView {
    
    [self.tableViewSchool reloadData];
    NSArray *cells = self.tableViewSchool.visibleCells;
    CGFloat height = self.tableViewSchool.bounds.size.height;
    
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
    
    [self.tableViewCollege reloadData];
    NSArray *cells = self.tableViewCollege.visibleCells;
    CGFloat height = self.tableViewCollege.bounds.size.height;
    
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


- (IBAction)buttonAddPressed:(id)sender {
    if (self.textFieldCity.text.length==0 && self.textFieldCollege.text.length==0 && self.textFieldInterest1.text.length==0 && self.textFieldInterest2.text.length==0 && self.textFieldInterest3.text.length==0 && self.textFieldOccupation.text.length==0 && self.textFieldSchool.text.length==0 && self.textFieldState.text.length==0 && self.textFieldWorkInterest.text.length==0 && self.textFieldAge.text.length==0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select atleast one of the fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
        [self serviceCallingForAddingMembersViaFilterMethod];
    }
}


#pragma mark  UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tableViewObjectSchool) {
        return autoSchoolArray.count;
    }
    else{
        return  autoCollegeArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==tableViewObjectSchool) {
        static NSString *cellIdentifier=@"schoolCustomCell";
        WHGroupSchoolListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.labelSchoolName.numberOfLines=0;
        cell.labelSchoolName.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelSchoolName.text=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_name"];
        
        
        return cell;
        
    }
    else{
        static NSString *cellIdentifier=@"collegeCustomCell";
        WHGroupCollegeListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.labelCollegeName.numberOfLines=0;
        cell.labelCollegeName.lineBreakMode=NSLineBreakByWordWrapping;
        cell.labelCollegeName.text=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_name"];
        
        
        return cell;
        
        
    }
    
}

#pragma mark  UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==tableViewObjectSchool) {
        
        getSchoolId=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_id"];
        self.tableViewCollege.hidden=YES;
        self.tableViewSchool.hidden=YES;
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.textFieldSchool.text=[[autoSchoolArray objectAtIndex:indexPath.row] valueForKey:@"school_name"];
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterest.hidden=NO;
        self.labelWork.hidden=NO;
        self.labelDisplayAge.hidden=NO;
    }
    else {
        
        getCollegeId=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_id"];
        self.tableViewCollege.hidden=YES;
        self.tableViewSchool.hidden=YES;
        isClicked=0;
        self.buttonAdd.hidden=NO;
        self.textFieldCollege.text=[[autoCollegeArray objectAtIndex:indexPath.row] valueForKey:@"college_name"];
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterest.hidden=NO;
        self.labelWork.hidden=NO;
        self.labelDisplayAge.hidden=NO;
    }
    
    
}


#pragma mark  UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (temp==18){
        
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

#pragma mark  DROPDOWN BUTTON ACTIONS

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
            self.buttonAdd.hidden=YES;
            
            
        }
        else if (isClicked==1){
            isClicked=0;
            self.pickerView.hidden=YES;
            self.buttonAdd.hidden=NO;
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
        self.buttonAdd.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
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
        self.buttonAdd.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
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
        self.buttonAdd.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
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
        self.buttonAdd.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
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
            self.buttonAdd.hidden=YES;
            
        }
        else if (isClicked==1){
            isClicked=0;
            self.pickerView.hidden=YES;
            self.buttonAdd.hidden=NO;
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
                             CGRect frame = self.tableViewSchool.frame;
                             frame.size.height = 116;
                             self.tableViewSchool.frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        self.tableViewSchool.hidden=NO;
        
        isClicked=1;
        self.tableViewSchool.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewSchool.layer.borderWidth=0.5f;
        self.tableViewSchool.layer.cornerRadius=2.0f;
        self.tableViewSchool.layer.masksToBounds=YES;
        self.viewCity.hidden=YES;
        self.viewInterest1.hidden=YES;
        self.viewInterest2.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.labelInterest.hidden=YES;
        self.labelWork.hidden=YES;
        self.labelDisplayAge.hidden=YES;
       
    }
    else if (isClicked == 1){
        
        [ UIView animateWithDuration:0.2f
                               delay:0.0
                             options: UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              CGRect frame = self.tableViewSchool.frame;
                              frame.size.height = 0;
                              self.tableViewSchool.frame = frame;
                          }
                          completion:^(BOOL finished){
                             
                          }];
        self.tableViewSchool.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewSchool.layer.borderWidth=0.5f;
        self.tableViewSchool.hidden=YES;
        isClicked=0;
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterest.hidden=NO;
        self.labelWork.hidden=NO;
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
                             CGRect frame = self.tableViewCollege.frame;
                             frame.size.height = 116;
                             self.tableViewCollege.frame = frame;
                         }
                         completion:^(BOOL finished){
                         
                         }];
        
        self.tableViewCollege.hidden=NO;
        self.tableViewSchool.hidden=YES;
        isClicked=1;
        self.tableViewCollege.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewCollege.layer.borderWidth=0.5f;
        self.tableViewCollege.layer.cornerRadius=2.0f;
        self.tableViewCollege.layer.masksToBounds=YES;
        self.viewCity.hidden=YES;
        self.viewInterest1.hidden=YES;
        self.viewInterest2.hidden=YES;
        self.viewInterest3.hidden=YES;
        self.viewOccupation.hidden=YES;
        self.viewWorkInterest.hidden=YES;
        self.labelInterest.hidden=YES;
        self.labelWork.hidden=YES;
        self.labelDisplayAge.hidden=YES;
        
    }
    else if (isClicked == 1){
        
        [ UIView animateWithDuration:0.2f
                               delay:0.0
                             options: UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              CGRect frame = self.tableViewCollege.frame;
                              frame.size.height = 0;
                              self.tableViewCollege.frame = frame;
                          }
                          completion:^(BOOL finished){
                              
                          }];
        self.tableViewCollege.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.tableViewCollege.layer.borderWidth=0.5f;
        self.tableViewCollege.hidden=YES;
        isClicked=0;
        self.viewCity.hidden=NO;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        self.viewOccupation.hidden=NO;
        self.viewWorkInterest.hidden=NO;
        self.labelInterest.hidden=NO;
        self.labelWork.hidden=NO;
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

//service calling for getting State
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

//service calling for adding memebers in group via filter method.
- (void) serviceCallingForAddingMembersViaFilterMethod{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"user_id=%@&token=%@&origin=%@&origin_city=%@&school=%@&college=%@&interest1=%@&interest2=%@&interest3=%@&work_interest=%@&occupation=%@&device_id=%@&min_age=%@&max_age=%@&group_id=%@&group_name=%@&first_name=%@&last_name=%@&image=%@",userId,token,getStateId,getCityId,getSchoolId,getCollegeId,codeInterest1,codeInterest2,codeInterest3,getWorkInterestId,getOccupationId,gettedDeviceId,getMinimumAge,getMaximumAge,gettedGroupId,gettedGroupName,gettedFirstName,gettedLastName,gettedImage];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDMEMBERSFILTER]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
            
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 //  profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
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
                     self.tableViewCollege.hidden=YES;
                     self.tableViewSchool.hidden=YES;
                     
                     self.labelInterest.hidden=YES;
                     self.labelWork.hidden=YES;
                     self.labelSchoolCollege.hidden=YES;
                     self.labelOrigin.hidden=YES;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     
                     self.textFieldCity.text=@"";
                     self.textFieldCollege.text=@"";
                     self.textFieldInterest1.text=@"";
                     self.textFieldInterest2.text=@"";
                     self.textFieldInterest3.text=@"";
                     self.textFieldOccupation.text=@"";
                     self.textFieldSchool.text=@"";
                     self.textFieldState.text=@"";
                     self.textFieldWorkInterest.text=@"";
                     self.labelInterest.hidden=NO;
                     self.labelWork.hidden=NO;
                     self.labelSchoolCollege.hidden=NO;
                     self.labelOrigin.hidden=NO;
                     
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No record found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Members added successfully!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                 }
                 else{
                     
                     
                     
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // [self animateTableView];
                     
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
        self.pickerView.showsSelectionIndicator=YES;
        self.toolBar.hidden=NO;
        self.buttonAdd.hidden=YES;
        
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
        self.toolBar.hidden=YES;
    }

}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
        
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([messageStatus.Msg isEqualToString:@"1"] || [messageStatus.Msg isEqualToString:@"0"]){
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[WHYourWeehiveViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }
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
        self.buttonAdd.hidden=YES;
        [self.pickerView reloadAllComponents];
        
    }
    else if (isClicked==1){
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
        self.toolBar.hidden=YES;
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.textFieldSchool) {
       
        temp=9;
        [self serviceCallingForSchoolList];
        self.tableViewSchool.hidden=NO;
        self.tableViewCollege.hidden=YES;
    }
    else if (textField==self.textFieldCollege){
      
        temp=8;
        [self serviceCallingForCollegeList];
        self.tableViewCollege.hidden=NO;
        self.tableViewSchool.hidden=YES;
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
            
            self.tableViewSchool.hidden=NO;
            self.tableViewCollege.hidden=YES;
            NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                                       @"school_name BEGINSWITH[c] %@", match];
            autoSchoolArray = [[jsonSchool objectForKey:@"school_List"] filteredArrayUsingPredicate:sPredicate ];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewSchool reloadData];
        });
        
    }
    else if (textField==self.textFieldCollege){
        
        NSString * searchStrCollege = [self.textFieldSchool.text stringByReplacingCharactersInRange:range withString:string];
        NSString * matchCollege = searchStrCollege;
        
        if (matchCollege.length==0) {
            autoCollegeArray=[jsonCollege objectForKey:@"type"];
            
        }
        
        else{
            
            self.tableViewCollege.hidden=NO;
            self.tableViewSchool.hidden=YES;
            NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                                       @"college_name BEGINSWITH[c] %@", matchCollege];
            autoCollegeArray = [[jsonCollege objectForKey:@"type"] filteredArrayUsingPredicate:sPredicate ];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableViewCollege reloadData];
        });
        
    }
    else{
        
    }
    return YES;
}


- (IBAction)pickerDoneButtonPressed:(UIBarButtonItem *)sender {
    if (temp==2) {
        //weekend activity i.e Interest1
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterest1.text=typeInfoModel.full_name;
        codeInterest1=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
        //self.viewHelpIn.hidden=NO;
        //self.viewHelpInAs.hidden=NO;
       // self.viewSpecialisation.hidden=NO;
        self.toolBar.hidden=YES;
        self.viewAge.hidden=NO;
        self.labelDisplayAge.hidden=NO;
    }
    else if (temp==6){
        //evening activity i.e Interest3
        typeInfoModel=typeData.type[indexValue];
        self.textFieldInterest3.text=typeInfoModel.full_name;
        codeInterest3=typeInfoModel.code;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
       // self.viewHelpIn.hidden=NO;
       // self.viewHelpInAs.hidden=NO;
       // self.viewSpecialisation.hidden=NO;
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
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.viewInterest3.hidden=NO;
      //  self.viewHelpIn.hidden=NO;
      //  self.viewHelpInAs.hidden=NO;
        self.viewAge.hidden=NO;
        self.toolBar.hidden=YES;
        self.labelDisplayAge.hidden=NO;
     
        
    }
    else if (temp==5){
        //occupation
        typeInfoModel=typeData.type[indexValue];
        self.textFieldOccupation.text=typeInfoModel.full_name;
        getOccupationId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        isOccupationSelected=1;
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.textFieldWorkInterest.text=@"";
        self.viewInterest1.hidden=NO;
        self.viewInterest2.hidden=NO;
        self.viewInterest3.hidden=NO;
      //  self.viewHelpIn.hidden=NO;
        self.viewAge.hidden=NO;
        self.labelDisplayAge.hidden=NO;
      //  self.viewHelpInAs.hidden=NO;
      //  self.viewSpecialisation.hidden=NO;
        self.toolBar.hidden=YES;
     
    }
    else if (temp==10){
        //state list code
        typeInfoModel=typeData.type[indexValue];
        self.textFieldState.text=typeInfoModel.state;
        getStateId=typeInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonAdd.hidden=NO;
        self.labelDisplayAge.hidden=NO;
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
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.viewInterest1.hidden=NO;
        self.labelDisplayAge.hidden=NO;
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
        self.buttonAdd.hidden=NO;
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
        //age code
        ageArray=[[NSArray alloc]initWithObjects:@"less than 10 years",@"10-14 years",@"15-18 years",@"19-24 years",@"25-35 years",@"36-50 years",@"above 50 years", nil];
        
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
        self.buttonAdd.hidden=NO;
        isClicked=0;
        self.toolBar.hidden=YES;
    }

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

@end
