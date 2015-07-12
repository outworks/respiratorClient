//
//  HeartRateVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/12.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "HeartRateVC.h"

@interface HeartRateVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_heartRate;


@end

@implementation HeartRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - ButtonAciton 

- (IBAction)connectAction:(id)sender {
    
    
    
}



#pragma mark -  dealloc 

-(void)dealloc{

    NSLog(@"HeartRateVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
