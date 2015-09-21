//
//  FunctionSwitchVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/2.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "FunctionSwitchVC.h"
#import "MainVC.h"

@interface FunctionSwitchVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_daily;

@property (weak, nonatomic) IBOutlet UIButton *btn_motion;

@property (weak, nonatomic) IBOutlet UIButton *btn_medication;

@end

@implementation FunctionSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择量测功能";
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _btn_daily.selected = NO;
    _btn_medication.selected = NO;
    _btn_motion.selected = NO;
    
}


#pragma mark - buttonAction

// 日常

- (IBAction)dailyAction:(id)sender {
    _btn_daily.selected = YES;
    _btn_medication.selected = NO;
    _btn_motion.selected = NO;
    MainVC *t_vc = [[MainVC alloc] init];
    t_vc.contentType = DailyType;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

//运动

- (IBAction)motionAction:(id)sender {
    _btn_daily.selected = NO;
    _btn_medication.selected = NO;
    _btn_motion.selected = YES;
    
    MainVC *t_vc = [[MainVC alloc] init];
    t_vc.contentType = MotionType;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (IBAction)medicationAction:(id)sender {
    _btn_daily.selected = NO;
    _btn_medication.selected = YES;
    _btn_motion.selected = NO;
    
    MainVC *t_vc = [[MainVC alloc] init];
    t_vc.contentType = MedicationType;
    [self.navigationController pushViewController:t_vc animated:YES];
}


#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}




#pragma mark - dealloc

- (void)dealloc{
    
    NSLog(@"FunctionSwitchVC dealloc");
    
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
