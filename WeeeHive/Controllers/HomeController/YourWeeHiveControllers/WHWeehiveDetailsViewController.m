//
//  WHWeehiveDetailsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 24/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHWeehiveDetailsViewController.h"
#import "WHWeehiveGroupMembersViewController.h"
#import "WHWeehiveGroupChatTableViewCell.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "ASNetworkAlertClass.h"
#import "WHSingletonClass.h"
#import "WHTokenErrorModel.h"
#import "WHMessageModel.h"
#import "WHYourWeehiveModel.h"
#import "WHYourWeehiveDetailsModel.h"

#import "GroupContentView.h"
#import "GroupChatTableViewCell.h"
#import "GroupChatCellSettings.h"

@interface iGroupMessage: NSObject

-(id) initGroupIMessageWithName:(NSString *)name
                        message:(NSString *)message
                           time:(NSString *)time
                           type:(NSString *)type;

@property (strong, nonatomic) NSString *auserName;
@property (strong, nonatomic) NSString *auserMessage;
@property (strong, nonatomic) NSString *auserTime;
@property (strong, nonatomic) NSString *amessageType;

@end

@implementation iGroupMessage

-(id) initGroupIMessageWithName:(NSString *)name
                        message:(NSString *)message
                           time:(NSString *)time
                           type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.auserName = name;
        self.auserMessage = message;
        self.auserTime = time;
        self.amessageType = type;
    }
    
    return self;
}

@end


@interface WHWeehiveDetailsViewController ()<UITextViewDelegate>
{
    
    WHYourWeehiveModel *groupChatData;
    WHYourWeehiveDetailsModel *groupChatInfoModel;
    WHTokenErrorModel *tokenStatus;
    WHMessageModel *messageStatus;
    WHSingletonClass *sharedObject;
    
    NSUserDefaults *defaults;
    
    UILabel * titleView;
    NSString *getUserId;
    NSString *getToken;
    NSString *gettedGroupId;
    NSMutableArray *currentMessages;
    NSString *message;
    GroupChatCellSettings *chatCellSettings;
   NSString *gettedDeviceId;
    UIRefreshControl *refreshControl;
    UILabel *messageLabel;
    NSDate *originalDate;
    NSString *finalDate;
    NSString *gettedFirstName;
    NSString *gettedLastName;
    
}

@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIButton *buttonGroupName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGroupChat;

@property (weak, nonatomic) IBOutlet GroupContentView *contentView;

/*Uncomment second line and comment first to use XIB instead of code*/
@property (strong,nonatomic) GroupChatTableViewCell *chatCell;
//@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;


@property (strong,nonatomic) GroupContentView *handler;



@end

@implementation WHWeehiveDetailsViewController

@synthesize chatCell;

- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self customizeUI];
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
    chatCellSettings = [GroupChatCellSettings getInstance];
    [self customizeUI];
    self.tableViewGroupChat.backgroundColor=[UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.tableViewGroupChat.separatorStyle=UITableViewCellSeparatorStyleNone;
   // self.chatContentView.backgroundColor=[UIColor clearColor];
    
    self.buttonSend.layer.cornerRadius=2.0f;
    self.buttonSend.layer.masksToBounds=YES;
    self.chatTextView.backgroundColor=[UIColor clearColor];
    self.chatTextView.layer.cornerRadius=2.0f;
    self.chatTextView.layer.masksToBounds=YES;
    self.chatTextView.layer.borderColor=[UIColor blackColor].CGColor;
    self.chatTextView.layer.borderWidth=0.7f;
    self.contentView.backgroundColor=[UIColor whiteColor];
    [chatCellSettings setGroupSenderBubbleColorHex:@"007AFF"];
    [chatCellSettings setGroupReceiverBubbleColorHex:@"DFDEE5"];
    [chatCellSettings setGroupSenderBubbleNameTextColorHex:@"FFFFFF"];
    [chatCellSettings setGroupReceiverBubbleNameTextColorHex:@"000000"];
    [chatCellSettings setGroupSenderBubbleMessageTextColorHex:@"FFFFFF"];
    [chatCellSettings setGroupReceiverBubbleMessageTextColorHex:@"000000"];
    [chatCellSettings setGroupSenderBubbleTimeTextColorHex:@"FFFFFF"];
    [chatCellSettings setGroupReceiverBubbleTimeTextColorHex:@"000000"];
    
    [chatCellSettings setGroupSenderBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setGroupReceiverBubbleFontWithSizeForName:[UIFont boldSystemFontOfSize:11]];
    [chatCellSettings setGroupSenderBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setGroupReceiverBubbleFontWithSizeForMessage:[UIFont systemFontOfSize:14]];
    [chatCellSettings setGroupSenderBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    [chatCellSettings setGroupReceiverBubbleFontWithSizeForTime:[UIFont systemFontOfSize:11]];
    
    [chatCellSettings senderGroupBubbleTailRequired:YES];
    [chatCellSettings receiverGroupBubbleTailRequired:YES];
  //  self.navigationItem.title = @"iMessageBubble Demo";
    [[self tableViewGroupChat] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [self.tableViewGroupChat addSubview:refreshControl];
    
    
    
    
    /*Uncomment second para and comment first to use XIB instead of code*/
    //Registering custom Chat table view cell for both sending and receiving
    [[self tableViewGroupChat] registerClass:[GroupChatTableViewCell class] forCellReuseIdentifier:@"chatSend"];
    
    [[self tableViewGroupChat] registerClass:[GroupChatTableViewCell class] forCellReuseIdentifier:@"chatReceive"];
    
    
    /*UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
     
     [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatSend"];
     
     nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
     
     [[self chatTable] registerNib:nib forCellReuseIdentifier:@"chatReceive"];*/
    
    //Instantiating custom view that adjusts itself to keyboard show/hide
    self.handler = [[GroupContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    
    //Setting the minimum and maximum number of lines for the textview vertical expansion
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];
    
    //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.tableViewGroupChat addGestureRecognizer:gestureRecognizer];

}

// Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.chatTextView resignFirstResponder];
}

- (void)refresh {
    
    
    [self serviceCallingForGettingChatList];
    
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

- (void) dismissKeyboard
{
    [self.chatTextView resignFirstResponder];
}

//set title
-(void) customizeUI
{
    [self.buttonGroupName setTitle:[NSString stringWithFormat:@"%@",self.getGroupName] forState:UIControlStateNormal];
    [self.buttonGroupName setTintColor:[UIColor blackColor]];
    self.buttonGroupName.backgroundColor=[UIColor clearColor];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getValuesFromLastScreen];
    [self serviceCallingForGettingChatList];
}

- (IBAction)buttonGroupNamePressed:(id)sender {
    
    [self performSegueWithIdentifier:@"groupMembersSegueVC" sender:nil];
}

- (void)getValues{
    
    getUserId=[[WHSingletonClass sharedManager] singletonUserId];
    getToken=[[WHSingletonClass sharedManager]singletonToken];
    gettedFirstName=[[WHSingletonClass sharedManager]singletonFirstName];
    gettedLastName=[[WHSingletonClass sharedManager]singletonLastName];
}

- (void) getValuesFromLastScreen{
    
    gettedGroupId=self.getGroupId;
}

-(void) getTextFieldValue{
    message=self.chatTextView.text;
}

//service calling for getting chat list
- (void) serviceCallingForGettingChatList{
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&group_id=%@&device_id=%@",getUserId,getToken,gettedGroupId,gettedDeviceId];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_GROUPCHATLIST]
                                           bodyString:details
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
            
                 
                 tokenStatus=[[WHTokenErrorModel alloc]initWithDictionary:json error:&err];
                 messageStatus=[[WHMessageModel alloc]initWithDictionary:json error:&err];
                 groupChatData=[[WHYourWeehiveModel alloc]initWithDictionary:json error:&err];
                 
                 if ([tokenStatus.error isEqualToString:@"0"]) {
                     sharedObject.singletonIsLoggedIn=0;
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session expired" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                 }
                 else if ([messageStatus.Msg isEqualToString:@"0"]){
                     messageLabel.hidden=NO;
                     messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableViewGroupChat.frame.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height)];
                     
                     messageLabel.text = @"No previous conversation";
                     messageLabel.textColor = [UIColor lightGrayColor];
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = NSTextAlignmentCenter;
                     messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                     [messageLabel sizeToFit];
                     self.tableViewGroupChat.hidden=NO;
                     self.tableViewGroupChat.backgroundView = messageLabel;
                     self.tableViewGroupChat.separatorStyle = UITableViewCellSeparatorStyleNone;
                 }
                 else{
                     [refreshControl endRefreshing];
                     messageLabel.hidden=YES;
             
                     
                 }
                 
                 
                 // Update UI in main thread.
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableViewGroupChat reloadData];
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

//service calling for adding message in group chat.
- (void) serviceCallingForAddingMessageGroupChat{
    
    
    [self getTextFieldValue];
   
    
    if ([[ASNetworkAlertClass sharedManager] isInternetActive]) {
        
        // Show Progress bar.
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *details = [NSString stringWithFormat:@"u_id=%@&token=%@&group_id=%@&message=%@&device_id=%@&first_name=%@&last_name=%@",getUserId,getToken,gettedGroupId,message,gettedDeviceId,gettedFirstName,gettedLastName];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Code executed in the background
            
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", MAIN_URL,POST_ADDMSGGROUP]
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
                     [self serviceCallingForGettingChatList];
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


- (void) updateTableView{
    
    //Always scroll the chat table when the user sends the message
    if([self.tableViewGroupChat numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableViewGroupChat numberOfRowsInSection:0]-1 inSection:0];
        [self.tableViewGroupChat scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return groupChatData.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    groupChatInfoModel=groupChatData.group[indexPath.row];
  
    
    if ([getUserId isEqualToString:[NSString stringWithFormat:@"%@",groupChatInfoModel.comment_by]]) {
    
           /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (GroupChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        chatCell.achatMessageLabel.text = groupChatInfoModel.message;
        
       chatCell.achatNameLabel.text=@"you";
//       chatCell.achatNameLabel.text = [NSString stringWithFormat:@"%@ %@",groupChatInfoModel.first_name,groupChatInfoModel.last_name];
        
       // chatCell.achatTimeLabel.text = groupChatInfoModel.date;
        
        //chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        chatCell.achatUserImage.hidden=YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:groupChatInfoModel.date];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        finalDate = [dateFormatter stringFromDate:originalDate];
        chatCell.achatTimeLabel.text=[NSString stringWithFormat:@"%@",finalDate];
        
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iGroupMessageBubbleTableViewCellAuthorTypeSender;
    }
    else
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        chatCell = (GroupChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        //chatCell.achatNameLabel.text=@"you";
        chatCell.achatMessageLabel.text = groupChatInfoModel.message;
        
       chatCell.achatNameLabel.text = [NSString stringWithFormat:@"%@",groupChatInfoModel.first_name];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        originalDate   =  [dateFormatter dateFromString:groupChatInfoModel.date];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        finalDate = [dateFormatter stringFromDate:originalDate];
        chatCell.achatTimeLabel.text=[NSString stringWithFormat:@"%@",finalDate];
        
        //chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        chatCell.achatUserImage.hidden=YES;
        
        /*Comment this line is you are using XIB*/
        chatCell.authorType = iGroupMessageBubbleTableViewCellAuthorTypeReceiver;
    }
    
    return chatCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //iMessage *message = [currentMessages objectAtIndex:indexPath.row];
    groupChatInfoModel=groupChatData.group[indexPath.row];
    
    
    CGSize constraint = CGSizeMake(225, 20000);
    
    // Size for Name
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",groupChatInfoModel.first_name,groupChatInfoModel.last_name];
    
    CGFloat heightName = 0.0;
    
    
    if (name.length > 0) {
        
        NSAttributedString *attributedTextName =  [[NSAttributedString alloc] initWithString:name];
        
        CGRect rectName= [attributedTextName boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize sizeName   = rectName.size;
        
        heightName = MAX(sizeName.height, 19.0f);
        
    }
    
    CGFloat heightDate = 0.0;
    
    NSString *date = [NSString stringWithFormat:@"%@",groupChatInfoModel.date];
    
    if (date.length > 0) {
        
        NSAttributedString *attributedTextDate =  [[NSAttributedString alloc] initWithString:date];
        
        CGRect rectDate= [attributedTextDate boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize sizeDate   = rectDate.size;
        
        heightDate = MAX(sizeDate.height, 19.0f);
    }
    
    
    NSArray *fontArray=[[NSArray alloc]init];
    
    fontArray = chatCellSettings.getGroupSenderBubbleFontWithSize;
    
    CGSize Messagesize;
    
    
    Messagesize = [groupChatInfoModel.message boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:fontArray[1]}
                                                      context:nil].size;
    
    
    return 10.0f +  Messagesize.height+ heightDate + heightName+ 50.0f;
}


#pragma mark  UINavigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WHWeehiveGroupMembersViewController *secondVC = segue.destinationViewController;
    secondVC.getGroupId=self.getGroupId;
    secondVC.getGroupName=self.getGroupName;
    secondVC.imagePath=self.getImagePath;
    secondVC.createdBy=self.getCreatedBy;
    secondVC.createdDate=self.createdDate;
    secondVC.getFirstName=self.getFirstName;
    secondVC.getLastName=self.getLastName;
    secondVC.groupDesc=self.groupDesc;
    
    
}

- (IBAction)buttonSendPressed:(id)sender {
    
    if([self.chatTextView.text length]!=0)
    {
        if ([self.chatTextView.text isEqualToString:@"type message"]) {
            
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Message cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
        else{
            [self serviceCallingForAddingMessageGroupChat];
            
        }
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
