//
//  UserAgreementVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/31.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserAgreementVC.h"

@interface UserAgreementVC ()

@end

@implementation UserAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户协议";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 
#pragma mark - private

- (void)initUI{
    UIImage * image_t = [UIImage imageNamed:@"loginBg"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_determine setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];

 
}

#pragma mark - butttonAction 

- (IBAction)determineActtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark - dealloc 

-(void)dealloc{

    NSLog(@"UserAgreementVC dealloc");

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
