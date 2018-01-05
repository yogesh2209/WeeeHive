//
//  WHUpdateAddressViewController.m
//  WeeeHive
//
//  Created by Schoofi on 24/04/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHUpdateAddressViewController.h"
#import "ASNetworkAlertClass.h"
#import "Constant.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "WHCityModel.h"
#import "WHCityDetailsModel.h"
#import "WHNeighboorDataModel.h"
#import "WHNeighborhoodDetailsModel.h"
#import "WHMessageModel.h"
#import "WHSingletonClass.h"
#import "WHProfileDetailsModel.h"
#import "WHProfileModel.h"
#import "WHHomeViewController.h"
#import "WHLoginCodeViewController.h"

@interface WHUpdateAddressViewController (){
    
    //JSON Model Objects
    WHProfileModel *profileData;
    WHProfileDetailsModel *profileInfoModel;
    WHMessageModel *messageStatus;
    WHCityModel *cityData;
    WHCityDetailsModel *cityInfoModel;
    WHNeighboorDataModel *neghData;
    WHNeighborhoodDetailsModel *neghInfoModel;
    WHSingletonClass *sharedObject;
    BOOL isCityClicked;
    BOOL isNeighbourhoodClicked;
    BOOL isClicked;
    int var;
    int temp;
    NSString *getCityId;
    NSString *getNegId;
    NSMutableArray *neighourhoodArray;
    NSMutableArray *cityArray;
    NSString *getUserId;
    NSString *gettedAddress;
    NSString *gettedPincode;
    NSInteger indexValue;
    NSString *gettedStatus;
    NSString *status;
    NSString *getRegistrationDate;
    NSUserDefaults *defaults;
    
    NSString *currentDateString;
}

@property (strong, nonatomic) IBOutlet UIView *viewCity;
@property (strong, nonatomic) IBOutlet UIView *viewNeighbourhood;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) IBOutlet UIButton *buttonDropDownCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNeighbourhood;
@property (strong, nonatomic) IBOutlet UIButton *buttonNeighbourhood;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPincode;
@property (strong, nonatomic) IBOutlet UIButton *buttonUpdate;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation WHUpdateAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseUI];
    getRegistrationDate=[[[WHSingletonClass sharedManager] singletonRegistrationDate] substringToIndex:10];
    defaults=[NSUserDefaults standardUserDefaults];
    neighourhoodArray=[NSMutableArray new];
    cityArray=[NSMutableArray new];
    sharedObject=[WHSingletonClass sharedManager];
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) customiseUI{
    
    self.textFieldAddress.backgroundColor=[UIColor clearColor];
    self.textFieldAddress.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textFieldAddress.layer.cornerRadius=2.0f;
    self.textFieldAddress.layer.masksToBounds=YES;
    self.textFieldAddress.layer.borderWidth=0.5f;
    self.textFieldPincode.backgroundColor=[UIColor clearColor];
    self.textFieldPincode.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textFieldPincode.layer.cornerRadius=2.0f;
    self.textFieldPincode.layer.masksToBounds=YES;
    self.textFieldPincode.layer.borderWidth=0.5f;
    self.textFieldCity.backgroundColor=[UIColor clearColor];
    self.textFieldCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldNeighbourhood.backgroundColor=[UIColor clearColor];
    self.textFieldNeighbourhood.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewCity.backgroundColor=[UIColor clearColor];
    self.viewCity.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCity.layer.borderWidth=0.5f;
    self.viewCity.layer.cornerRadius=2.0f;
    self.viewCity.layer.masksToBounds=YES;
    self.viewNeighbourhood.backgroundColor=[UIColor clearColor];
    self.viewNeighbourhood.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewNeighbourhood.layer.borderWidth=0.5f;
    self.viewNeighbourhood.layer.cornerRadius=2.0f;
    self.viewNeighbourhood.layer.masksToBounds=YES;
    self.buttonDropDownCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDropDownCity.backgroundColor=[UIColor clearColor];
    self.buttonNeighbourhood.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonNeighbourhood.backgroundColor=[UIColor clearColor];
    self.buttonUpdate.layer.cornerRadius=2.0f;
    self.buttonUpdate.layer.masksToBounds=YES;
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Update Address";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pickerView.hidden=YES;
    self.toolbar.hidden=YES;
    self.buttonUpdate.hidden=NO;
    [self getCurrentDate];
    self.navigationController.navigationBarHidden=NO;
    [self serviceCallingForGettingAddress];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.buttonUpdate.hidden=NO;
    self.pickerView.hidden=YES;
    self.toolbar.hidden=YES;
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textFieldAddress) {
        [self.textFieldCity becomeFirstResponder];
    }
    else if (theTextField == self.textFieldCity) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

//service calling for getting address entered by user.
- (void) serviceCallingForGettingAddress{
    
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Fetching Data" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@",getUserId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDRESS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 profileData=[[WHProfileModel alloc]initWithDictionary:json error:&err];
                 
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else{
                     for (WHProfileDetailsModel *each in profileData.profile) {
                         
                         if (![each.pincode isEqualToString:@""]) {
                             self.textFieldPincode.text=each.pincode;
                             gettedPincode=each.pincode;
                         }
                         
                         if (![each.address isEqualToString:@""]) {
                             self.textFieldAddress.text=each.address;
                             gettedAddress=each.address;
                         }
                         
                         if (![each.city isEqualToString:@""]) {
                             self.textFieldCity.text=each.city_N;
                             getCityId=each.city;
                             
                         }
                         
                         if (![each.neighborhood_id isEqualToString:@""]) {
                             self.textFieldNeighbourhood.text=each.neighborhood_name;
                             getNegId=each.neighborhood_id;
                         }
                         
                         
                     }
                     
                     
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


//service calling for getting city name list.
- (void) serviceCallingForCityNameList{
    
    [cityArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Fetching Data" maskType:SVProgressHUDMaskTypeBlack];
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_CITY]
                                           bodyString:nil
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 cityData=[[WHCityModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHCityDetailsModel *each in cityData.city) {
                     
                     [cityArray addObject:each.city];
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

//service calling for getting neighorhood name list.
- (void) serviceCallingForCityNeighborhoodList{
    
    [neighourhoodArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Fetching Data" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"city_id=%@",getCityId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_CITYNEGHBOUR]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 neghData=[[WHNeighboorDataModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHNeighborhoodDetailsModel *each in neghData.city_Neg) {
                     
                     [neighourhoodArray addObject:each.name];
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

//service calling for updating address.
- (void) serviceCallingForUpdateAddress{
    
    gettedAddress=self.textFieldAddress.text;
    gettedPincode=self.textFieldPincode.text;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Fetching Data" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"city=%@&neighbourhood_id=%@&address=%@&pincode=%@&u_id=%@",getCityId,getNegId,gettedAddress,gettedPincode,getUserId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_UPDATEADDRESS]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]) {
                     [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                     
                 }
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                 [defaults setObject:@"yes" forKey:@"ADD_ENTERED"];
                sharedObject.singletonIsAddressEntered=@"yes";
                     [self compareDates];
                    
                    
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

// method for calculating current date.
- (void) getCurrentDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    // convert it to a string
    NSString *dateString = [dateFormat stringFromDate:date];
    currentDateString=dateString;
    
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
        status=@"5";
         [self serviceCallingForUpdatingStatus];
        self.indicator=1;
        //send him to verification code screen, else send him to home screen/ previous screen.
         [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Address updated successfully!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else{
      status=@"2";
        self.indicator=2;
        [self serviceCallingForUpdatingStatus];
         [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Address updated successfully!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
}



//service calling for updatingStatus
- (void) serviceCallingForUpdatingStatus{
    
    
    [defaults setObject:status forKey:@"STATUS"];
    sharedObject.singletonStatus=status;
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        NSString *details = [NSString stringWithFormat:@"status=%@&user_id=%@",status,getUserId];
        
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

- (IBAction)buttonCityPressed:(id)sender {
    var=1;
    if (isClicked==0 ) {
        
        [self serviceCallingForCityNameList];
        
        isClicked=1;
        // default frame is set
        float pvHeight = self.pickerView.frame.size.height;
        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
        } completion:nil];
        self.pickerView.hidden=NO;
        
        self.buttonUpdate.hidden=YES;
        
        self.pickerView.showsSelectionIndicator=YES;
        
        [self.pickerView reloadAllComponents];
        self.toolbar.hidden=NO;
        self.viewCity.hidden=NO;
    }
    
    else if (isClicked==1){
        
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonUpdate.hidden=NO;
        self.toolbar.hidden=YES;
        
        
    }
    
    
}


- (IBAction)buttonNeighbourhoodPressed:(id)sender {
    
    var=2;
    
    if (temp==1) {
        
        if (isClicked==0 || isCityClicked==1) {
            
            [self serviceCallingForCityNeighborhoodList];
            
            // default frame is set
            float pvHeight = self.pickerView.frame.size.height;
            float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
            [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
            } completion:nil];
            self.pickerView.hidden=NO;
            self.buttonUpdate.hidden=YES;
            
            self.pickerView.showsSelectionIndicator=YES;
            self.toolbar.hidden=NO;
            [self.pickerView reloadAllComponents];
            
            //self.viewNeighborhood.hidden=YES;
        }
        else if (isClicked==1){
            isClicked=0;
            
            self.pickerView.hidden=YES;
            
            self.buttonUpdate.hidden=NO;
            
            self.toolbar.hidden=YES;
        }
        
        
    }
    else {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select city first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
    
}


- (IBAction)buttonUpdatePressed:(id)sender {
    
    if (self.textFieldCity.text.length!=0 && self.textFieldAddress.text.length!=0 && self.textFieldNeighbourhood.text.length!=0 && self.textFieldPincode.text.length!=0) {
        
        [self serviceCallingForUpdateAddress];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"All fields are mandatory, please fill all the fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    }
    
}
- (IBAction)toolbarDoneButtonPressed:(id)sender {
    
    if (var==1) {
        //city code
        
        temp=1;
        isClicked=0;
        
        cityInfoModel=cityData.city[indexValue];
        self.textFieldCity.text=cityInfoModel.city;
        getCityId=cityInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonUpdate.hidden=NO;
        
        self.textFieldNeighbourhood.text=@"";
        self.textFieldNeighbourhood.placeholder=@"Select Neighbourhood";
        isCityClicked=1;
        self.toolbar.hidden=YES;
    }
    else if (var==2){
        //neighbourhood code
        temp=1;
        isClicked=0;
        neghInfoModel=neghData.city_Neg[indexValue];
        self.textFieldNeighbourhood.text=neghInfoModel.name;
        getNegId=neghInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonUpdate.hidden=NO;
        isCityClicked=1;
        self.toolbar.hidden=YES;
    }
    
}

#pragma mark  UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (var==1) {
        
        return [cityArray count];
    }
    else {
        return [neighourhoodArray count];
    }
    
}

//title for each row.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (var==1) {
        indexValue=0;
        return [cityArray objectAtIndex:row];
    }
    else {
        indexValue=0;
        return [neighourhoodArray objectAtIndex:row];
    }
}

#pragma mark  UIPickerView Delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen
{
    
    indexValue=row;
}


#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.indicator==1) {
        
        [self performSegueWithIdentifier:@"updateAddressToCodeSegueVC" sender:nil];
    }
    else if (self.indicator==2){
        sharedObject.singletonIsLoggedIn=0;
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        sharedObject.singletonIsLoggedIn=0;
        NSString *string=@"0";
        [defaults setObject:string forKey:@"LOGGED"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        // [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"updateAddressToCodeSegueVC"]) {
        WHLoginCodeViewController *secondVC = segue.destinationViewController;
        secondVC.temp=1;
    }
    
   
}

@end
