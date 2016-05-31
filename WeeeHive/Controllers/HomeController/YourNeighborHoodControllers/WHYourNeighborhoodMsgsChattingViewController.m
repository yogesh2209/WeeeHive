//
//  WHYourNeighborhoodMsgsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 29/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHYourNeighborhoodMsgsChattingViewController.h"
#import "WHYourNeghborDetailsViewController.h"
#import "JSONHTTPClient.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "ASNetworkAlertClass.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "ContentView.h"
#import "ChatTableViewCell.h"
#import "ChatCellSettings.h"
#import "WHNeghborChatListModel.h"
#import "WHNeghborChatListDetailsModel.h"
#import "NSDate+DateTools.h"


@interface iMessage: NSObject

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMessage;
@property (strong, nonatomic) NSString *userTime;
@property (strong, nonatomic) NSString *messageType;

@end

@implementation iMessage

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.userName = name;
        self.userMessage = message;
        self.userTime = time;
        self.messageType = type;
    }
    
    return self;
}

@end

@interface WHYourNeighborhoodMsgsChattingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHNeghborChatListModel *chatData;
    WHNeghborChatListDetailsModel *chatInfoModel;
    WHSingletonClass *sharedObject;
    
    NSString *getUserId;
    NSString *getToken;
    NSMutableArray *currentMessages;
    ChatCellSettings *chatCellSettings;
    NSString *getReceiverUserId;
    NSString *getMessage;
    NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSDate *originalDate;
    NSString *finalDate;
    NSString *getFirstName;
    NSString *getLastName;
    NSString *gettedImageString;
    NSUserDefaults *defaults;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIButton *buttonTop;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMessages;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet ContentView *contentView;

/*Uncomment second line and comment first to use XIB instead of code*/
@property (strong,nonatomic) ChatTableViewCell *chatCell;
//@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;

@property (strong,nonatomic) ContentView *handler;


@end

@implementation WHYourNeighborhoodMsgsChattingViewController
@synthesize chatCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getValues];
    defaults=[NSUserDefaults standardUserDefaults];
    sharedObject=[WHSingletonClass sharedManager];
    gettedDeviceId=[[WHSingletonClass sharedManager] deviceId];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    self.chatTextView.text = @"type message";
    self.chatTextView.textColor = [UIColor lightGrayColor];
    self.chatTextView.delegate = self;
    currentMessages = [[NSMutableArray alloc] init];
    chatCellSettings = [ChatCellSettings getInstance];
    [self customizeUI];
    self.tableViewMessages.backgroundColor=[UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.tableViewMessages.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.buttonSend.layer.cornerRadius=2.0f;
    self.buttonSend.layer.masksToBounds=YES;
    self.chatTextView.backgroundColor=[UIColor clearColor];
    self.chatTextView.layer.cornerRadius=2.0f;
    self.chatTextView.layer.masksToBounds=YES;
    self.chatTextView.layer.borderColor=[UIColor blackColor].CGColor;
    self.chatTextView.layer.borderWidth=0.7f;
    [chatCellSettings setSenderBubbleColorHex:@"007AFF"];
    [chatCellSettings setReceiverBubbleColorHex:@"DFDEE5"];
    [chatCellSettings setSenderBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleNameTextColorHex:@"000000"];
    [chatCellSettings setSenderBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleMessageTextColorHex:@"000000"];
    [chatCellSettings setSenderBubbleTimeTextColorHex:@"FFFFFF"];
    [chatCellSettings setReceiverBubbleTimeTextColorHex:@"000000"];
    [chatCellSettings setSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [chatCellSettings setReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [chatCellSettings senderBubbleTailRequired:YES];
    [chatCellSettings receiverBubbleTailRequired:YES];
    self.tableViewMessages.backgroundColor=[UIColor clearColor];
    [self.tableViewMessages setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    /*Uncomment second para and comment first to use XIB instead of code*/
    //Registering custom Chat table view cell for both sending and receiving
    [self.tableViewMessages registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatSend"];
    [self.tableViewMessages registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"chatReceive"];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewMessages addSubview:refreshControl];
     /*UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
     [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatSend"];
     nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
     [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatReceive"];*/
    //Instantiating custom view that adjusts itself to keyboard show/hide
    self.handler = [[ContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    
    //Setting the minimum and maximum number of lines for the textview vertical expansion
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:1];
    
    //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.tableViewMessages addGestureRecognizer:gestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.chatTextView resignFirstResponder];
}

- (void)refresh {
    
    
    [self serviceCallingForGettingNiehgborMessages];
    
    
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}


-(void) getValues{
    
    getUserId=[[WHSingletonClass sharedManager]singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    getReceiverUserId=self.gettingUserId;
    getFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    getLastName=[[WHSingletonClass sharedManager]singletonLastName];
    gettedImageString=[[WHSingletonClass sharedManager]singletonImage];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self serviceCallingForGettingNiehgborMessages];
}



//set title
-(void) customizeUI
{
    [self.buttonTop setTitle:[NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName] forState:UIControlStateNormal];
    [self.buttonTop setTintColor:[UIColor blackColor]];
    self.buttonTop.backgroundColor=[UIColor clearColor];
  
}

- (void) dismissKeyboard
{
    [self.chatTextView resignFirstResponder];
}


- (IBAction)barButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"neighborDetailsSegueVC" sender:nil];
}

- (void) textFieldValue{
    
    getMessage=self.chatTextView.text;
}

//#pragma mark  UITextField Delegates
//
//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    if (self.chatTextView.textColor == [UIColor lightGrayColor]) {
//        self.chatTextView.text = @"";
//        self.chatTextView.textColor = [UIColor blackColor];
//    }
//    
//    return YES;
//}
//
//-(void) textViewDidChange:(UITextView *)textView
//{
//    if(self.chatTextView.text.length == 0){
//        self.chatTextView.textColor = [UIColor lightGrayColor];
//        self.chatTextView.text = @"type message";
//        [self.chatTextView resignFirstResponder];
//    }
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        if(self.chatTextView.text.length == 0){
//            self.chatTextView.textColor = [UIColor lightGrayColor];
//            self.chatTextView.text = @"type message";
//            [self.chatTextView resignFirstResponder];
//        }
//        return NO;
//    }
//    
//    return YES;
//}

//service calling for neighbor Messages
- (void) serviceCallingForGettingNiehgborMessages{
    
    [currentMessages removeAllObjects];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"msg_by=%@&token=%@&msg_to=%@&device_id=%@",getUserId,getToken,getReceiverUserId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_NEGHBOURCHAT]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewMessages.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No previous conversation";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewMessages.hidden=NO;
                     self.tableViewMessages.backgroundView = messageLabel;
                     self.tableViewMessages.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
                     chatData=[[WHNeghborChatListModel alloc]initWithDictionary:json error:&err];
                     
                     for (WHNeghborChatListDetailsModel *each in chatData.chat) {
                         
                         [currentMessages addObject:each.message];
                         
                     }
                     

                 }
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableViewMessages reloadData];
                     [self updateTableView];
                     
                     
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

//service calling for neighbor Add to message
- (void) serviceCallingForAddingMessageChat{
    
    [self textFieldValue];
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"msg_by=%@&token=%@&msg_to=%@&msg=%@&device_id=%@&first_name=%@&last_name=%@&image=%@",getUserId,getToken,getReceiverUserId,getMessage,gettedDeviceId,getFirstName,getLastName,gettedImageString];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDMESSAGENEGHCHAT]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 
                 else if ([messageStatus.Msg isEqualToString:@"1"]){
                     self.chatTextView.text=@"";
                     [self serviceCallingForGettingNiehgborMessages];
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



#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatInfoModel=chatData.chat[indexPath.row];
    
    if ([getUserId isEqualToString:[NSString stringWithFormat:@"%@",chatInfoModel.msg_by]]) {
        
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        /*Uncomment second line and comment first to use XIB instead of code*/
        
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        chatCell.chatMessageLabel.text = chatInfoModel.message;
        
      //  chatCell.chatNameLabel.text = [NSString stringWithFormat:@"%@",chatInfoModel.first_name];
        
         chatCell.chatNameLabel.text =@"you";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:chatInfoModel.date_time];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        finalDate = [dateFormatter stringFromDate:originalDate];
        chatCell.chatTimeLabel.text=[NSString stringWithFormat:@"%@",finalDate];
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeSender;
        
    }
    
    else
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        
        chatCell.chatMessageLabel.text = chatInfoModel.message;
        
        chatCell.chatNameLabel.text = [NSString stringWithFormat:@"%@",chatInfoModel.first_name];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:chatInfoModel.date_time];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        finalDate = [dateFormatter stringFromDate:originalDate];
        chatCell.chatTimeLabel.text=[NSString stringWithFormat:@"%@",finalDate];
        
        
        //chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        chatCell.chatUserImage.hidden=YES;
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeReceiver;
    }
    
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    chatInfoModel=chatData.chat[indexPath.row];
    
    
    CGSize constraint = CGSizeMake(225, 20000);
    
    // Size for Name
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",chatInfoModel.first_name,chatInfoModel.last_name];
    
    CGFloat heightName = 0.0;
    
    
    if (name.length > 0) {
        
        NSAttributedString *attributedTextName =  [[NSAttributedString alloc] initWithString:name];
        
        CGRect rectName= [attributedTextName boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize sizeName   = rectName.size;
        
        heightName = MAX(sizeName.height, 19.0f);
        
    }
    
    CGFloat heightDate = 0.0;
    
    NSString *date = [NSString stringWithFormat:@"%@",chatInfoModel.date_time];
    
    if (date.length > 0) {
        
        NSAttributedString *attributedTextDate =  [[NSAttributedString alloc] initWithString:date];
        
        CGRect rectDate= [attributedTextDate boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize sizeDate   = rectDate.size;
        
        heightDate = MAX(sizeDate.height, 19.0f);
    }
    
    
    NSArray *fontArray=[[NSArray alloc]init];
    
    fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    
    CGSize Messagesize;
    
    
    Messagesize = [chatInfoModel.message boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:fontArray[1]}
                                                      context:nil].size;
    
    
    return 10.0f +  Messagesize.height+ heightDate + heightName+ 50.0f;
}
#pragma mark  UINavigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    WHYourNeghborDetailsViewController *secondVC = segue.destinationViewController;
    secondVC.firstName=self.firstName;
    secondVC.lastName=self.lastName;
    secondVC.occupation=self.occupation;
    secondVC.morningAct=self.morningAct;
    secondVC.eveningAct=self.eveningAct;
    secondVC.weekendAct=self.weekendAct;
    secondVC.purpose=self.purpose;
    secondVC.livingSince=self.livingSince;
    secondVC.getImage=self.getImage;
    secondVC.getSchool=self.getSchool;
    secondVC.getCollege=self.getCollege;
    secondVC.getWeehiveName=self.weehiveName;
    secondVC.getOriginCity=self.getOriginCity;
    secondVC.getOrigin=self.getOrigin;
    secondVC.getWorkInterest=self.getWorkInterest;
    secondVC.getSpeciality=self.getSpeciality;
    secondVC.help=self.help;

}
- (IBAction)buttonSendPressed:(id)sender {
    
    if([self.chatTextView.text length]!=0)
    {
        if ([self.chatTextView.text isEqualToString:@"type message"]) {
            
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Message cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            
        }
        else{
            [self serviceCallingForAddingMessageChat];
            
        }
        
        
    }
    

}

- (void) updateTableView{
    
    //Always scroll the chat table when the user sends the message
    if([self.tableViewMessages numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableViewMessages numberOfRowsInSection:0]-1 inSection:0];
        [self.tableViewMessages scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

#pragma mark  UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([tokenStatus.error isEqualToString:@"0"]) {
 
                NSString *string=@"0";
                [defaults setObject:string forKey:@"LOGGED"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
  
}

@end
