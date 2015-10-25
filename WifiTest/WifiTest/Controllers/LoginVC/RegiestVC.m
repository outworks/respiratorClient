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
#import "UserNickNameVC.h"
#import "SexSelectionVC.h"

@interface RegiestVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwdAgain;



@property (weak, nonatomic) IBOutlet UIImageView *imageV_userName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_pwd;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_pwdAgain;

@property (weak, nonatomic) IBOutlet UILabel *lb_userName;
@property (weak, nonatomic) IBOutlet UILabel *lb_pwd;
@property (weak, nonatomic) IBOutlet UILabel *lb_pwdAgain;


@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property (weak, nonatomic) IBOutlet UIButton *btn_agreement;


@end

@implementation RegiestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册新账号";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - private

- (void)initUI{
    
    UIImage *image_t = [UIImage imageNamed:@"image_gray"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
    [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
    [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
    [_imageV_pwdAgain setImage:[image_t resizableImageWithCapInsets:inset]];
    
    [_tf_userName setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [_tf_pwd setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_tf_pwdAgain setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    
    image_t = [UIImage imageNamed:@"loginBg"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_next setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
}

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
        if ([failDescript isEqualToString:@"该用户已存在"]) {
            _tf_userName.textColor = UIColorFromRGB(0xfb7581);
            UIImage *image_t = [UIImage imageNamed:@"image_red"];
            UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
            [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
            [_lb_userName setText:@"输入的电话已被注册，请输入其他号码"];
        }else{
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:self.view];

        }
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
            UserNickNameVC *t_vc = [[UserNickNameVC alloc] init];
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

- (IBAction)agreementAction:(id)sender {
    _btn_agreement.selected = !_btn_agreement.selected;

}



- (IBAction)userAgreementAction:(id)sender {
    UserAgreementVC *t_vc = [[UserAgreementVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
}


- (IBAction)nextAction:(id)sender {
    
    if (_tf_userName.text.length == 0) {
        _tf_userName.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_userName setText:@"请输入邮箱/手机号"];
        return;
    }
    
    if (_tf_pwd.text.length == 0) {
        
        _tf_pwd.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_pwd setText:@"请输入密码"];
       
        return;
    }
    
    if (![_tf_pwd.text isEqual:_tf_pwdAgain.text]) {
        
        _tf_pwd.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_pwd setText:@"两次输入密码不一致"];
        
        
        _tf_pwdAgain.textColor = UIColorFromRGB(0xfb7581);
        image_t = [UIImage imageNamed:@"image_red"];
        inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwdAgain setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_pwdAgain setText:@"两次输入密码不一致"];
    
        return;
    }
    
    if (![ShareFun validateEmail:_tf_userName.text] && ![ShareFun validatePhone:_tf_userName.text]) {
        
        _tf_userName.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_userName setText:@"请输入正确的邮箱/手机号"];
        
        return;
    }
    
    if (_btn_agreement.selected) {
        [ShowHUD showError:@"请同意用户使用协议" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        return;
    }
    
    [self registerRequest];
    
//    SexSelectionVC *t_vc = [[SexSelectionVC alloc] init];
//    [self.navigationController pushViewController:t_vc animated:YES];

}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if (textField == _tf_userName) {
        _lb_userName.text = @"";
        _tf_userName.textColor = UIColorFromRGB(0x50c0ce);
        UIImage *image_t = [UIImage imageNamed:@"image_green"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    if (textField == _tf_pwd) {
        _lb_pwd.text = @"";
        _tf_pwd.textColor = UIColorFromRGB(0x50c0ce);
        UIImage *image_t = [UIImage imageNamed:@"image_green"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    if (textField == _tf_pwdAgain) {
        _lb_pwdAgain.text = @"";
        _tf_pwdAgain.textColor = UIColorFromRGB(0x50c0ce);
        UIImage *image_t = [UIImage imageNamed:@"image_green"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwdAgain setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == _tf_userName) {
        _tf_userName.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIImage *image_t = [UIImage imageNamed:@"image_gray"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    if (textField == _tf_pwd) {
        _tf_pwd.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIImage *image_t = [UIImage imageNamed:@"image_gray"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    if (textField == _tf_pwdAgain) {
        _tf_pwdAgain.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIImage *image_t = [UIImage imageNamed:@"image_gray"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_pwdAgain setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
