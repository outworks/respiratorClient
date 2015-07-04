//
//  BlueClientVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/4.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BlueClientVC.h"
#import "AppDelegate.h"
#import "BlueCentralVC.h"
#import "BluePeripheralVC.h"

@interface BlueClientVC ()

@end

@implementation BlueClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - buttonAciton 

- (IBAction)blueCentralAction:(id)sender {
    BlueCentralVC *t_vc = [[BlueCentralVC alloc] init];
    [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
    
}

- (IBAction)bluePeripheralAction:(id)sender {
    
    BluePeripheralVC *t_vc = [[BluePeripheralVC alloc] init];
    [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
}


#pragma mark - dealloc

-(void)dealloc{


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
