//
//  UserNickNameVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserNickNameVC.h"
#import "SexSelectionVC.h"

@interface UserNickNameVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_nickName;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_nickName;

@property (weak, nonatomic) IBOutlet UILabel *lb_nickName;

@property (weak, nonatomic) IBOutlet UIButton *btn_next;


@end

@implementation UserNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户名称";
    [self initUI];
    _tf_nickName.text = _member.nickname;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark initUI

- (void)initUI{

    UIImage *image_t = [UIImage imageNamed:@"image_gray"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
    [_imageV_nickName setImage:[image_t resizableImageWithCapInsets:inset]];
    
    [_tf_nickName setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    
    image_t = [UIImage imageNamed:@"loginBg"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_next setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];

}

#pragma mark -
#pragma mark buttonAction

- (IBAction)nextAction:(id)sender {
    
    if (_tf_nickName.text.length == 0) {
        _tf_nickName.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_nickName setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_nickName setText:@"请输入用户名称"];
        return;
    }
    
    _member.nickname = _tf_nickName.text;
    SexSelectionVC *t_vc = [[SexSelectionVC alloc] init];
    t_vc.member = _member;
    t_vc.isRegiest = _isRegiest;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}


#pragma mark - 
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //开始编辑时触发，文本字段将成为first responder
    if (textField == _tf_nickName) {
        _lb_nickName.text = @"";
        _tf_nickName.textColor = UIColorFromRGB(0x50c0ce);
        UIImage *image_t = [UIImage imageNamed:@"image_green"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_nickName setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == _tf_nickName) {
        _tf_nickName.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIImage *image_t = [UIImage imageNamed:@"image_gray"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_nickName setImage:[image_t resizableImageWithCapInsets:inset]];
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 
#pragma mark dealloc

- (void)dealloc{
    
    NSLog(@"UserNickNameVC dealloc");
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
