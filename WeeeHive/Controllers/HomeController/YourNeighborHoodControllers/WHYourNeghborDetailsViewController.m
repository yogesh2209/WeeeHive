//
//  WHYourNeghborDetailsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 10/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHYourNeghborDetailsViewController.h"

#import "WHYourNeghDetailsTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "Constant.h"

@interface WHYourNeghborDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSString *tempString;
    int value;
    NSString *ageBracket;
    NSString *getInterest1;
    NSString *getInterest2;
    NSString *getInterest3;
    NSString *variable;
    NSString *getLivingFor;
    NSInteger ageValue;
    
}


@property (weak, nonatomic) IBOutlet UITableView *tableViewYourNeghDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFullSizePic;

@end

@implementation WHYourNeghborDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self customizeUI];
    variable=@"Not mentioned";
    
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
    titleView.text =@"Detail";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}
-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getValues];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *startD = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",self.age]];
    NSDate *endD = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
    NSInteger year  = [components year];
    ageValue= year;
 
    //code for age
    tempString = self.age;
    value = [tempString intValue];
    
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

- (void)animateTableView {
    
    [self.tableViewYourNeghDetails reloadData];
    NSArray *cells = self.tableViewYourNeghDetails.visibleCells;
    CGFloat height = self.tableViewYourNeghDetails.bounds.size.height;
    
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
    
    //LAZY LOADING.
    NSString *final_Url = [NSString stringWithFormat:@"%@%@", MAIN_URL,self.getImage];
    
    [self.imageViewFullSizePic sd_setImageWithURL:[NSURL URLWithString:final_Url] placeholderImage:[UIImage imageNamed:@"blacktransparent"]];
    
    self.imageViewFullSizePic.layer.cornerRadius=self.imageViewFullSizePic.frame.size.height/2;
    self.imageViewFullSizePic.layer.masksToBounds=YES;
    self.imageViewFullSizePic.layer.borderWidth=0;
    
}

#pragma mark  UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WHYourNeghDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHNEGHDETAILS_CELL];
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.5f;
    cell.layer.cornerRadius=2.0f;
    cell.layer.masksToBounds=YES;
    
    if (indexPath.row == 0) {
        
        cell.labelName.text=[NSString stringWithFormat:@"Name: %@ %@",self.firstName,self.lastName];
    }
    else if (indexPath.row==1){
        cell.labelName.text=[NSString stringWithFormat:@"Age: %@",ageBracket];
    }
    else if (indexPath.row==2){
        if (getLivingFor.length==0) {
            cell.labelName.text=[NSString stringWithFormat:@"Living for: %@",variable];
        }
        else{
            cell.labelName.text=[NSString stringWithFormat:@"Living for: %@ years",getLivingFor];
        }
    }
    else if (indexPath.row==3){
        
        if (self.getOrigin.length==0 && self.getOriginCity.length==0) {
            cell.labelName.text=[NSString stringWithFormat:@"Origin: %@",variable];
        }
        else{
            
            if (self.getOrigin.length!=0 && self.getOriginCity.length==0) {
                cell.labelName.text=[NSString stringWithFormat:@"Origin: %@",self.getOrigin];
            }
            else if (self.getOrigin.length==0 && self.getOriginCity.length!=0){
                cell.labelName.text=[NSString stringWithFormat:@"Origin: %@",self.getOriginCity];
            }
            else{
                cell.labelName.text=[NSString stringWithFormat:@"Origin: %@ / %@",self.getOrigin,self.getOriginCity];
            }
            
        }
    }
    else if (indexPath.row==4){
        if (self.getWorkInterest.length!=0 && self.occupation.length!=0) {
            cell.labelName.text=[NSString stringWithFormat:@"Occupation/Work Interest: %@ / %@",self.occupation,self.getWorkInterest];
        }
        else{
            if (self.getWorkInterest.length!=0 && self.occupation.length==0) {
                cell.labelName.text=[NSString stringWithFormat:@"Work Interest: %@",self.getWorkInterest];
            }
            else if (self.getWorkInterest.length==0 && self.occupation.length!=0){
                cell.labelName.text=[NSString stringWithFormat:@"Occupation: %@",self.occupation];
            }
            
        }
        
    }
    else if (indexPath.row==5){
        //code for interest.
        getInterest1=self.morningAct;
        getInterest2=self.weekendAct;
        getInterest3=self.eveningAct;
        
        if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length==0) {
            
            cell.labelName.text=@"No Interests";
        }
        else{
            
            if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length!=0) {
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest2,getInterest3];
            }
            else if (getInterest1.length==0 && getInterest2.length==0 && getInterest3.length!=0){
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@",getInterest3];
            }
            else if (getInterest2.length==0 && getInterest1.length!=0 && getInterest3.length!=0){
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest1,getInterest3];
            }
            else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length!=0){
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@ / %@ / %@",getInterest1,getInterest2,getInterest3];
            }
            else if (getInterest1.length!=0 && getInterest2.length==0 && getInterest3.length==0){
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@",getInterest1];
            }
            else if (getInterest1.length==0 && getInterest2.length!=0 && getInterest3.length==0){
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@",getInterest2];
            }
            else if (getInterest1.length!=0 && getInterest2.length!=0 && getInterest3.length==0){
                cell.labelName.text=[NSString stringWithFormat:@"Interest: %@ / %@",getInterest1,getInterest2];
            }
            else{
                
            }
        }
    }
    else if (indexPath.row==6){
        if (self.getSpeciality.length!=0 && self.help.length!=0) {
            cell.labelName.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@ / %@",self.help,self.getSpeciality];
        }
        else {
            
            if (self.getSpeciality.length==0 && self.help.length!=0) {
                cell.labelName.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@",self.help];
            }
            else {
                cell.labelName.text=[NSString stringWithFormat:@"Will like to help any neighbour as: %@",variable];
            }
            
        }
    
    }
    return cell;
}



@end
