//
//  DailyFirstVC.m
//  WifiTest
//
//  Created by nd on 15/8/5.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DailyFirstVC.h"

//#import "CCProgressView.h"
#import "PNChart.h"

#import "DataAPI.h"
#import "TestTool.h"
#import "DataTools.h"
#import "DeviceHelper.h"

@interface DailyFirstVC (){
    ShowHUD *_hud;

}

@property (weak, nonatomic) IBOutlet UIView *v_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UIButton *btn_bluetooth;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_bluetooth;

//@property (strong,nonatomic) CCProgressView *progress;
@property (nonatomic,strong) PNCircleChart * circleChart;

@end

@implementation DailyFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self reloadData];
    [self ConectDeviceAcion:nil];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - loadUI

- (void) initUI{
    
    //    [ShareFun getCorner:_v_bg withBorderWidth:1.0f withBorderColor:RGB(45, 169, 238)];
    
}

-(void)loadCircleChart:(float)number{
    
    UIColor *color;
    
    if (number > 0.8) {
        color = RGB(150, 203, 62);
    }else if(number < 0.8 && number > 0.6){
        color = RGB(201, 204, 0);
    }else if(number < 0.6){
        color = RGB(255, 118, 124);
    }
    
    [self.circleChart removeFromSuperview];
    self.circleChart = [[PNCircleChart alloc]initWithFrame:CGRectMake(0,0, _v_bg.frame.size.width-35, _v_bg.frame.size.width-35) total:@100 current:[NSNumber numberWithFloat:number*100] clockwise:YES shadow:NO shadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.center = CGPointMake(_v_bg.frame.size.width/2, _v_bg.frame.size.width/2);
    [self.circleChart setStrokeColor:color];
    //[self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
    [self.circleChart setLineWidth:@18];
    [self.circleChart strokeChart];
    [_v_bg addSubview:self.circleChart];
    [_v_bg sendSubviewToBack:self.circleChart];
    
}

/*
-(void)loadPrecentView:(float)number{
    
    UIColor *color;
    if (number > 0.8) {
        color = RGB(33, 211, 58);
    }else if(number < 0.8 && number > 0.6){
        color = RGB(237, 229, 107);
    }else if(number < 0.6){
        color = RGB(237, 14, 72);
    }
    
    [_progress removeFromSuperview];
    
    _progress = [[CCProgressView alloc] initWithFrame:CGRectMake(14.5, 14.5, self.v_bg.frame.size.width-29, self.v_bg.frame.size.height-29) withColor:color];
    _progress.backgroundColor = [UIColor clearColor];
    [self.v_bg addSubview:_progress];
    [self.v_bg sendSubviewToBack:_progress];
    [_progress setProgress:number animated:YES];
}
*/

#pragma mark - private methods

-(void) reloadData{
    
    DateDatasRequest *request = [[DateDatasRequest alloc]init];
    request.page = @1;
    request.mid = [ShareValue sharedShareValue].member.mid;
    request.inputType = @0;
    __weak __typeof(self) weakSelf = self;
    [DataAPI dateDatasWithRequest:request completionBlockWithSuccess:^(NSArray *datas) {
        [DataTools sharedDataTools].dateDatas = datas;
        [NotificationCenter postNotificationName:NOTIFICATION_DATACHANGE object:nil];
        DateMonidata *dateMonidata = [datas firstObject];
        Monidata *monidata = dateMonidata.bestMonidata;
        if ([dateMonidata.saveDate isEqual:[ShareFun convertStringFromDate:[NSDate date]]]) {
            
            weakSelf.lb_info.text = @"尖峰呼气流量状态";
            weakSelf.lb_state.text = monidata.stateString;
            float value =  [monidata.pef floatValue] / [[ShareValue sharedShareValue].member.defPef floatValue];
            [weakSelf loadCircleChart:value];
            //[self loadPrecentView:value];
        }else{
            _lb_info.text = @"您今天还没测试哦";
            [self loadCircleChart:0];
            //[self loadPrecentView:0];
        }
        
    } Fail:^(int code, NSString *failDescript) {
        _lb_info.text = @"您今天还没测试哦";
        [self loadCircleChart:0];
    }];
}

/*
-(void)commitData{
    
    DataCommitRequest *t_request = [[DataCommitRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    t_request.pef = @([TestTool sharedTestTool].pef);
    t_request.fev1 = @([TestTool sharedTestTool].fev1);
    t_request.fvc = @([TestTool sharedTestTool].fvc);
    t_request.inputType = @0;
    __weak __typeof(self) weak = self;
    [DataAPI dataCommitWithRequest:t_request completionBlockWithSuccess:^(Monidata *data) {
        [_hud hide];
        [weak reloadData];
    } Fail:^(int code, NSString *failDescript) {
        [_hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}
 */


#pragma mark - buttonAction

- (IBAction)ConectDeviceAcion:(id)sender {
    [self startListening];
    if (![DeviceHelper sharedDeviceHelper].isConnected) {
        [[DeviceHelper sharedDeviceHelper]scan];
        [_btn_bluetooth setEnabled:NO];
        [_btn_bluetooth setTitle:@"正在搜索设备，请确定设备已打开" forState:UIControlStateNormal];
    }else{
        [_btn_bluetooth setTitle:@"请对设备呼气" forState:UIControlStateNormal];
        [_imageV_bluetooth setImage:[UIImage imageNamed:@"图标-蓝牙-已连接"]];
    }
    /*
    __weak typeof(self) weakSelf = self;
    
    [[GCDQueue globalQueue] execute:^{
        
        [[TestTool sharedTestTool] test];
        
        NSLog(@"%f",[TestTool sharedTestTool].pef);
        NSLog(@"%f",[TestTool sharedTestTool].fvc);
        
        NSLog(@"%2f",[TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue]);
        [weakSelf commitData];
        
    }];
     */
}

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

#pragma mark - Notification

-(void)deviceFound:(NSNotification *)notification{
    _btn_bluetooth.enabled = NO;
    [_btn_bluetooth setTitle:@"发现设备正在连接" forState:UIControlStateNormal];
    [[DeviceHelper sharedDeviceHelper]connectDeviceByName:[DeviceHelper sharedDeviceHelper].deviceNames.firstObject];
}


-(void)deviceConneted:(NSNotification *)notification{
    _btn_bluetooth.enabled = NO;
    [_imageV_bluetooth setImage:[UIImage imageNamed:@"图标-蓝牙-已连接"]];
    [_btn_bluetooth setTitle:@"设备已连接，等待用户呼气" forState:UIControlStateNormal];
}

-(void)dataUpdate:(NSNotification *)notification{
    _btn_bluetooth.enabled = NO;
    [_btn_bluetooth setTitle:@"监测到用户呼气，请稍候..." forState:UIControlStateNormal];
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
    __weak __typeof(self) weak = self;
    _hud = [ShowHUD showTextOnly:@"请求中..." configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    [DataAPI dataCommitWithRequest:t_request completionBlockWithSuccess:^(Monidata *data) {
        if (_hud) {
            [_hud hide];
            _hud = nil;
        }
        [weak reloadData];
        
        _btn_bluetooth.enabled = NO;
        [_btn_bluetooth setTitle:@"监测完成" forState:UIControlStateNormal];
        
    } Fail:^(int code, NSString *failDescript) {
        
        if (_hud) {
            [_hud hide];
            _hud = nil;
        }
        _btn_bluetooth.enabled = NO;
        [_btn_bluetooth setTitle:@"监测数据错误,请重新监测" forState:UIControlStateNormal];

        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
    
}

-(void)powerLow:(NSNotification *)notification{
    _btn_bluetooth.enabled = YES;
    [_btn_bluetooth setTitle:@"设备电量低，请更换电池" forState:UIControlStateNormal];
}

-(void)connectTimeout:(NSNotification *)notification{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接超时，请确定设备已打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    
}

-(void)deviceRest:(NSNotification *)notification{
    
    _btn_bluetooth.enabled = YES;
    [_imageV_bluetooth setImage:[UIImage imageNamed:@"图标-蓝牙-未连接"]];
    [_btn_bluetooth setTitle:@"设备未连接，请点击连接" forState:UIControlStateNormal];
}



#pragma mark - dealloc

-(void)dealloc{
    [self stopListening];
    NSLog(@"DailyFirstVC dealloc ");
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
