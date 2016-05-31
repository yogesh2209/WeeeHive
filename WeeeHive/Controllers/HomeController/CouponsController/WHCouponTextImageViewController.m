//
//  WHCouponTextImageViewController.m
//  WeeeHive
//
//  Created by Schoofi on 03/12/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHCouponTextImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Constant.h"

@interface WHCouponTextImageViewController ()<NSURLSessionDownloadDelegate,NSURLConnectionDelegate>

{
    
    float count;
    NSTimer *timer;
    NSURLConnection *urlConnection;
    NSString *tempString;
    // File Manager.
    NSFileManager *fileManager;
    NSURL *documentsURL;
    NSArray *itemsInFolder;
    NSURL *fileURL;
    ALAssetsLibrary* library;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCoupon;
@property (weak, nonatomic) IBOutlet UITextView *textViewFlyer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation WHCouponTextImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getValues];
    [self customizeUI];
    [self addPinchGesture];
    [self allocation];
    library=[[ALAssetsLibrary alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.progressView.hidden=YES;
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
    self.textViewFlyer.layer.borderColor=[UIColor clearColor].CGColor;
}

- (void)getValues{
    
    self.imageViewCoupon.image=self.getImage;
    self.textViewFlyer.text=self.getTextFlyer;
    [self.textViewFlyer setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    self.textViewFlyer.textColor = [UIColor blackColor];
}

- (IBAction)downloadButtonPressed:(id)sender {
    self.progressView.hidden=NO;
    [self serviceCalling];
}

- (void)allocation {
    fileManager = [NSFileManager defaultManager];
    documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
}

- (void)calltimer {
    
    count = 0.0f;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
}

- (void)updateProgressBar {
    
    if (count < 1.0f) {
        
        count = count + 0.1f;
        self.progressView.progress = count;
    } else {
        
        [timer invalidate];
        timer = nil;
    }
}

- (void)serviceCalling {
    
    tempString = [self.imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MAIN_URL,tempString]]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask * downloadTask =[defaultSession downloadTaskWithRequest:request];
    [downloadTask resume];
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // Set progress bar hidden.
    float progressPercentage = totalBytesWritten*100/totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.progressView.progress = progressPercentage/100;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd:MM:yyyy hh:mm:ss"];
    
    //Get Document directory path.
    fileURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@.jpg", [formatter stringFromDate:[NSDate date]]]];
    
    self.progressView.hidden=YES;
    if ([fileManager fileExistsAtPath:[fileURL path]]) {
        
        
        //  [fileManager removeItemAtPath:[fileURL path] error:nil];
    } else {
        
        // CODE TO MOVE FILE FROM DEFAULT LOCATION TO DOCUMENT DIRECTORY.
        NSError *moveError;
        if (![fileManager moveItemAtURL:location toURL:fileURL error:&moveError]) {
            
            // return;
        }
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[fileURL path]];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(self));
        
    });
    
}

-(void)image:(UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo: (void *) contextInfo{
    if (error !=NULL){
        self.progressView.hidden=YES;
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"image not saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    
    else{
        self.progressView.hidden=YES;
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"image saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
}

- (NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// Pinch Gesture
- (void)addPinchGesture {
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureCalled:)];
    [self.imageViewCoupon addGestureRecognizer:pinchGesture];
}

// UIPinchGestureRecognizer Selector
- (void)pinchGestureCalled:(UIPinchGestureRecognizer *)recognizer {
    
    if (recognizer.scale > 1.0f && recognizer.scale < 10.0f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        self.imageViewCoupon.transform = transform;
    }
}


@end
