//
//  DurgMeasureVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "DurgMeasureVC.h"
#import "DataAPI.h"
#import "TestTool.h"
#import "DrugResultsVC.h"
#import "DeviceHelper.h"

typedef NS_ENUM(NSUInteger, DrugTime) {
    DrugTimeAfterBegin = 0,
    DrugTimeAfterEnd = 1,
    DrugTimeBeforeReady = 2,
    DrugTimeBeforeBegin =3,
    DrugTimeBeforeEnd = 4,
};


@interface DurgMeasureVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_drugTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_drugAction;
@property (weak, nonatomic) IBOutlet UILabel *lb_drugName;
@property (weak, nonatomic) IBOutlet UIButton *btn_drugTip;

@property (weak, nonatomic) IBOutlet UIButton *btn_blubTooth;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bluetooth;


@property (nonatomic,assign) DrugTime drugTime;

@property (nonatomic,strong) Monidata *beforeMonidata;
@property (nonatomic,strong) Monidata *afterMonidata;

@property (nonatomic,strong) GCDTimer *timer;

@end

@implementation DurgMeasureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日用药监测";
    _drugTime = DrugTimeAfterBegin;
    
    [self initUI];
    [self scanAcion:nil];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark - initUI

- (void)initUI{
    
    _lb_drugName.text = _drugName;
    self.btn_drugTip.userInteractionEnabled = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(110, 85, 120),NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:21.0]}];
    
}

#pragma mark -
#pragma mark privateMethods



-(void)startListening{
    [self stopListening];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceRest:) name:BLE_DEVICES_REST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceFound:) name:BLE_DEVICE_FOUND object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataUpdate:) name:BLE_UPDATE_DATA object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConneted:) name:BLE_DEVICE_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(powerLow:) name:BLE_POWERLOW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectTimeout:) name:BLE_CONNET_TIMEOUT object:nil];
}

-(void)stopListening{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showGrugResults{

    DrugResultsVC *t_vc = [[DrugResultsVC alloc] init];
    t_vc.afterMonidata = _afterMonidata;
    t_vc.beforeMonidata = _beforeMonidata;
    t_vc.drugName = _drugName;
    [self.navigationController pushViewController:t_vc animated:YES];
}

- (void)changeState{
    
    if (_timer) {
        [_timer destroy];
        [_timer dispatchRelease];
        _timer = nil;
    }
    
    __block int codeTime = 5;
    __weak typeof(self) weakSelf = self;
    _timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [_timer event:^{
        codeTime = codeTime - 1;
        [weakSelf.lb_drugAction setText:[NSString stringWithFormat:@"%ds后量测...",codeTime]];
        
        if (codeTime == 0) {
            [weakSelf.btn_drugTip setTitle:@"量测开始" forState:UIControlStateNormal];
            weakSelf.lb_drugAction.text = @"请吹气...";
            weakSelf.btn_drugTip.userInteractionEnabled = YES;
            weakSelf.drugTime = DrugTimeBeforeBegin;
        
            [weakSelf.timer destroy];
            [weakSelf.timer dispatchRelease];
            weakSelf.timer = nil;
            
        }
        
    } timeInterval:1*NSEC_PER_SEC];
    
    [weakSelf.timer start];
    
    _lb_drugTime.text = @"用药后";
    [_btn_drugTip setTitle:@"量测准备" forState:UIControlStateNormal];
    _btn_drugTip.userInteractionEnabled = NO;
    _drugTime = DrugTimeBeforeReady;
    
}

#pragma mark - buttonAction

- (IBAction)scanAcion:(id)sender {
    
    [self startListening];
    if (![DeviceHelper sharedDeviceHelper].isConnected) {
        [[DeviceHelper sharedDeviceHelper]scan];
        [_btn_blubTooth setEnabled:NO];
        [_btn_blubTooth setTitle:@"正在搜索设备，请确定设备已打开" forState:UIControlStateNormal];
    }else{
        [_btn_blubTooth setTitle:@"设备已连接" forState:UIControlStateNormal];
         [_imageV_bluetooth setImage:[UIImage imageNamed:@"icon_blue_motion"]];
    }
    
}



#pragma mark - Notification

-(void)deviceFound:(NSNotification *)notification{
    _btn_blubTooth.enabled = NO;
    [_btn_blubTooth setTitle:@"发现设备正在连接" forState:UIControlStateNormal];
    [[DeviceHelper sharedDeviceHelper]connectDeviceByName:[DeviceHelper sharedDeviceHelper].deviceNames.firstObject];
}


-(void)deviceConneted:(NSNotification *)notification{
    _btn_blubTooth.enabled = NO;
     [_imageV_bluetooth setImage:[UIImage imageNamed:@"icon_blue_motion"]];
    [_btn_blubTooth setTitle:@"设备已连接" forState:UIControlStateNormal];
}

-(void)dataUpdate:(NSNotification *)notification{
    
    DataCommitRequest *t_request = [[DataCommitRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    NSNumber *x = [notification.userInfo objectForKey:@"X"];
    NSNumber *x1 = [notification.userInfo objectForKey:@"X1"];
    NSNumber *x2 = [notification.userInfo objectForKey:@"X2"];
    float pef = 29.704* x.intValue - 879.52;
    float fev1 = 0.00547 * x1.intValue + 1.0573;
    float fvc = 8.88*x2.intValue+1.123;;
    t_request.pef = @(pef);
    t_request.fev1 = @(fev1);
    t_request.fvc = @(fvc);
    t_request.inputType = @0;
    t_request.inputType = @2;
    NSNumber *otherType;
    if (_drugTime == DrugTimeAfterBegin) {
        otherType = @1;
    }else{
        otherType = @2;
    }
    t_request.otherType = otherType;
    __weak __typeof(*&self) weak = self;
    [DataAPI dataCommitWithRequest:t_request completionBlockWithSuccess:^(Monidata *data) {
        
        if ([otherType isEqualToNumber:@1]) {
        
            weak.drugTime = DrugTimeAfterEnd;
            [weak.btn_drugTip setTitle:@"量测完成" forState:UIControlStateNormal];
            weak.lb_drugAction.text = @"请服药...";
            weak.afterMonidata = data;
            [weak changeState];
        }else{
            
            weak.drugTime = DrugTimeBeforeEnd;
            [weak.btn_drugTip setTitle:@"量测完成" forState:UIControlStateNormal];
            weak.lb_drugAction.text = @"";
            weak.beforeMonidata = data;
            
            [[GCDQueue mainQueue] execute:^{
            
                weak.drugTime = DrugTimeAfterBegin;
                weak.lb_drugTime.text = @"用药前";
                [weak.btn_drugTip setTitle:@"量测开始" forState:UIControlStateNormal];
                weak.lb_drugAction.text = @"请吹气...";
                
            } afterDelay:1.5*NSEC_PER_SEC];
            
            [weak showGrugResults];
        
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
        if ([otherType isEqualToNumber:@1]) {
            
            
            weak.drugTime = DrugTimeAfterBegin;
            [weak.btn_drugTip setTitle:@"量测开始" forState:UIControlStateNormal];
            weak.lb_drugAction.text = @"请吹气...";
            [self changeState];
            
        }else{
            
            weak.drugTime = DrugTimeBeforeBegin;
            [weak.btn_drugTip setTitle:@"量测开始" forState:UIControlStateNormal];
            weak.lb_drugAction.text = @"请吹气...";
            
        }
        
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        
    }];
}

-(void)powerLow:(NSNotification *)notification{
    _btn_blubTooth.enabled = YES;
    [_btn_blubTooth setTitle:@"设备电量低，请更换电池" forState:UIControlStateNormal];
}

-(void)connectTimeout:(NSNotification *)notification{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接超时，请确定设备已打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}


-(void)deviceRest:(NSNotification *)notification{
    
    _btn_blubTooth.enabled = YES;
    [_imageV_bluetooth setImage:[UIImage imageNamed:@"图标-蓝牙-未连接"]];
    [_btn_blubTooth setTitle:@"设备未连接，请点击连接" forState:UIControlStateNormal];
}



#pragma mark -
#pragma mark dealloc

- (void)dealloc{
    [self stopListening];
    NSLog(@"DrugMeasureVC dealloc");
    
    if (_timer) {
        [_timer destroy];
        [_timer dispatchRelease];
        _timer = nil;
    }
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
