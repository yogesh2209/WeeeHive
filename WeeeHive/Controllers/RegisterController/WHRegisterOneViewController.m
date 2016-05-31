//
//  RegisterOneViewController.m
//  WeeeHive
//
//  Created by Schoofi on 15/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHRegisterOneViewController.h"

//Alert Class
#import "ASNetworkAlertClass.h"

//Constant Class for URLs
#import "Constant.h"

#import <DigitsKit/DigitsKit.h>

//JSON Classes
#import "JSONHTTPClient.h"
#import "WHMessageModel.h"
#import "WHStatesModel.h"
#import "WHStatesDetailsModel.h"
#import "WHCityModel.h"
#import "WHCityDetailsModel.h"
#import "WHNeighboorDataModel.h"
#import "WHNeighborhoodDetailsModel.h"
#import "WHLocalityDataModel.h"
#import "WHLocalityDetailsModel.h"
#import "WHGenderListModel.h"
#import "WHGenderListDetailsModel.h"
#import "WHSingletonClass.h"
#import "WHLoginModel.h"
#import "WHLoginDetailsModel.h"
#import "WHMessageModel.h"

//Other ViewControllers
#import "WHLoginCodeViewController.h"

//Progress View
#import "SVProgressHUD.h"

@interface WHRegisterOneViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    //JSON Model Objects
    WHMessageModel *messageStatus;
    WHCityModel *cityData;
    WHCityDetailsModel *cityInfoModel;
    WHNeighboorDataModel *neghData;
    WHNeighborhoodDetailsModel *neghInfoModel;
    WHLocalityDataModel *localityData;
    WHLocalityDetailsModel *localityInfoModel;
    WHGenderListModel *genderData;
    WHGenderListDetailsModel *genderInfoModel;
    WHSingletonClass *sharedObject;
    WHLoginModel *loginData;
    WHLoginDetailsModel *loginInfoModel;
    
    
    NSMutableArray *localityArray;
    NSMutableArray *neghourhoodArray;
    NSMutableArray *cityArray;
    NSMutableArray *genderArray;
    NSString *getFirstName;
    NSString *getLastName;
    NSString *getPassword;
    NSString *getConfirmPassword;
    NSString *getEmail;
    NSString *getAddress;
    NSString *getLocality;
    NSString *getCity;
    NSString *getPinCode;
    NSString *getCityId;
    NSString *getNeghId;
    NSString *getLocalityId;
    NSString *getMobile;
    NSString *getGender;
    NSString *currentDateString;
    NSInteger indexValue;
    
    NSString *addressEntered;
    BOOL isCitySelected;
    int cityPressed;
    int neghPressed;
    int locPressed;
    BOOL iscaptchaEntered;
    
    BOOL isFlag;
    int temp;
    int isClicked;
    int variable;
    int var;
    int tempVar;
    int count;
    int indicator;
    
    //captcha code
    NSArray *arrayCaptcha;
    NSString *Captcha_string;
    NSUInteger i1,i2,i3,i4,i5;
  
    
}
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) IBOutlet UIView *viewCaptchaCode;
@property (strong, nonatomic) IBOutlet UIButton *buttonRefreshCaptchaCode;
@property (strong, nonatomic) IBOutlet UILabel *labelCaptchaCode;
@property (strong, nonatomic) IBOutlet UIView *viewEnterCode;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCaptchaCode;
@property (strong, nonatomic) IBOutlet UIButton *buttonSubmitCaptchaCode;
@property (strong, nonatomic) IBOutlet UILabel *labelCaptchaStatus;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoinNow;
@property (weak, nonatomic) IBOutlet UIView *viewTermsPolicy;
@property (weak, nonatomic) IBOutlet UIView *viewCheckBox;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPinCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonTermsUse;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UIView *viewFirstName;
@property (weak, nonatomic) IBOutlet UIView *viewLastName;
@property (weak, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmPassword;
@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UIView *viewMobile;
@property (weak, nonatomic) IBOutlet UIView *viewNeighborhood;
@property (weak, nonatomic) IBOutlet UIView *viewCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNeighborhood;
@property (weak, nonatomic) IBOutlet UIButton *buttonDropDownNeighborhood;
@property (weak, nonatomic) IBOutlet UIButton *buttonDropDownCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMobile;
@property (weak, nonatomic) IBOutlet UIView *viewPincode;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCountryCode;
@property (strong, nonatomic) IBOutlet UIView *viewCountryCode;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCountryCode;

@end

@implementation WHRegisterOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseUI];
     arrayCaptcha = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    isClicked=0;
    sharedObject=[WHSingletonClass sharedManager];
    cityArray =[NSMutableArray new];
    localityArray=[NSMutableArray new];
    neghourhoodArray =[NSMutableArray new];
    genderArray =[NSMutableArray new];
    self.pickerView.hidden=YES;
    [self.buttonTermsUse setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    [self buildAgreeTextViewFromString:NSLocalizedString(@"I accept the #<ts>Terms of Use# and #<pp>Privacy Policy#",)];
    [self customiseUI];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //arrayCaptcha = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    self.pickerView.hidden=YES;
    self.labelCaptchaStatus.hidden=YES;
    self.viewCaptchaCode.hidden=NO;
    self.toolBar.hidden=YES;
   // [self reloadCaptcha];
    self.navigationController.navigationBarHidden=NO;
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.buttonJoinNow.hidden=NO;
    self.viewCheckBox.hidden=NO;
    self.viewTermsPolicy.hidden=NO;
    self.pickerView.hidden=YES;
    self.viewCaptchaCode.hidden=NO;
    self.toolBar.hidden=YES;
}

#pragma mark  UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textFieldFirstName) {
        [self.TextFieldLastName becomeFirstResponder];
    }
    else if (theTextField == self.TextFieldLastName) {
        [self.textFieldEmail becomeFirstResponder];
    }
    else if (theTextField == self.textFieldEmail){
        [self.textFieldPassword becomeFirstResponder];
    }
    else if (theTextField == self.textFieldPassword){
        [self.textFieldConfirmPassword becomeFirstResponder];
    }
    else if (theTextField == self.textFieldConfirmPassword){
        [theTextField resignFirstResponder];
    }
    else if (theTextField == self.textFieldAddress){
        [self.textFieldMobile becomeFirstResponder];
    }
    else if (theTextField == self.textFieldCity){
        [self.textFieldPinCode becomeFirstResponder];
    }
    else if (theTextField == self.textFieldPinCode){
        [self.textFieldMobile becomeFirstResponder];
    }
    else if (theTextField == self.textFieldMobile){
        [theTextField resignFirstResponder];
    }
    else if (theTextField == self.textFieldCaptchaCode){
        [self.textFieldCaptchaCode resignFirstResponder];
    }
    return YES;
}
-(void) customiseUI{
    
    self.textFieldFirstName.backgroundColor=[UIColor clearColor];
    self.textFieldFirstName.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldAddress.backgroundColor=[UIColor clearColor];
    self.textFieldAddress.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldCity.backgroundColor=[UIColor clearColor];
    self.textFieldCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldConfirmPassword.backgroundColor=[UIColor clearColor];
    self.textFieldConfirmPassword.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldEmail.backgroundColor=[UIColor clearColor];
    self.textFieldEmail.layer.borderColor=[UIColor clearColor].CGColor;
    self.TextFieldLastName.backgroundColor=[UIColor clearColor];
    self.TextFieldLastName.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldMobile.backgroundColor=[UIColor clearColor];
    self.textFieldMobile.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldNeighborhood.backgroundColor=[UIColor clearColor];
    self.textFieldNeighborhood.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldPassword.backgroundColor=[UIColor clearColor];
    self.textFieldPassword.layer.borderColor=[UIColor clearColor].CGColor;
    self.textFieldPinCode.backgroundColor=[UIColor clearColor];
    self.textFieldPinCode.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewFirstName.backgroundColor=[UIColor clearColor];
    self.viewFirstName.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewFirstName.layer.borderWidth=0.5f;
    self.viewFirstName.layer.cornerRadius=2.0f;
    self.viewFirstName.layer.masksToBounds=YES;
    self.viewAddress.backgroundColor=[UIColor clearColor];
    self.viewAddress.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewAddress.layer.borderWidth=0.5f;
    self.viewAddress.layer.cornerRadius=2.0f;
    self.viewAddress.layer.masksToBounds=YES;
    self.viewCity.backgroundColor=[UIColor clearColor];
    self.viewCity.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCity.layer.borderWidth=0.5f;
    self.viewCity.layer.cornerRadius=2.0f;
    self.viewCity.layer.masksToBounds=YES;
    self.viewConfirmPassword.backgroundColor=[UIColor clearColor];
    self.viewConfirmPassword.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewConfirmPassword.layer.borderWidth=0.5f;
    self.viewConfirmPassword.layer.cornerRadius=2.0f;
    self.viewConfirmPassword.layer.masksToBounds=YES;
    self.viewEmail.backgroundColor=[UIColor clearColor];
    self.viewEmail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewEmail.layer.borderWidth=0.5f;
    self.viewEmail.layer.cornerRadius=2.0f;
    self.viewEmail.layer.masksToBounds=YES;
    self.viewLastName.backgroundColor=[UIColor clearColor];
    self.viewLastName.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewLastName.layer.borderWidth=0.5f;
    self.viewLastName.layer.cornerRadius=2.0f;
    self.viewLastName.layer.masksToBounds=YES;
    self.viewMobile.backgroundColor=[UIColor clearColor];
    self.viewMobile.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewMobile.layer.borderWidth=0.5f;
    self.viewMobile.layer.cornerRadius=2.0f;
    self.viewMobile.layer.masksToBounds=YES;
    self.viewNeighborhood.backgroundColor=[UIColor clearColor];
    self.viewNeighborhood.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewNeighborhood.layer.borderWidth=0.5f;
    self.viewNeighborhood.layer.cornerRadius=2.0f;
    self.viewNeighborhood.layer.masksToBounds=YES;
    self.viewPassword.backgroundColor=[UIColor clearColor];
    self.viewPassword.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewPassword.layer.borderWidth=0.5f;
    self.viewPassword.layer.cornerRadius=2.0f;
    self.viewPassword.layer.masksToBounds=YES;
    self.viewPincode.backgroundColor=[UIColor clearColor];
    self.viewPincode.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewPincode.layer.borderWidth=0.5f;
    self.viewPincode.layer.cornerRadius=2.0f;
    self.viewPincode.layer.masksToBounds=YES;
    self.viewCheckBox.backgroundColor=[UIColor clearColor];
    self.viewTermsPolicy.backgroundColor=[UIColor clearColor];
    self.buttonDropDownCity.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDropDownCity.backgroundColor=[UIColor clearColor];
    self.buttonDropDownNeighborhood.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonDropDownNeighborhood.backgroundColor=[UIColor clearColor];
    self.buttonTermsUse.layer.borderColor=[UIColor clearColor].CGColor;
    self.buttonTermsUse.backgroundColor=[UIColor clearColor];
    self.buttonJoinNow.layer.cornerRadius=2.0f;
    self.buttonJoinNow.layer.masksToBounds=YES;
    self.viewCaptchaCode.backgroundColor=[UIColor clearColor];
    self.viewCaptchaCode.layer.cornerRadius=2.0f;
    self.viewCaptchaCode.layer.masksToBounds=YES;
    self.viewCaptchaCode.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewCaptchaCode.layer.borderWidth=0.5f;
    self.textFieldCaptchaCode.backgroundColor=[UIColor clearColor];
    self.textFieldCaptchaCode.layer.borderColor=[UIColor clearColor].CGColor;
    self.viewEnterCode.backgroundColor=[UIColor clearColor];
    self.viewEnterCode.layer.cornerRadius=2.0f;
    self.viewEnterCode.layer.masksToBounds=YES;
    self.viewEnterCode.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.viewEnterCode.layer.borderWidth=0.5f;
    self.buttonRefreshCaptchaCode.backgroundColor=[UIColor clearColor];
    self.buttonSubmitCaptchaCode.layer.cornerRadius=2.0f;
    self.buttonSubmitCaptchaCode.layer.masksToBounds=YES;
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Register";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

- (void) getValues{
    
    getFirstName=self.textFieldFirstName.text;
    getLastName=self.TextFieldLastName.text;
    getEmail=self.textFieldEmail.text;
    getPassword=self.textFieldPassword.text;
    getConfirmPassword=self.textFieldConfirmPassword.text;
    getAddress=self.textFieldAddress.text;
    getCity=self.textFieldCity.text;
    getPinCode=self.textFieldPinCode.text;
    getMobile=self.textFieldMobile.text;
    
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

- (void)buildAgreeTextViewFromString:(NSString *)localizedString
{
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink)
        {
            label.textColor = [UIColor blueColor];
            //   label.textColor = [UIColor colorWithRed:110/255.0f green:181/255.0f blue:229/255.0f alpha:1.0];
            label.highlightedTextColor = [UIColor blackColor];
            
            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];
            
            // Trim the markup characters from the label:
            if (isTermsOfServiceLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            if (isPrivacyPolicyLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
        }
        else
        {
            label.textColor = [UIColor blackColor];
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (self.viewTermsPolicy.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);
        // Show this label:
        [self.viewTermsPolicy addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
}


//- (void)buildAgreeTextViewFromString:(NSString *)localizedString
//{
//    // 1. Split the localized string on the # sign:
//    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
//    
//    // 2. Loop through all the pieces:
//    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
//    
//    CGPoint wordLocation = CGPointMake(0.0, 0.0);
//    for (NSUInteger i = 0; i < msgChunkCount; i++)
//    {
//        NSString *chunk = [localizedStringPieces objectAtIndex:i];
//        if ([chunk isEqualToString:@""])
//        {
//            continue;     // skip this loop if the chunk is empty
//        }
//        
//        // 3. Determine what type of word this is:
//        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
//        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
//        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
//        
//        // 4. Create label, styling dependent on whether it's a link:
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:13.0f];
//        label.text = chunk;
//        label.userInteractionEnabled = isLink;
//        
//        if (isLink)
//        {
//            label.textColor = [UIColor colorWithRed:238.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1];
//            label.highlightedTextColor = [UIColor whiteColor];
//            
//            // 5. Set tap gesture for this clickable text:
//            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                         action:selectorAction];
//            [label addGestureRecognizer:tapGesture];
//            
//            // Trim the markup characters from the label:
//            if (isTermsOfServiceLink)
//                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
//            if (isPrivacyPolicyLink)
//                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
//        }
//        else
//        {
//            label.textColor = [UIColor blackColor];
//        }
//        
//        [label sizeToFit];
//        
//        if (self.viewTermsPolicy.frame.size.width < wordLocation.x + label.bounds.size.width)
//        {
//            wordLocation.x = 0.0;                       // move this word all the way to the left...
//            wordLocation.y += label.frame.size.height;  // ...on the next line
//            
//            // And trim of any leading white space:
//            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
//                                                                options:NSRegularExpressionSearch];
//            if (startingWhiteSpaceRange.location == 0)
//            {
//                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
//                                                                 withString:@""];
//                [label sizeToFit];
//                
//            }
//        }
//        // Set the location for this label:
//        label.frame = CGRectMake(wordLocation.x,
//                                 wordLocation.y,
//                                 label.frame.size.width,
//                                 label.frame.size.height);
//        // Show this label:
//        [self.viewTermsPolicy addSubview:label];
//        
//        // Update the horizontal position for the next word:
//        wordLocation.x += label.frame.size.width;
//    }
//}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
       [self performSegueWithIdentifier:@"termsRegSegueVC" sender:nil];
    }
}

//- (IBAction)authButtonPressed:(DGTAuthenticateButton *)sender {
//    
//    
//    self.authButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
//        if (session.userID) {
//            
//            // TODO: associate the session userID with your user model
//            NSString *msg = [NSString stringWithFormat:@"Phone number: %@", session.phoneNumber];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are logged in!"
//                                                            message:msg
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        } else if (error) {
//            NSLog(@"Authentication error: %@", error.localizedDescription);
//        }
//    }];
//    self.authButton.center = self.view.center;
//    [self.view addSubview:self.authButton];
//    
//    //    Digits *digits = [Digits sharedInstance];
//    //    DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
//    //    configuration.phoneNumber = @"+34";
//    //    [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *newSession, NSError *error){
//    //        // Country selector will be set to Spain
//    //    }];
//}

- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        [self performSegueWithIdentifier:@"privacyPolicyRegSegueVC" sender:nil];
    }
}

- (IBAction)buttonJoinNowPressed:(id)sender {
    
    
    if (isFlag==0) {
        
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please agree to terms and conditions first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
    else{
        
        if (self.textFieldFirstName.text.length!=0 && self.TextFieldLastName.text.length!=0 && self.textFieldEmail.text.length!=0 && self.textFieldPassword.text.length!=0 && self.textFieldConfirmPassword.text.length!=0 && self.textFieldMobile.text.length!=0 && self.textFieldCity.text.length!=0 && self.textFieldNeighborhood.text.length!=0) {
            
            if (self.textFieldPassword.text == self.textFieldConfirmPassword.text) {
                [self getCurrentDate];
                sharedObject.singletonRegistrationDate=currentDateString;
                
                if (self.textFieldPinCode.text.length!=0 && self.textFieldAddress.text.length!=0) {
                    
                    addressEntered=@"Yes";
                }
                else{
                    addressEntered=@"No";
                }
                
                [self getValues];
                
                sharedObject.singletonIsAddressEntered=addressEntered;
                
                Digits *digits = [Digits sharedInstance];
                DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
                configuration.appearance = [[DGTAppearance alloc] init];
                configuration.appearance.logoImage =[UIImage imageNamed:@""];
                configuration.appearance.accentColor = [UIColor colorWithRed:244.0/255.0 green:174.0/255.0 blue:0.0/255.0 alpha:1.0];
                NSString *countryCode=@"+91";
                configuration.phoneNumber = [NSString stringWithFormat:@"%@%@",countryCode,getMobile];
                [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *newSession, NSError *error){
                    
                    if (newSession.userID) {
                        indicator=1;
                        [self serviceCallingForRegistration];
                        // TODO: associate the session userID with your user model
                        //  NSString *msg = [NSString stringWithFormat:@"Happy Weehive: %@", newSession.phoneNumber];
                       
                    } else if (error) {
                        indicator=2;
                        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Authentication error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                        
                    }
                    
                }];
                
                
               // if (iscaptchaEntered==true) {
                
               // }
               // else{
                    //  [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Captcha entered is incorrect!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
               // }
                
                
                
            }
            
            else{
                self.textFieldPassword.text=@"";
                self.textFieldConfirmPassword.text=@"";
                [self.textFieldCity resignFirstResponder];
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Passwords do not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
        }
        else{
            
            [self.textFieldCity resignFirstResponder];
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill all the mandatory fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        
    }
    
    
}

- (IBAction)buttonTermsUsePressed:(id)sender {
    
    if (isFlag==0) {
        [self.buttonTermsUse setImage:[UIImage imageNamed:@"terms"] forState:UIControlStateNormal];
        isFlag=1;
    }
    else if (isFlag==1){
        isFlag=0;
        [self.buttonTermsUse setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
        
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
    
    [neghourhoodArray removeAllObjects];
    
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
                     
                     [neghourhoodArray addObject:each.name];
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

//service calling for getting locality name list.
- (void) serviceCallingForLocalityList{
    
    [localityArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Fetching Data" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"city_id=%@&neg_id=%@",getCityId,getNeghId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_LOCALITY]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
               //  NSLog(@"%@",json);
                 
                 localityData=[[WHLocalityDataModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHLocalityDetailsModel *each in localityData.city_Neg_loc) {
                     
                     [localityArray addObject:each.locality];
                 }
                 
                // NSLog(@"%@",localityArray);
                 
                 
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

//service calling for getting registration
- (void) serviceCallingForRegistration{
    
    
    //   [statesArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"f_Name=%@&l_Name=%@&email=%@&u_Pass=%@&address=%@&locality=%@&neg_id=%@&city=%@&pincode=%@&mob=%@&gender=%@&address_entered=%@",getFirstName,getLastName,getEmail,getPassword,getAddress,getLocalityId,getNeghId,getCityId,getPinCode, getMobile,getGender,addressEntered];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_REG]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([messageStatus.Msg isEqualToString:@"0"]) {
                     
                     [self.buttonTermsUse setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"2"]){
                      [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Email ID already exist!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 
                 else{
                     indicator=1;
                     loginData=[[WHLoginModel alloc]initWithDictionary:json error:&err];
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
                         sharedObject.singletonNeighbourhoodId=each.neighborhood_id;
                         sharedObject.singletonWeehiveName=each.weehives_name;
                         sharedObject.singletonInterestOne=each.interest1;
                         sharedObject.singletonInterestTwo=each.interest2;
                         sharedObject.singletonInterestThree=each.interest3;
                         sharedObject.singletonRegistrationDate=each.date;
                         
                         
                     }
                    
                     
                     
                     NSString *msg = @"";
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We have created your account temporarily for next 7 days. We will post you a verification code which will need to be entered to get permanent access."
                                                                     message:msg
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                     
                     
                  
                     
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


//service calling for getting Gender list.
- (void) serviceCallingForGenderList{
    
    [genderArray removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Fetching Data" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"city_id=%@&neg_id=%@",getCityId,getNeghId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_GENDER]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
             
                 genderData=[[WHGenderListModel alloc]initWithDictionary:json error:&err];
                 
                 for (WHGenderListDetailsModel *each in genderData.gender) {
                     
                     [genderArray addObject:each.full_name];
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
    else if (var==2){
        return [neghourhoodArray count];
    }
    
    else if (var==4){
        
        return [genderArray count];
    }
    
    else {
        return [localityArray count];
    }
}

//title for each row.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (var==1) {
        indexValue=0;
        return [cityArray objectAtIndex:row];
    }
    else if (var==2){
        indexValue=0;
        return [neghourhoodArray objectAtIndex:row];
    }
    else if (var==4){
        indexValue=0;
        return [genderArray objectAtIndex:row];
    }
    else {
        indexValue=0;
        return [localityArray objectAtIndex:row];
    }
}


#pragma mark  UIPickerView Delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen
{
   
        indexValue=row;
        //city
        
       
//    else if (var==3){
//        
//        //locality
//        isClicked=0;
//        localityInfoModel=localityData.city_Neg_loc[row];
//        
//        getLocalityId=localityInfoModel.id;
//        self.pickerView.hidden=YES;
//        self.buttonJoinNow.hidden=NO;
//        self.viewCheckBox.hidden=NO;
//        self.viewTermsPolicy.hidden=NO;
//        self.buttonTermsUse.hidden=NO;
//        self.viewCaptchaCode.hidden=NO;
//        cityPressed=1;
//        temp=1;
//        locPressed=1;
//        
//    }
//    else if (var==4){
//        indexValue=row;
//        isClicked=0;
//        genderInfoModel=genderData.gender[row];
//        getGender=genderInfoModel.code;
//        self.pickerView.hidden=YES;
//        self.buttonJoinNow.hidden=NO;
//        self.viewCheckBox.hidden=NO;
//        self.viewTermsPolicy.hidden=NO;
//        self.buttonTermsUse.hidden=NO;
//        self.viewCaptchaCode.hidden=NO;
//        cityPressed=1;
//        tempVar=2;
//    }
    
}
#pragma mark  UINavigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    WHLoginCodeViewController *secondVC = segue.destinationViewController;
//    secondVC.temp=variable;
//}
- (IBAction)buttonDropDownLocalityPressed:(id)sender {
    var=3;
    
    if (temp==2 || locPressed==1) {
        
        if (cityPressed==1){
            [self serviceCallingForLocalityList];
            
            if (isClicked==0) {
                // default frame is set
                float pvHeight = self.pickerView.frame.size.height;
                float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
                [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                    self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
                } completion:nil];
                self.pickerView.hidden=NO;
                self.buttonJoinNow.hidden=YES;
                self.viewTermsPolicy.hidden=YES;
                self.buttonTermsUse.hidden=YES;
                 self.viewCaptchaCode.hidden=YES;
                self.pickerView.showsSelectionIndicator=YES;
                UIToolbar *dateBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
                [dateBar1 setBarStyle:UIBarStyleBlack];
                [dateBar1 sizeToFit];
                UIBarButtonItem *spacer=[[UIBarButtonItem alloc]initWithTitle:@"Locality" style:UIBarButtonItemStylePlain target:nil action:nil];
                spacer.tintColor=[UIColor whiteColor];
                [dateBar1 setItems:[NSArray arrayWithObjects:spacer, nil]animated:NO];
                [self.pickerView addSubview:dateBar1];
                [self.pickerView reloadAllComponents];
            }
            else if (isClicked==1){
                isClicked=0;
                self.pickerView.hidden=YES;
                self.buttonTermsUse.hidden=NO;
                self.buttonJoinNow.hidden=NO;
                self.viewCheckBox.hidden=NO;
                self.viewTermsPolicy.hidden=NO;
                self.viewCaptchaCode.hidden=NO;
            }
            
            
        }
    }
    
    else {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select neighborhood first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
    
}

- (IBAction)buttonDropDownNeighborhoodPressed:(id)sender {
    var=2;
 
    if (temp==1) {
        
        if (isClicked==0 || isCitySelected==1 || cityPressed==1) {
            
            [self serviceCallingForCityNeighborhoodList];
            
            // default frame is set
            float pvHeight = self.pickerView.frame.size.height;
            float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
            [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
            } completion:nil];
            self.pickerView.hidden=NO;
            self.buttonJoinNow.hidden=YES;
            self.viewTermsPolicy.hidden=YES;
            self.buttonTermsUse.hidden=YES;
            self.viewCaptchaCode.hidden=YES;
            self.pickerView.showsSelectionIndicator=YES;
               self.toolBar.hidden=NO;
            [self.pickerView reloadAllComponents];
         
            //self.viewNeighborhood.hidden=YES;
        }
        else if (isClicked==1){
            isClicked=0;
            self.viewCaptchaCode.hidden=NO;
            self.pickerView.hidden=YES;
            self.buttonTermsUse.hidden=NO;
            self.buttonJoinNow.hidden=NO;
            self.viewCheckBox.hidden=NO;
            self.viewTermsPolicy.hidden=NO;
            self.toolBar.hidden=YES;
        }
        
        
    }
    else {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select city first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
}

- (IBAction)buttonDropDownCityPressed:(id)sender {
    
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
        self.viewCaptchaCode.hidden=YES;
        self.buttonJoinNow.hidden=YES;
        self.viewTermsPolicy.hidden=YES;
        self.buttonTermsUse.hidden=YES;
        self.pickerView.showsSelectionIndicator=YES;
       
        [self.pickerView reloadAllComponents];
        self.toolBar.hidden=NO;
        self.viewCity.hidden=NO;
    }
    
    else if (isClicked==1){
        
        isClicked=0;
        self.pickerView.hidden=YES;
        self.buttonTermsUse.hidden=NO;
        self.buttonJoinNow.hidden=NO;
        self.viewCheckBox.hidden=NO;
        self.viewTermsPolicy.hidden=NO;
        self.viewCaptchaCode.hidden=NO;
        self.toolBar.hidden=YES;
        
    
    }
    
}

//- (IBAction)buttonGender:(id)sender {
//    
//    var=4;
//    if (isClicked==0) {
//        
//        [self serviceCallingForGenderList];
//        
//        isClicked=1;
//        // default frame is set
//        float pvHeight = self.pickerView.frame.size.height;
//        float y = self.view.frame.size.height - (pvHeight); // the root view of view controller
//        [UIView animateWithDuration:0.5f delay:0.1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//            self.pickerView.frame = CGRectMake(0 , y, self.pickerView.frame.size.width, pvHeight);
//        } completion:nil];
//        self.pickerView.hidden=NO;
//        self.buttonJoinNow.hidden=YES;
//        self.viewTermsPolicy.hidden=YES;
//        self.buttonTermsUse.hidden=YES;
//         self.viewCaptchaCode.hidden=YES;
//        self.pickerView.showsSelectionIndicator=YES;
//        UIToolbar *dateBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//        [dateBar1 setBarStyle:UIBarStyleBlack];
//        [dateBar1 sizeToFit];
//        UIBarButtonItem *spacer=[[UIBarButtonItem alloc]initWithTitle:@"Gender" style:UIBarButtonItemStylePlain target:nil action:nil];
//        spacer.tintColor=[UIColor whiteColor];
//        [dateBar1 setItems:[NSArray arrayWithObjects:spacer, nil]animated:NO];
//        [self.pickerView addSubview:dateBar1];
//        [self.pickerView reloadAllComponents];
//    }
//    
//    else if (isClicked==1){
//        
//        isClicked=0;
//        self.pickerView.hidden=YES;
//        self.buttonTermsUse.hidden=NO;
//        self.buttonJoinNow.hidden=NO;
//        self.viewCheckBox.hidden=NO;
//        self.viewTermsPolicy.hidden=NO;
//        self.viewCaptchaCode.hidden=NO;
//    }
//}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (indicator==2) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
          [self performSegueWithIdentifier:@"registerToProfileSegueVC" sender:nil];
    }
}

- (IBAction)buttonSubmitCaptchaCodePressed:(id)sender {
    
  if([self.labelCaptchaCode.text isEqualToString: self.textFieldCaptchaCode.text]){
        [self.view endEditing:YES];
      self.labelCaptchaStatus.hidden=NO;
      self.buttonSubmitCaptchaCode.alpha=0.5f;
      self.buttonRefreshCaptchaCode.alpha=0.5f;
      self.textFieldCaptchaCode.alpha=0.5f;
      self.viewEnterCode.alpha=0.5f;
      self.textFieldCaptchaCode.userInteractionEnabled=false;
      self.buttonRefreshCaptchaCode.userInteractionEnabled=false;
      self.buttonSubmitCaptchaCode.userInteractionEnabled=false;
      self.labelCaptchaStatus.textColor=[UIColor colorWithRed:0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0];
      [self.buttonSubmitCaptchaCode setTitle:@"submitted" forState:UIControlStateNormal];
      self.labelCaptchaStatus.text=@"captcha code entered successfully!";
      iscaptchaEntered=true;
      
  }else{
        self.labelCaptchaStatus.hidden=NO;
        self.textFieldCaptchaCode.text=@"";
        iscaptchaEntered=false;
        self.labelCaptchaStatus.textColor=[UIColor redColor];
        self.textFieldCaptchaCode.userInteractionEnabled=true;
        self.buttonRefreshCaptchaCode.userInteractionEnabled=true;
        self.buttonSubmitCaptchaCode.userInteractionEnabled=true;
        self.labelCaptchaStatus.text=@"wrong captcha code entered!";
        
    }

}
//- (IBAction)buttonRefreshCaptchaCodePressed:(id)sender {
//    [self reloadCaptcha];
//}
//
//-(void)reloadCaptcha{
//    
//    self.labelCaptchaStatus.hidden=YES;
//    @try {
//        
//        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//        self.labelCaptchaCode.backgroundColor = color;
//        
//        i1 = arc4random() % [arrayCaptcha count];
//        
//      //  NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i1);
//        
//        i2= arc4random() % [arrayCaptcha count];
//        
//      //  NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i2);
//        i3 = arc4random() % [arrayCaptcha count];
//        
//      //  NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i3);
//        
//        i4 = arc4random() % [arrayCaptcha count];
//        
//        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i4);
//        
//        i5 = arc4random() % [arrayCaptcha count];
//        
//        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i5);
//        
//        Captcha_string = [NSString stringWithFormat:@"%@%@%@%@%@",[arrayCaptcha objectAtIndex:i1-1],[arrayCaptcha objectAtIndex:i2-1],[arrayCaptcha objectAtIndex:i3-1],[arrayCaptcha objectAtIndex:i4-1],[arrayCaptcha objectAtIndex:i5-1]];
//        
//        NSLog(@" Captcha String : %@",Captcha_string);
//        
//       self.labelCaptchaCode.text = Captcha_string;
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//    
//
//   
//}

- (IBAction)pickerDoneButtonPressed:(id)sender {
    
    if (var==1) {
        //city code
        
        temp=1;
        isClicked=0;
       // NSLog(@"%ld",(long)indexValue);
        cityInfoModel=cityData.city[indexValue];
        self.textFieldCity.text=cityInfoModel.city;
        getCityId=cityInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonJoinNow.hidden=NO;
        self.viewCheckBox.hidden=NO;
        self.viewTermsPolicy.hidden=NO;
        self.buttonTermsUse.hidden=NO;
        self.viewCaptchaCode.hidden=NO;
        self.textFieldNeighborhood.text=@"";
        self.textFieldNeighborhood.placeholder=@"neighbourhood";
        isCitySelected=1;
        cityPressed=1;
        self.toolBar.hidden=YES;
    }
    else if (var==2){
        //neighbourhood code
        temp=1;
        isClicked=0;
        neghInfoModel=neghData.city_Neg[indexValue];
        self.textFieldNeighborhood.text=neghInfoModel.name;
        getNeghId=neghInfoModel.id;
        self.pickerView.hidden=YES;
        self.buttonJoinNow.hidden=NO;
        self.viewCheckBox.hidden=NO;
        self.viewTermsPolicy.hidden=NO;
        self.buttonTermsUse.hidden=NO;
        self.viewCaptchaCode.hidden=NO;
        cityPressed=1;
        self.toolBar.hidden=YES;
    }
    
}


@end
