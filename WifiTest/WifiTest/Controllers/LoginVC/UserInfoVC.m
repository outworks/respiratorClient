//
//  UserInfoVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserInfoVC.h"
#import "RegiestSuccessVC.h"

@interface UserInfoVC ()

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    // Do any additional setup after loading the view from its nib.
}



#pragma mark - buttonAction

- (IBAction)nextAction:(id)sender {
    RegiestSuccessVC *t_vc = [[RegiestSuccessVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
}




#pragma mark - dealloc 

-(void)dealloc{

    NSLog(@"UserInfoVC dealloc");

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
