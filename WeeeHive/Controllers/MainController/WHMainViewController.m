//
//  ViewController.m
//  WeeeHive
//
//  Created by Schoofi on 15/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHMainViewController.h"

#import <DigitsKit/DigitsKit.h>
#import "WHSingletonClass.h"
#import "WHHomeViewController.h"
#import "WHProfileFillViewController.h"
#import "WHUpdateAddressViewController.h"
#import "WHLoginCodeViewController.h"
#import "WHForgotPassThreeViewController.h"

@interface WHMainViewController (){
    
    WHSingletonClass *sharedObject;
    float abc;
    long abcd;
    NSString *getEmail;
    NSString *getPassword;
    int temp;
    NSUserDefaults *defaults;
    NSString *getStatus;
    NSString *getLoggedIn;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;
@property (weak, nonatomic) IBOutlet UIView *viewTerms;

@end

@implementation WHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObject=[WHSingletonClass sharedManager];
    //Digits.sharedInstance().logOut();
    [self customiseUI];
     [self buildAgreeTextViewFromString:NSLocalizedString(@"#<ts>Terms of Use# and #<pp>Privacy Policy#",)];
     defaults = [NSUserDefaults standardUserDefaults];

    getLoggedIn=[defaults objectForKey:@"LOGGED"];
    
    if ([getLoggedIn isEqualToString:@"1"]) {
        sharedObject.singletonIsLoggedIn=1;
    }
    else if ([getLoggedIn isEqualToString:@"0"]){
        sharedObject.singletonIsLoggedIn=0;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //do calculations
        
        sharedObject.singletonEmail=[defaults objectForKey:@"EMAIL"];
        sharedObject.singletonVrfCode=[defaults objectForKey:@"V_CODE"];
        sharedObject.singletonStatus=[defaults objectForKey:@"STATUS"];
        sharedObject.singletonFirstName=[defaults objectForKey:@"FIRST_NAME"];
        sharedObject.singletonLastName=[defaults objectForKey:@"LAST_NAME"];
        sharedObject.singletonUserId=[defaults objectForKey:@"ID"];
        sharedObject.deviceId=[defaults objectForKey:@"TOKEN"];
        sharedObject.singletonPinCode=[defaults objectForKey:@"PINCODE"];
        sharedObject.singletonState=[defaults objectForKey:@"STATE"];
        sharedObject.singletonCity=[defaults objectForKey:@"CITY"];
        sharedObject.singletonAddress=[defaults objectForKey:@"ADDRESS"];
        sharedObject.singletonDob=[defaults objectForKey:@"DOB"];
        sharedObject.singletonOccupation=[defaults objectForKey:@"OCCUPATION"];
        sharedObject.singletonImage=[defaults objectForKey:@"IMAGE"];
        sharedObject.singletonMobile=[defaults objectForKey:@"MOBILE"];
        sharedObject.singletonWeehiveName=[defaults objectForKey:@"WEEEHIVE_NAME"];
        sharedObject.singletonInterestOne=[defaults objectForKey:@"INT1"];
        sharedObject.singletonInterestTwo=[defaults objectForKey:@"INT2"];
        sharedObject.singletonInterestThree=[defaults objectForKey:@"INT3"];
        sharedObject.singletonRegistrationDate=[defaults objectForKey:@"DATE"];
        sharedObject.singletonNeighbourhoodId=[defaults objectForKey:@"NEG_ID"];
        sharedObject.singletonIsAddressEntered=[defaults objectForKey:@"ADD_ENTERED"];
        getStatus=[defaults objectForKey:@"STATUS"];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //load main view controller
            
            //Profile screen
            if ([getLoggedIn isEqualToString:@"1"] ) {
                
                if ([getStatus isEqualToString:@"1"]) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
                    UINavigationController *navVc=(UINavigationController *) window.rootViewController;
                    WHProfileFillViewController *someVC = (WHProfileFillViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"profileStoryboard"];
                    [navVc pushViewController: someVC animated:YES];
                }
                else if ([getStatus isEqualToString:@"2"]){
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
                    UINavigationController *navVc=(UINavigationController *) window.rootViewController;
                    WHHomeViewController *someVC = (WHHomeViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"homeStoryBoard"];
                    [navVc pushViewController: someVC animated:YES];
                }
                else if ([getStatus isEqualToString:@"3"]){
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
                    UINavigationController *navVc=(UINavigationController *) window.rootViewController;
                    WHForgotPassThreeViewController *someVC = (WHForgotPassThreeViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"changePassStoryboard"];
                    [navVc pushViewController: someVC animated:YES];
                }
                else if ([getStatus isEqualToString:@"4"]){
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
                    UINavigationController *navVc=(UINavigationController *) window.rootViewController;
                    WHHomeViewController *someVC = (WHHomeViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"homeStoryBoard"];
                    [navVc pushViewController: someVC animated:YES];
                }
                else if ([getStatus isEqualToString:@"5"]){
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
                    UINavigationController *navVc=(UINavigationController *) window.rootViewController;
                    WHLoginCodeViewController *someVC = (WHLoginCodeViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"vcodeStoryBoard"];
                    [navVc pushViewController: someVC animated:YES];
                }
                else if ([getStatus isEqualToString:@"6"]){
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
                    UINavigationController *navVc=(UINavigationController *) window.rootViewController;
                    WHUpdateAddressViewController *someVC = (WHUpdateAddressViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"addressStoryboard"];
                    [navVc pushViewController: someVC animated:YES];
                }
                
                
            }
            
        });
    });

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[Digits sharedInstance]logOut];
     self.navigationController.navigationBarHidden=YES;
    
    }

//if([sharedObject.singletonStatus isEqualToString:@"1"]) {
//    //code when user is registered but not entered his profile.
//    [self performSegueWithIdentifier:@"loginToProfileSegueVC" sender:nil];
//}
//else if([sharedObject.singletonStatus isEqualToString:@"2"]){
//    //code when user has entered his profile but not entered his verification code. (with address details entered)
//    [self performSegueWithIdentifier:@"afterLoginHomeSegueVC" sender:nil];
//}
//else if ([sharedObject.singletonStatus isEqualToString:@"3"]){
//    //code when user has asked for password change
//    [self performSegueWithIdentifier:@"changePassSegueVC" sender:nil];
//}
//else if ([sharedObject.singletonStatus isEqualToString:@"4"]){
//    //code when user has entered all details like profile, register, verification code so it is that permanenet status now.
//    [self performSegueWithIdentifier:@"afterLoginHomeSegueVC" sender:nil];
//}
//else if ([sharedObject.singletonStatus isEqualToString:@"5"]){
//    //code when trial period ends. 7 days are gone.
//    [self performSegueWithIdentifier:@"loginToCodeSegueVC" sender:nil];
//    
//}
//else if ([sharedObject.singletonStatus isEqualToString:@"6"]){
//    //code when address and verification code are not entered
//    //so we will take user onto update address screen
//    [self performSegueWithIdentifier:@"loginToUpdateAddressSegueVC" sender:nil];

//- (void) functionToTakeNextScreen{
//
//    defaults = [NSUserDefaults standardUserDefaults];
//    getEmail=[defaults objectForKey:@"EMAIL"];
//    getPassword=[defaults objectForKey:@"PASSWORD"];
//
//}

-(void) customiseUI{
    
    //Terms and Policy View.
    self.viewTerms.backgroundColor=[UIColor clearColor];
    
    self.buttonLogin.layer.cornerRadius=2.0f;
    self.buttonLogin.layer.masksToBounds=YES;
    
    self.buttonSignUp.layer.cornerRadius=2.0f;
    self.buttonSignUp.layer.masksToBounds=YES;
}

- (IBAction)buttonSignUpPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"mainToGettingStartedSegueVC" sender:nil];
}

- (IBAction)buttonLoginPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"loginSegueVC" sender:nil];
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
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink)
        {
            label.textColor = [UIColor colorWithRed:238.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1];
            label.highlightedTextColor = [UIColor whiteColor];
            
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
        
        [label sizeToFit];
        
        if (self.viewTerms.frame.size.width < wordLocation.x + label.bounds.size.width)
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
        label.frame = CGRectMake(wordLocation.x + self.viewTerms.frame.size.width/8,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);
        // Show this label:
        [self.viewTerms addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        [self performSegueWithIdentifier:@"termsMainSegueVC" sender:nil];
    }
}


- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        [self performSegueWithIdentifier:@"privacyMainPolicySegueVC" sender:nil];
    }
}


//keyboard disappear/appear wherever touch on screen
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
