//
//  RegiestSuccessVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "RegiestSuccessVC.h"
#import "LoginVC.h"
#import "MemberAPI.h"

@interface RegiestSuccessVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_finish;


@end

@implementation RegiestSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册成功";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private methods

- (void)initUI{

    UIImage * image_t = [UIImage imageNamed:@"loginBg"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_finish setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];

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
