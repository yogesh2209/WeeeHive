//
//  WHGettingStartedViewController.m
//  WeeeHive
//
//  Created by Schoofi on 31/01/16.
//  Copyright © 2016 Schoofi. All rights reserved.
//

#import "WHGettingStartedViewController.h"
#import "KASlideShow.h"

@interface WHGettingStartedViewController ()<KASlideShowDelegate>{
    
    int value;
}

@property (strong, nonatomic) IBOutlet KASlideShow *slideShow;
@property (strong, nonatomic) IBOutlet UIButton *buttonSkip;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation WHGettingStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    // KASlideshow
    self.slideShow.delegate = self;
    [self.slideShow setDelay:1]; // Delay between transitions
    [self.slideShow setTransitionDuration:.5]; // Transition duration
    [self.slideShow setTransitionType:KASlideShowTransitionSlide]; // Choose a transition type (fade or slide)
    [self.slideShow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [self.slideShow addImagesFromResources:@[@"findfriends.png",@"yrcircle.png",@"yourweehive.png",@"neghtimes.png",@"flyerscoupons.png",@"helpin.png",@"pulsepoll.png"]];
    // Add images from resources
   // Gesture to go previous/next directly on the image
   [self.slideShow addGesture:KASlideShowGestureSwipe];
   // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.slideShow getSelectedIndex:^(NSInteger selectedIndex) {
        
        value= (int) selectedIndex;
      
        
        [self performSegueWithIdentifier:@"gettingStartedToRegisterSegueVC" sender:nil];
        
    }];
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Get Started";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    [self.slideShow addSubview:self.pageControl];
    [self.slideShow addSubview:self.buttonSkip];
}

- (IBAction)buttonSkipPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"gettingStartedToRegisterSegueVC" sender:nil];
}

#pragma mark - KASlideShow delegate

- (void)kaSlideShowWillShowNext:(KASlideShow *)slideShow
{
   
    self.pageControl.currentPage=slideShow.currentIndex;
}

- (void)kaSlideShowWillShowPrevious:(KASlideShow *)slideShow
{
 
     self.pageControl.currentPage=slideShow.currentIndex;
}

- (void) kaSlideShowDidShowNext:(KASlideShow *)slideShow
{
  
    self.pageControl.currentPage=slideShow.currentIndex;
}

-(void)kaSlideShowDidShowPrevious:(KASlideShow *)slideShow
{
   
     self.pageControl.currentPage=slideShow.currentIndex;
}

@end
