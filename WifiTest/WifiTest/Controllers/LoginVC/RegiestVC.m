//
//  RegiestVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/14.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "RegiestVC.h"
#import "UserAgreementVC.h"
#import "MemberAPI.h"
#import "SexSelectionVC.h"

@interface RegiestVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwdAgain;

@end

@implementation RegiestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - private

-(void)registerRequest{
    
    __weak __typeof(*& self) weakSelf = self;
    
    MemberRegisterRequest *request = [[MemberRegisterRequest alloc] init];
    request.username = [_tf_userName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    request.pwd = [_tf_pwd.text md5HexDigest];
    [MemberAPI MemberRegisterWithRequest:request completionBlockWithSuccess:^{
        NSLog(@"注册成功");

        [ShareValue sharedShareValue].m_password = _tf_pwd.text;
        [ShareValue sharedShareValue].m_username = _tf_userName.text;
        [weakSelf loginRequest];
    
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];

    }];

}

-(void)loginRequest{
    
    __weak typeof(*&self) weakSelf = self;
    MemberLoginRequest *request = [[MemberLoginRequest alloc] init];
    request.username = [ShareValue sharedShareValue].m_username;
    request.pwd = [[ShareValue sharedShareValue].m_password md5HexDigest];
    [MemberAPI MemberLoginWithRequest:request completionBlockWithSuccess:^(Member *data) {
        NSLog(@"登录成功");
        [ShareValue sharedShareValue].member = data;
        
        [[GCDQueue mainQueue] execute:^{
            SexSelectionVC *t_vc = [[SexSelectionVC alloc] init];
            t_vc.member = [ShareValue sharedShareValue].member;
            t_vc.isRegiest = YES;
            [weakSelf.navigationController pushViewController:t_vc animated:YES];
        } afterDelay:1.0f*NSEC_PER_SEC];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
    
}

#pragma mark - buttonAction

- (IBAction)userAgreementAction:(id)sender {
    UserAgreementVC *t_vc = [[UserAgreementVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
}


- (IBAction)nextAction:(id)sender {
    
    if (_tf_userName.text.length == 0) {
        [ShowHUD showError:@"请输入邮箱/手机号" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return;
    }
    
    if (_tf_pwd.text.length == 0) {
        [ShowHUD showError:@"请输入密码" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return;
    }
    
    if (![_tf_pwd.text isEqual:_tf_pwdAgain.text]) {
        [ShowHUD showError:@"两次输入密码不一致" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return;
    }
    
    if (![ShareFun validateEmail:_tf_userName.text] && ![ShareFun validatePhone:_tf_userName.text]) {
        [ShowHUD showError:@"请输入正确的邮箱/手机号" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return;
    }
    
    [self registerRequest];
    
//    SexSelectionVC *t_vc = [[SexSelectionVC alloc] init];
//    [self.navigationController pushViewController:t_vc animated:YES];

}

#pragma mark - dealloc

-(void)dealloc{
    
    NSLog(@"RegiestVC dealloc");
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
