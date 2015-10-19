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


#import "FunctionSwitchVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwd;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_userName;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_pwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@property (weak, nonatomic) IBOutlet UILabel *lb_userName;
@property (weak, nonatomic) IBOutlet UILabel *lb_pwd;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    [self initUI];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tf_userName.text = [ShareValue sharedShareValue].m_username;
    _tf_pwd.text = [ShareValue sharedShareValue].m_password;
    
}

#pragma mark - private 

- (void)initUI{

    UIImage *image_t = [UIImage imageNamed:@"image_gray"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
    [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
     [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
    [_tf_userName setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [_tf_pwd setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    image_t = [UIImage imageNamed:@"loginBg"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_login setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
}

-(void)loginRequest{
    
    ShowHUD *hud = [ShowHUD showText:@"登录中..." configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    
    MemberLoginRequest *request = [[MemberLoginRequest alloc] init];
    request.username = _tf_userName.text;
    request.pwd = [_tf_pwd.text md5HexDigest];
    [MemberAPI MemberLoginWithRequest:request completionBlockWithSuccess:^(Member *data) {
        NSLog(@"登录成功");
        [hud hide];
        [ShareValue sharedShareValue].member = data;
        [ShareValue sharedShareValue].m_username = request.username;
        [ShareValue sharedShareValue].m_password = _tf_pwd.text;
        FunctionSwitchVC *t_vc = [[FunctionSwitchVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        if ([failDescript isEqualToString:@"用户名或密码出错"]) {
            _tf_userName.textColor = UIColorFromRGB(0xfb7581);
            UIImage *image_t = [UIImage imageNamed:@"image_red"];
            UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
            [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
            [_lb_userName setText:@"用户名或密码出错"];
            
            _tf_pwd.textColor = UIColorFromRGB(0xfb7581);
            image_t = [UIImage imageNamed:@"image_red"];
            inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
            [_imageV_pwd setImage:[image_t resizableImageWithCapInsets:inset]];
            [_lb_pwd setText:@"用户名或密码出错"];
            
        }else{
            [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
            } duration:1.5f inView:ApplicationDelegate.window];
        }
    }];
}

#pragma mark - buttonAction 

- (IBAction)loginAction:(id)sender {
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
    
    if (![ShareFun validateEmail:_tf_userName.text] && ![ShareFun validatePhone:_tf_userName.text]) {
        
        _tf_userName.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_userName setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_userName setText:@"请输入正确的邮箱/手机号"];
        
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
        self.navigationController.navigationBarHidden = NO;
    
    }
    
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
    
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [textField resignFirstResponder];//查一下resign这个单词的意思就明白这个方法了
    return YES;
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
