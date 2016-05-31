//
//  WHMemberProfileViewController.m
//  WeeeHive
//
//  Created by Schoofi on 26/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHMemberProfileViewController.h"

#import "WHMemberGroupInfoTableViewCell.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"

@interface WHMemberProfileViewController (){
    
    NSString *tempString;
    int value;
    NSString *ageBracket;
    NSString *getLivingFor;
    NSString *variable;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSInteger ageValue;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfilePic;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMemberProfileDetailList;

@end

@implementation WHMemberProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    variable=@"Not mentioned";
    [self getValues];
    [self customizeUI];
    [self animateTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //code for age
    tempString = self.age;
    value = [tempString intValue];
    self.imageViewProfilePic.image=self.getImage;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *startD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.age]];
    NSDate *endD = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
    NSInteger year  = [components year];

    ageValue= year;
  
    
    if (ageValue<10) {
        ageBracket=@"less than 10 years";
    }
    
    else if (ageValue>=10 && ageValue<=14) {
        ageBracket=@"10-14 years";
    }
    else if (ageValue>=15 &&  ageValue<=18){
        ageBracket=@"15-18 years";
        
    }
    else if (ageValue>=19 && ageValue<=24){
        ageBracket=@"19-24 years";
        
    }
    else if (ageValue>=25 && ageValue<=35){
        ageBracket=@"25-35 years";
        
    }
    else if (ageValue>=36 && ageValue<=50){
        ageBracket=@"36-50 years";
        
    }
    else if (ageValue>50){
        ageBracket=@"above 50 years";
        
    }
    else{
        ageBracket=@"Not mentioned";
        
    }
    
    if (self.livingSince.length==0) {
        getLivingFor=@"Not mentioned";
    }
    else{
        [self calculateLivingSinceYears];
    }
    
    [self animateTableView];
}

-(void)calculateLivingSinceYears{
    
    if (self.livingSince.length==0) {
        
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSDate *startD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.livingSince]];
        NSDate *endD = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
     
        getLivingFor=[NSString stringWithFormat:@"%ld",(long)[components year]];
        
    }
    
    
}

//set title
-(void) customizeUI
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text =@"Detail";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
   
}

- (void)animateTableView {
    
    [self.tableViewMemberProfileDetailList reloadData];
    NSArray *cells = self.tableViewMemberProfileDetailList.visibleCells;
    CGFloat height = self.tableViewMemberProfileDetailList.bounds.size.height;
    
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

- (void)getValues{
    
    self.imageViewProfilePic.layer.cornerRadius=self.imageViewProfilePic.frame.size.height/2;
    self.imageViewProfilePic.layer.masksToBounds=YES;
    self.imageViewProfilePic.layer.borderWidth=0;
    self.imageViewProfilePic.image=self.getImage;
}

#pragma mark  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHMemberGroupInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHMEMBERPROFILE_CELL];
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.5f;
    cell.layer.cornerRadius=2.0f;
    cell.layer.masksToBounds=YES;
    
    if (indexPath.row == 0) {
        
        cell.labelFields.text=[NSString stringWithFormat:@"Name: %@ %@",self.firstName,self.lastName];
    }
    else if (indexPath.row==1){
        cell.labelFields.text=[NSString stringWithFormat:@"Age: %@",ageBracket];
    }
    else if (indexPath.row==2){
        if (getLivingFor.length==0) {
            cell.labelFields.text=[NSString stringWithFormat:@"Living for: %@",variable];
        }
        else{
            cell.labelFields.text=[NSString stringWithFormat:@"Living for: %@ years",getLivingFor];
        }
    }
    else if (indexPath.row==3){
        
        if (self.getOrigin.length==0 && self.getOriginCity.length==0) {
            cell.labelFields.text=[NSString stringWithFormat:@"Origin: %@",variable];
        }
        else{
            
            if (self.getOrigin.length!=0 && self.getOriginCity.length==0) {
                cell.labelFields.text=[NSString stringWithFormat:@"Origin: %@",self.getOrigin];
            }
            else if (self.getOrigin.length==0 && self.getOriginCity.length!=0){
                cell.labelFields.text=[NSString stringWithFormat:@"Origin: %@",self.getOriginCity];
            }
            else{
                cell.labelFields.text=[NSString stringWithFormat:@"Origin: %@ / %@",self.getOrigin,self.getOriginCity];
            }
            
        }
    }
    else if (indexPath.row==4){
        if (self.getWorkInterest.length!=0 && self.occupation.length!=0) {
            cell.labelFields.text=[NSString stringWithFormat:@"Occupation/Work Interest: %@ / %@",self.occupation,self.getWorkInterest];
        }
        else{
            if (self.getWorkInterest.length!=0 && self.occupation.length==0) {
                cell.labelFields.text=[NSString stringWithFormat:@"Work Interest: %@",self.getWorkInterest];
            }
            else if (self.getWorkInterest.length==0 && self.occupation.length!=0){
                cell.labelFields.text=[NSString stringWithFormat:@"Occupation: %@",self.occupation];
            }
            
        }
    }
    else if (indexPath.row==5){
        //code for interest.
        getInterest1=self.morningAct;
        getInterest2=self.weekendAct;
        getInterest3=self.eveningAct;
        
        if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length==0) {
            
            cell.labelFields.text=@"No Interests";
        }
        else{
            
            if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length!=0) {
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest2,getInterest3];
            }
            else if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length!=0){
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@",getInterest3];
            }
            else if (getInterest2.length==0 && getInterest1.length!=0 && getInterest3.length!=0){
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest1,getInterest3];
            }
            else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length!=0){
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@ / %@ / %@",getInterest1,getInterest2,getInterest3];
            }
            else if (getInterest1.length!=0 && getInterest2.length==0 && getInterest3.length==0){
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@",getInterest1];
            }
            else if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length==0){
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@",getInterest2];
            }
            else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length==0){
                cell.labelFields.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest1,getInterest2];
            }
            else{
                
            }
        }
    }
    
    else if (indexPath.row==6){
        if (self.getSpeciality.length!=0 && self.help.length!=0) {
            cell.labelFields.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@ / %@",self.help,self.getSpeciality];
        }
        else {
            
            if (self.getSpeciality.length==0 && self.help.length!=0) {
                cell.labelFields.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@",self.help];
            }
            else {
                cell.labelFields.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@",variable];
            }
            
        }

    }
    return cell;

}


@end
