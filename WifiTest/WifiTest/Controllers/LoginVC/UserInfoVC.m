//
//  UserInfoVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserInfoVC.h"
#import "RegiestSuccessVC.h"
#import "MemberAPI.h"

@interface UserInfoVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_height;
@property (weak, nonatomic) IBOutlet UITextField *tf_weight;
@property (weak, nonatomic) IBOutlet UITextField *tf_age;

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isRegiest) {
        self.navigationItem.title = @"注册";
    }else{
        self.navigationItem.title = @"用户信息";
    }
    
    if (_member) {
        _tf_height.text = [_member.height stringValue];
        _tf_weight.text = [_member.weight stringValue];
        _tf_age.text = [_member.age stringValue];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private

-(void)updateUserInfo{
    
    __weak __typeof(*&self) weakSelf = self;
    
    MemberUpdateRequest *request = [[MemberUpdateRequest alloc] init];
    request.mid = _member.mid;
    request.sex = _sex;
    request.weight = @([_tf_weight.text longLongValue]);
    request.height = @([_tf_height.text longLongValue]);
    request.age = @([_tf_age.text integerValue]);
    
    [MemberAPI MemberUpdateWithRequest:request completionBlockWithSuccess:^(Member *data) {
        _member = data;
        [ShareValue sharedShareValue].member = _member;
    
        if (_isRegiest) {
            RegiestSuccessVC *t_vc = [[RegiestSuccessVC alloc] init];
            [weakSelf.navigationController pushViewController:t_vc animated:YES];
        }else{
            for (UIViewController *t_vc in weakSelf.navigationController.viewControllers) {
                
                if ([t_vc isKindOfClass:[self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] class]]) {
                    [weakSelf.navigationController popToViewController:t_vc animated:YES];
                    return;
                }
                
            }
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];

}


#pragma mark - buttonAction

- (IBAction)submitAction:(id)sender{
    
    if (_tf_height.text.length == 0) {
        [ShowHUD showError:@"请输入身高" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (_tf_weight.text.length == 0) {
        [ShowHUD showError:@"请输入体重" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    if (_tf_age.text.length == 0) {
        [ShowHUD showError:@"请输入年龄" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }

    [self updateUserInfo];

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
