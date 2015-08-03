//
//  DrugDetectionVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugDetectionVC.h"
#import "AppDelegate.h"

@interface DrugDetectionVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_drugDetail;
@property (weak, nonatomic) IBOutlet UITextField *tf_drug;

@property (weak, nonatomic) IBOutlet UIView *v_measure;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_stateContent;
@property (weak, nonatomic) IBOutlet UIView *v_measureResults;
@property (weak, nonatomic) IBOutlet UIView *v_drugDetail;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn_upOrDown;
@property (nonatomic,assign) BOOL isUp;


@property (weak, nonatomic) IBOutlet UIButton *btn_commodity;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;

@end

@implementation DrugDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUp = NO;
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - loadUI

-(void)initUI{
    [ShareFun getCorner:_btn_commodity withCorner:_btn_commodity.frame.size.height/2 withBorderWidth:1.f withBorderColor:[UIColor clearColor]];
    [ShareFun getCorner:_btn_back];
    [ShareFun getCorner:_v_measure withCorner: 10.0f withBorderWidth:1.0f withBorderColor:RGB(45, 169, 238)];
    [ShareFun getCorner:_btn_drugDetail withCorner: _btn_drugDetail.frame.size.height/2 withBorderWidth:1.0f withBorderColor:RGB(45, 169, 238)];
    
    NSLayoutConstraint * t_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_v_bottom attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-64];
    t_bottom.identifier = @"1112";
    [self.view addConstraint:t_bottom];
}

#pragma mark - private methods



#pragma mark - buttonAction

- (IBAction)drugDetailAction:(id)sender {
    
    
    
}







#pragma mark - buttonActionNormal

#pragma mark - button Methods

//返回
- (IBAction)backAction:(id)sender {
    
    [ApplicationDelegate.nav popViewControllerAnimated:YES];
}

//商品
- (IBAction)commodityAction:(id)sender {
    
    
    
}


//向上或向下
- (IBAction)upOrdownAction:(id)sender {
    
    _isUp = !_isUp;
    
    if (_isUp) {
        
        NSArray *array = self.view.constraints;
        for (NSLayoutConstraint *constraint in array) {
            //NSLog(@"%@", constraint.identifier);
            if ([constraint.identifier isEqual:@"1112"]) {
                [self.view removeConstraint:constraint];
            }
        }
        
        NSLayoutConstraint * t_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_v_bottom attribute:NSLayoutAttributeBottom multiplier:1.0 constant:49];
        t_bottom.identifier = @"11121";
        [self.view addConstraint:t_bottom];
        
        
        
    }else{
        
        NSArray *array = self.view.constraints;
        for (NSLayoutConstraint *constraint in array) {
            //NSLog(@"%@", constraint.identifier);
            if ([constraint.identifier isEqual:@"11121"]) {
                [self.view removeConstraint:constraint];
            }
        }
        
        NSLayoutConstraint * t_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_v_bottom attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-64];
        t_bottom.identifier = @"1112";
        [self.view addConstraint:t_bottom];
        
    }
    
}

//日常
- (IBAction)dailyAction:(id)sender {
    
    
}

//运动
- (IBAction)motionAction:(id)sender {
    
    
}

//用药
- (IBAction)DrugAction:(id)sender {
    
    
}




#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;
        
    }
    
}

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"DrugDetectionVC dealloc");

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
