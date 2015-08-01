//
//  RegiestSuccessVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "RegiestSuccessVC.h"
#import "LoginVC.h"

@interface RegiestSuccessVC ()

@end

@implementation RegiestSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - buttonAciton 

- (IBAction)SuccessAction:(id)sender {
    
    for (UIViewController *t_vc in self.navigationController.viewControllers) {
        if ([t_vc isKindOfClass: [LoginVC class]]) {
            [self.navigationController popToViewController:t_vc animated:YES];
            return;
        }
    }
}

#pragma mark - dealloc

-(void)dealloc{
    
    NSLog(@"RegiestSuccessVC dealloc");

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
