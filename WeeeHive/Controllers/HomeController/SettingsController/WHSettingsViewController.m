//
//  WHSettingsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 18/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHSettingsViewController.h"
#import "WHSingletonClass.h"
#import "Constant.h"
#import "ASNetworkAlertClass.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "WHSingletonClass.h"
#import "JSONHTTPClient.h"
#import "WHSettingsTableViewCell.h"
#import "WHPlainTableViewCell.h"
#import "WHLoginViewController.h"
#import "WHLoginCodeViewController.h"

//verification code and address not entered not entered

#define imageIconArray @[@"about",@"key",@"address",@"verified",@"help",@"logout"]
#define nameArray @[@"About Us",@"Edit credentials",@"Update Address",@"Enter Verification Code",@"Help",@"Logout"]
#define segueNames @[@"AboutUsSegueVC",@"editCredentialsSegueVC",@"updateAddressSegueVC",@"settingsToCodeSegueVC",@"helpSegueVC"]



//Address updated but verification code not
#define imageIconNoAddressArray @[@"about",@"key",@"verified",@"help",@"logout"]
#define nameNoAddressArray @[@"About Us",@"Edit credentials",@"Enter Verification Code",@"Help",@"Logout"]
#define segueNoAddressNames @[@"AboutUsSegueVC",@"editCredentialsSegueVC",@"settingsToCodeSegueVC",@"helpSegueVC"]


//both has entered.

#define imageIconNoVerificationCodeNoAddressArray @[@"about",@"key",@"help",@"logout"]
#define nameNoVerificationCodeNoAddressArray @[@"About Us",@"Edit credentials",@"Help",@"Logout"]
#define segueNoVerificationCodeNoAddressNames @[@"AboutUsSegueVC",@"editCredentialsSegueVC",@"helpSegueVC"]


@interface WHSettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *gettedUserId;
    NSString *gettedToken;
    NSString *gettedDeviceId;
    NSString *gettedStatus;
    NSString *gettedIsAddressEntered;
    int temp;
    
    WHSingletonClass *sharedObject;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewSettings;

@end

@implementation WHSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
     defaults = [NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    self.tableViewSettings.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([gettedStatus isEqualToString:@"2"]) {
        //Code when verification code is not entered
        
        if ([gettedIsAddressEntered isEqualToString:@"Yes"] || [gettedIsAddressEntered isEqualToString:@"yes"] || [gettedIsAddressEntered isEqualToString:@"YES"]) {
            
            //address entered, verification code not
            temp=2;
            [self animateTableView];
        }
        else{
            //both not entered
            temp=1;
            [self animateTableView];
        }
    }
    else{
        //Code when verification code  and address are entered.
        temp=3;
        [self animateTableView];
    }
    
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Settings";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    
}


- (void) getValues{
    
    gettedUserId=[[WHSingletonClass sharedManager] singletonUserId];
    gettedToken=[[WHSingletonClass sharedManager] singletonToken];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    gettedStatus=[[WHSingletonClass sharedManager] singletonStatus];
    gettedIsAddressEntered=[[WHSingletonClass sharedManager] singletonIsAddressEntered];

}

- (void)animateTableView {
    
    [self.tableViewSettings reloadData];
    NSArray *cells = self.tableViewSettings.visibleCells;
    CGFloat height = self.tableViewSettings.bounds.size.height;
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

#pragma mark  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (temp==1) {
        
        return 13;
    }
    else if (temp==2){
        
        return 11;
    }
    else{
        return 9;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row % 2 == 1) {
        
        
        WHSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHSETTINGS_CELL];
        
        
        //both not entered i.e verification code as well as address
        if (temp==1) {
            cell.labelName.text= [nameArray objectAtIndex:indexPath.row/2];
            cell.imageViewIcon.image = [UIImage imageNamed:[imageIconArray objectAtIndex:indexPath.row/2]];
            cell.backgroundColor=[UIColor whiteColor];
            
            return cell;
            
        }
        
        //Address entered but verification code not
        else if (temp==2){
            
            cell.labelName.text= [nameNoAddressArray objectAtIndex:indexPath.row/2];
            cell.imageViewIcon.image = [UIImage imageNamed:[imageIconNoAddressArray objectAtIndex:indexPath.row/2]];
            cell.backgroundColor=[UIColor whiteColor];
            
            return cell;
            
        }
        
        //Both has entered i.e code and address both.
        else{
            cell.labelName.text= [nameNoVerificationCodeNoAddressArray objectAtIndex:indexPath.row/2];
            cell.imageViewIcon.image = [UIImage imageNamed:[imageIconNoVerificationCodeNoAddressArray objectAtIndex:indexPath.row/2]];
            cell.backgroundColor=[UIColor whiteColor];
            
            return cell;
            
            
        }
        
        
    }
    else{
        
        WHPlainTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:WHPLAIN_CELL];
        
        cell1.backgroundColor=[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f  blue:242.0f/255.0f  alpha:1.0f];
        
        return cell1;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 1) {
        return 44.0f;
    } else {
        return 8.0f;
    }
}

#pragma  mark  UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row % 2 == 1) {
        
        if (temp==1) {
            // Check that segue exist in array or not.
            if ((indexPath.row/2) < segueNames.count) {
                
                [self performSegueWithIdentifier:segueNames[indexPath.row/2] sender:nil];
            }
            else{
                
                sharedObject.singletonIsLoggedIn=0;
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                //  [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
        //address entered but verification code not
        else if (temp==2){
            // Check that segue exist in array or not.
            if ((indexPath.row/2) < segueNoAddressNames.count) {
                
                [self performSegueWithIdentifier:segueNoAddressNames[indexPath.row/2] sender:nil];
            }
            else{
                
                sharedObject.singletonIsLoggedIn=0;
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
               
            }

        }
        
        //both entered i.e code and address both
        else{
            // Check that segue exist in array or not.
            if ((indexPath.row/2) < segueNoVerificationCodeNoAddressNames.count) {
                
                [self performSegueWithIdentifier:segueNoVerificationCodeNoAddressNames[indexPath.row/2] sender:nil];
            }
            else{
                
                sharedObject.singletonIsLoggedIn=0;
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
              //  [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
        
    }
    else{
    }
    
}

#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"settingsToCodeSegueVC"]) {
        WHLoginCodeViewController *secondVC = segue.destinationViewController;
        secondVC.temp=2;
    }
    else{
        
    }

}

////SERVICE CALLING FOR PROFILE
//- (void) serviceCallingForLogout{
//
//    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
//
//
//        NSString *details = [NSString stringWithFormat:@"u_id=%@@&token=%@", gettedUserId, gettedToken];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // Code executed in the background
//
//
//            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_LOGOUT]
//                                           bodyString:details
//                                           completion:^(NSDictionary *json, JSONModelError *err)
//             {
//
//
//
//
//             }];
//
//        });
//
//    }
//    else {
//        [[ASNetworkAlertClass sharedManager] showInternetErrorAlertWithMessage];
//    }
//    
//}



@end
