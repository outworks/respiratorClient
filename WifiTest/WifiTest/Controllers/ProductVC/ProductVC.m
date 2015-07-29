//
//  ProductVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/30.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "ProductVC.h"
#import "LoginVC.h"

@interface ProductVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_logo;

@property (weak, nonatomic) IBOutlet UIButton *btn_start;


@end

@implementation ProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private methods


-(void)initUI{

    _imageV_logo.layer.cornerRadius = _imageV_logo.frame.size.width/2;
    _imageV_logo.layer.masksToBounds = YES;
    _imageV_logo.layer.borderWidth = 1.0f;
    _imageV_logo.layer.borderColor = [[UIColor clearColor] CGColor];

}


#pragma mark - button Action 


- (IBAction)startActiton:(id)sender {
    
    LoginVC *t_vc = [[LoginVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}


#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;

    }
    
}


#pragma mark - dealloc 

-(void)dealloc{



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
