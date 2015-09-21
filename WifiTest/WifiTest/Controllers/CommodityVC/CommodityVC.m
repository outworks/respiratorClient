//
//  CommodityVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/7.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "CommodityVC.h"
#import "AppDelegate.h"

@interface CommodityVC ()

@end

@implementation CommodityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回馈商场";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - buttonAction

//返回
- (void)backAction{
    
    [ApplicationDelegate.nav dismissViewControllerAnimated:YES completion:^{
    }];
}




#pragma mark - dealloc

-(void)dealloc{
    
    NSLog(@"CommodityVC dealloc");
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
