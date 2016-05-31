//
//  WHAboutUsViewController.m
//  WeeeHive
//
//  Created by Schoofi on 14/11/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#import "WHAboutUsViewController.h"
#import "WHAboutUsTableViewCell.h"
#import "Constant.h"


@interface WHAboutUsViewController (){
    
    NSArray *titleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewAbout;

@end

@implementation WHAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeUI];
    titleArray =[[NSArray alloc]initWithObjects:@"About WeeeHive",@"Terms of Use",@"Privacy Policy", nil];
    [self animateTableView];
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
    titleView.text =@"About Us";
    titleView.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    titleView.textColor = [UIColor blackColor];
    titleView.tintColor=[UIColor blackColor];
    // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    
}


- (void)animateTableView {
    
    [self.tableViewAbout reloadData];
    NSArray *cells = self.tableViewAbout.visibleCells;
    CGFloat height = self.tableViewAbout.bounds.size.height;
    
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
    
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WHAboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHABOUTUS_CELL];
    cell.labelOptions.text=[titleArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
    
}


#pragma  mark  UITableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"aboutWeehiveSegueVC" sender:nil];
    }
    
    else if (indexPath.row==1){
        
        [self performSegueWithIdentifier:@"termsSegueVC" sender:nil];
    }
    
    else if (indexPath.row==2){
        
        [self performSegueWithIdentifier:@"privacySegueVC" sender:nil];
    }
    
    
}

@end
