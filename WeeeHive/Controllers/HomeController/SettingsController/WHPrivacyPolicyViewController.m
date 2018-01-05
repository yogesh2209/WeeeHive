//
//  WHPrivacyPolicyViewController.m
//  WeeeHive
//
//  Created by Schoofi on 14/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHPrivacyPolicyViewController.h"
#import "Constant.h"
@interface WHPrivacyPolicyViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WHPrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBarHidden=NO;
    [self customizeUI];
    [self loadWebView];
    [self addPinchGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Privacy Policy";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    
}

// Pinch Gesture
- (void)addPinchGesture {
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureCalled:)];
    [self.webView addGestureRecognizer:pinchGesture];
}
// UIPinchGestureRecognizer Selector
- (void)pinchGestureCalled:(UIPinchGestureRecognizer *)recognizer {
    
    if (recognizer.scale > 1.0f && recognizer.scale < 10.0f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        self.webView.transform = transform;
    }
}
- (void)loadWebView {
    
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MAIN_URL,WHPRIVACY]]];

    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
}

@end
