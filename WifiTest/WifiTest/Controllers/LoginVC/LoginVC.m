//
//  LoginVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/14.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "LoginVC.h"
#import "RegiestVC.h"
#import "MemberAPI.h"

#import "ShareFun.h"
#import "ShareValue.h"

#import "SetUserVC.h"
#import "TestVC.h"
#import "MainVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([ShareValue sharedShareValue].member){
        _tf_userName.text = [ShareValue sharedShareValue].member.username;
    }
    
}

#pragma mark - private 

-(void)loginRequest{
    
    
    MemberLoginRequest *request = [[MemberLoginRequest alloc] init];
    request.username = _tf_userName.text;
    request.pwd =[_tf_pwd.text md5HexDigest];
    [MemberAPI MemberLoginWithRequest:request completionBlockWithSuccess:^(Member *data) {
        NSLog(@"登录成功");
        
        [ShareValue sharedShareValue].member = data;
//        SetUserVC *t_vc = [[SetUserVC alloc] init];
//        [self.navigationController pushViewController:t_vc animated:YES];
        
//        TestVC *t_vc = [[TestVC alloc] init];
//        [self.navigationController pushViewController:t_vc animated:YES];
        MainVC *t_vc = [[MainVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

#pragma mark - buttonAction 

- (IBAction)loginAction:(id)sender {
    if (_tf_userName.text.length == 0) {
        [ShowHUD showError:@"请输入用户名" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return;
    }
    
    if (_tf_pwd.text.length == 0) {
        [ShowHUD showError:@"请输入密码" configParameter:^(ShowHUD *config) {
        } duration:1.5 inView:self.view];
        return;
    }
    
    [self loginRequest];
    
}


- (IBAction)regiestAciton:(id)sender {
    
    RegiestVC *t_vc = [[RegiestVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        //self.navigationController.navigationBarHidden = YES;
        self.navigationItem.leftBarButtonItem = nil;

    }
    
}

#pragma mark - dealloc

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
