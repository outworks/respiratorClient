//
//  DrugDetectionVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugDetectionVC.h"
#import "AppDelegate.h"
#import "DataAPI.h"
#import "TestTool.h"

#import "CommodityVC.h"

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

@property (weak, nonatomic) IBOutlet UIButton *btn_test;
@property (nonatomic,assign) BOOL isTesting; //是否在测量

// 测试结果

@property (weak, nonatomic) IBOutlet UILabel *lb_date;

@property (weak, nonatomic) IBOutlet UILabel *lb_beforeTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforePEF;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFEV1;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFVC;
@property (weak, nonatomic) IBOutlet UILabel *lb_beforeFEV1FVC;

@property (weak, nonatomic) IBOutlet UILabel *lb_afterTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterPEF;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFEV1;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFVC;
@property (weak, nonatomic) IBOutlet UILabel *lb_afterFEV1FVC;

@property (weak, nonatomic) IBOutlet UILabel *lb_level; //测评结果

@property (nonatomic,strong) Monidata *beforeMonidata;
@property (nonatomic,strong) Monidata *afterMonidata;


@property (weak, nonatomic) IBOutlet UIButton *btn_commodity;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (nonatomic,strong) GCDTimer *timer;
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

-(void)showGrugResults{
    _v_drugDetail.hidden = YES;
    _v_measureResults.hidden = NO;
    _v_measure.hidden = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date= [dateFormatter dateFromString:_beforeMonidata.saveTime];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *t_dateStr = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    date= [dateFormatter dateFromString:_beforeMonidata.saveTime];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *t_beforeTime = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    date= [dateFormatter dateFromString:_afterMonidata.saveTime];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *t_afterTime = [dateFormatter stringFromDate:date];
    
    _lb_date.text = t_dateStr;
    _lb_beforeTime.text = t_beforeTime;
    _lb_beforePEF.text = [NSString stringWithFormat:@"PEF:%@",[_beforeMonidata.pef stringValue]];
    _lb_beforeFEV1.text = [NSString stringWithFormat:@"FEV1:%@",[_beforeMonidata.fev1 stringValue]];
    _lb_beforeFVC.text = [NSString stringWithFormat:@"FVC:%@",[_beforeMonidata.fvc stringValue]];
    _lb_beforeFEV1FVC.text = [NSString stringWithFormat:@"FEV1/FVC:%.2f%%",[_beforeMonidata.fev1 floatValue]/[_beforeMonidata.fvc floatValue]*100];
    
    _lb_afterTime.text = t_afterTime;
    _lb_afterPEF.text = [NSString stringWithFormat:@"PEF:%@",[_afterMonidata.pef stringValue]];
    _lb_afterFEV1.text = [NSString stringWithFormat:@"FEV1:%@",[_afterMonidata.fev1 stringValue]];
    _lb_afterFVC.text = [NSString stringWithFormat:@"FVC:%@",[_afterMonidata.fvc stringValue]];
    _lb_afterFEV1FVC.text = [NSString stringWithFormat:@"FEV1/FVC:%.2f%%",[_afterMonidata.fev1 floatValue]/[_afterMonidata.fvc floatValue]*100];
    if ([_afterMonidata.level integerValue] == 0) {
        _lb_level.text = @"良好";
    }else  if ([_afterMonidata.level integerValue] == 1) {
        _lb_level.text = @"正常";
    }else  if ([_afterMonidata.level integerValue] == 2) {
        _lb_level.text = @"危险";
    }
    
    
    
}

-(void) reloadData{
    
    DateDatasRequest *request = [[DateDatasRequest alloc]init];
    request.page = @1;
    request.mid = [ShareValue sharedShareValue].member.mid;
    request.inputType = @2;
    __weak __typeof(self) weakSelf = self;
    [DataAPI dateDatasWithRequest:request completionBlockWithSuccess:^(NSArray *datas) {
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

-(void)commitData:(NSNumber *)otherType{
    DataCommitRequest *t_request = [[DataCommitRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    t_request.pef = @([TestTool sharedTestTool].pef);
    t_request.fev1 = @([TestTool sharedTestTool].fev1);
    t_request.fvc = @([TestTool sharedTestTool].fvc);
    t_request.inputType = @2;
    t_request.otherType = otherType;
    __weak __typeof(self) weak = self;
    [DataAPI dataCommitWithRequest:t_request completionBlockWithSuccess:^(Monidata *data) {
        if ([otherType isEqualToNumber:@1]) {
            weak.lb_state.text = @"量测完成";
            weak.lb_stateContent.text = @"请服药";
            weak.isTesting = YES;
            weak.beforeMonidata = data;
        }else{
            weak.lb_state.text = @"";
            weak.lb_stateContent.text = @"量测完成!";
            weak.afterMonidata = data;
            [[GCDQueue mainQueue] execute:^{
                weak.isTesting = NO;
                weak.lb_state.text = @"量测开始";
                weak.lb_stateContent.text = @"请吹气";
                //[self reloadData];
                [weak showGrugResults];
            } afterDelay:3.0f*NSEC_PER_SEC];
            
        }
        
        
    } Fail:^(int code, NSString *failDescript) {
        weak.isTesting = NO;
        weak.lb_state.text = @"量测开始";
        weak.lb_stateContent.text = @"请吹气";
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
    
}


#pragma mark - buttonAction

- (IBAction)drugDetailAction:(id)sender {
    if (_isTesting) {
        return;
    }
    _btn_drugDetail.selected = !_btn_drugDetail.selected;
    if (_btn_drugDetail.selected) {
        _v_drugDetail.hidden = NO;
        _v_measureResults.hidden = YES;
        _v_measure.hidden = YES;
    }else{
        _v_drugDetail.hidden = YES;
        _v_measureResults.hidden = YES;
        _v_measure.hidden = NO;
    }

}

- (IBAction)btnTestAction:(id)sender {
    
    if (_isTesting == NO) {
        _lb_state.text = @"量测开始";
        _lb_stateContent.text = @"请吹气...";
        
        __weak typeof(self) weakSelf = self;
        [[GCDQueue globalQueue] execute:^{
            
            [[TestTool sharedTestTool] test];
            
            NSLog(@"%f",[TestTool sharedTestTool].pef);
            NSLog(@"%f",[TestTool sharedTestTool].fvc);
            
            NSLog(@"%2f",[TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue]);
            [weakSelf commitData:@1];
            
        }];
    }else{
        
        __block int codeTime = 5;
        __weak typeof(self) weakSelf = self;
        _timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
        [_timer event:^{
            codeTime = codeTime - 1;
            [weakSelf.lb_state setText:[NSString stringWithFormat:@"%ds后量测",codeTime]];
            
            if (codeTime == 0) {
                [weakSelf commitData:@2];
                [weakSelf.timer destroy];
                [weakSelf.timer dispatchRelease];
                weakSelf.timer = nil;
                
            }
            
        } timeInterval:1*NSEC_PER_SEC];
        
        [weakSelf.timer start];
        
        _lb_stateContent.text = @"用药后呼吸状态";
    }
   
    
}

//返回
- (IBAction)backAction:(id)sender {
    
    [ApplicationDelegate.nav popViewControllerAnimated:YES];
}

//商品
- (IBAction)commodityAction:(id)sender {
    CommodityVC *t_vc = [[CommodityVC alloc] init];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    [ApplicationDelegate.nav presentViewController:t_nav animated:YES completion:^{
    }];
    
    
}

#pragma mark - buttonActionNormal
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
    NSDictionary *t_dic = @{@"contentType":@"daily"};
    [NotificationCenter postNotificationName:NOTIFICATION_FUNCTIONCHANGE object:nil userInfo:t_dic];
}

//运动
- (IBAction)motionAction:(id)sender {
    NSDictionary *t_dic = @{@"contentType":@"motion"};
    [NotificationCenter postNotificationName:NOTIFICATION_FUNCTIONCHANGE object:nil userInfo:t_dic];
    
}

//用药
- (IBAction)DrugAction:(id)sender {
    NSDictionary *t_dic = @{@"contentType":@"drug"};
    [NotificationCenter postNotificationName:NOTIFICATION_FUNCTIONCHANGE object:nil userInfo:t_dic];
    
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
