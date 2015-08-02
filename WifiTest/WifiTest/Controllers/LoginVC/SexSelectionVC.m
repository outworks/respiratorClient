//
//  SexSelectionVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SexSelectionVC.h"
#import "UserInfoVC.h"

@interface SexSelectionVC ()

@end

@implementation SexSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isRegiest) {
        self.navigationItem.title = @"注册";
    }else{
        self.navigationItem.title = @"用户信息";
    }

    
    if (_member) {
        if ([_member.sex integerValue] == 0) {
            [_btn_boy setSelected:YES];
        }else{
            [_btn_girl setSelected:YES];
        }
    }
}

#pragma mark - buttonAction 

- (IBAction)btnBoyAction:(id)sender {
    _btn_boy.selected = YES;
    _btn_girl.selected = NO;
}

- (IBAction)btnGirlAction:(id)sender {
    _btn_girl.selected = YES;
    _btn_boy.selected = NO;
}



- (IBAction)nextAction:(id)sender {
    
    if (!_btn_girl.selected && !_btn_boy.selected) {
        [ShowHUD showError:@"请选择性别" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    UserInfoVC *t_vc = [[UserInfoVC alloc] init];
    if (_btn_boy.selected) {
        t_vc.sex = @0;
    }else if(_btn_girl.selected){
        t_vc.sex = @1;
    }
    t_vc.member = _member;
    t_vc.isRegiest = _isRegiest;
    [self.navigationController pushViewController:t_vc animated:YES];
}

#pragma mark - dealloc 

-(void)dealloc{

    NSLog(@"SexSelectionVC dealloc");

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
