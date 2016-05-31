//
//  WHCouponFlyerOnlyViewController.m
//  WeeeHive
//
//  Created by Schoofi on 03/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHCouponFlyerOnlyViewController.h"

@interface WHCouponFlyerOnlyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewFlyer;

@end

@implementation WHCouponFlyerOnlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    [self getValues];
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
    titleView.text =@"Coupon";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.textViewFlyer.backgroundColor=[UIColor clearColor];
    self.textViewFlyer.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textViewFlyer.layer.borderWidth=0.5f;
    self.textViewFlyer.layer.cornerRadius=2.0f;
    self.textViewFlyer.layer.masksToBounds=YES;
}

- (void) getValues{
    
    self.textViewFlyer.text=self.getText;
    [self.textViewFlyer setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.textViewFlyer.textColor = [UIColor blackColor];
}


@end
