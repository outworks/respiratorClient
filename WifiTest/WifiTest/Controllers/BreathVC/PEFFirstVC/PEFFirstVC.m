//
//  PEFFirstVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "PEFFirstVC.h"
#import "PNChart.h"
#import "TestTool.h"
#import "ShareValue.h"
#import "DataAPI.h"
#import "DataTools.h"
#import "NoticeMacro.h"
#import "UtilsMacro.h"
#import "CCProgressView.h"
#import "DeviceHelper.h"

@interface PEFFirstVC ()

@property (weak, nonatomic) IBOutlet UIView *v_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;
@property (weak, nonatomic) IBOutlet UIButton *btn_test;

@property (strong, nonatomic) IBOutlet CCProgressView *progress;

@property(nonatomic,strong) ShowHUD *hud;
@property (weak, nonatomic) IBOutlet UILabel *lb_pef;

@property (nonatomic) PNCircleChart * circleChart;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_bg;

@end

@implementation PEFFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private 

- (void) setTop:(CGFloat)t {
    self.imageV_bg.frame = CGRectMake(self.imageV_bg.frame.origin.x, t, self.imageV_bg.frame.size.width, self.imageV_bg.frame.size.height);
}

-(void)loadCircleChart:(float)number{
    
    UIColor *color;
    
    if (number > 0.8) {
        color = RGB(33, 211, 58);
    }else if(number < 0.8 && number > 0.6){
        color = RGB(237, 229, 107);
    }else if(number < 0.6){
        color = RGB(237, 14, 72);
    }
    
    [self.circleChart removeFromSuperview];
    self.circleChart = [[PNCircleChart alloc]initWithFrame:CGRectMake(0,0, _v_bg.frame.size.width-10, _v_bg.frame.size.width-10) total:@100 current:[NSNumber numberWithFloat:number*100] clockwise:YES shadow:YES shadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.center = CGPointMake(_v_bg.frame.size.width/2, _v_bg.frame.size.width/2);
    [self.circleChart setStrokeColor:color];
    //[self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
    [self.circleChart setLineWidth:@10];
    [self.circleChart strokeChart];
    [_v_bg addSubview:self.circleChart];
    
}

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


-(void)loadUI{

    _v_bg.layer.cornerRadius = _v_bg.frame.size.width/2;
    _v_bg.layer.masksToBounds = YES;
    _v_bg.layer.borderWidth = 1.0f;
    _v_bg.layer.borderColor = [RGB(45, 169, 238) CGColor];
    
    _imageV_bg.layer.cornerRadius = _imageV_bg.frame.size.width/2;
    _imageV_bg.layer.masksToBounds = YES;
   
    
    [self reloadData];

}

+(NSString*) convertStringFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}

-(void)reloadData{
    DateDatasRequest *request = [[DateDatasRequest alloc]init];
    request.page = @1;
    request.mid = [ShareValue sharedShareValue].member.mid;
    __weak __typeof(self) weakSelf = self;
    [DataAPI dateDatasWithRequest:request completionBlockWithSuccess:^(NSArray *datas) {
        [DataTools sharedDataTools].dateDatas = datas;
        [NotificationCenter postNotificationName:NOTIFICATION_DATACHANGE object:nil];
        DateMonidata *dateMonidata = [datas firstObject];
        Monidata *monidata = dateMonidata.bestMonidata;
            if ([dateMonidata.saveDate isEqual:[PEFFirstVC convertStringFromDate:[NSDate date]]]) {
                weakSelf.lb_pef.text = [NSString stringWithFormat:@"PEF值:%@",monidata.pef ];
                weakSelf.lb_info.text = @"PEF值最佳状态";
                weakSelf.lb_state.text = monidata.stateString;
                if ([monidata.level integerValue] == 1) {
                    weakSelf.lb_state.textColor = RGB(33, 211, 58);
                }else  if ([monidata.level integerValue] == 2) {
                    weakSelf.lb_state.textColor = RGB(237, 229, 107);
                }else  if ([monidata.level integerValue] == 3) {
                    weakSelf.lb_state.textColor = RGB(237, 14, 72);
                }
                float value =  [monidata.pef floatValue] / [[ShareValue sharedShareValue].member.defPef floatValue];
                
                [weakSelf loadCircleChart:value];
                [self loadPrecentView:value];
            }else{
                _lb_info.text = @"您今天还没测试呼吸哦";
                [self loadCircleChart:0];
                [self loadPrecentView:0];
            }
        
    } Fail:^(int code, NSString *failDescript) {
        _lb_info.text = @"您今天还没测试呼吸哦";
        
        [self loadCircleChart:0];
    }];
}

/*
-(void)commitData:(float)t_state showHud:(ShowHUD *)hud{

    DataCommitRequest *t_request = [[DataCommitRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    t_request.pef = @([TestTool sharedTestTool].pef);
    t_request.fev1 = @([TestTool sharedTestTool].fev1);
    t_request.fvc = @([TestTool sharedTestTool].fvc);
    __weak __typeof(self) weak = self;
    [DataAPI dataCommitWithRequest:t_request completionBlockWithSuccess:^(Monidata *data) {
        [hud hide];
        [weak reloadData];
    } Fail:^(int code, NSString *failDescript) {
        [hud hide];
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}

 */

#pragma mark - buttonAction

- (IBAction)testAcion:(id)sender {
    [self startListening];
    if (![DeviceHelper sharedDeviceHelper].isConnected) {
        [[DeviceHelper sharedDeviceHelper]scan];
        _hud = [ShowHUD showText:@"正在搜索设备，请确定设备已打开" configParameter:^(ShowHUD *config) {
        } inView:self.view];
    }else{
        _hud = [ShowHUD showText:@"请对设备呼气" configParameter:^(ShowHUD *config) {
        } inView:self.view];
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

-(void)deviceFound:(NSNotification *)notification{
    _hud.text = @"发现设备正在连接...";
    [[DeviceHelper sharedDeviceHelper]connectDeviceByName:[DeviceHelper sharedDeviceHelper].deviceNames.firstObject];
}


-(void)deviceConneted:(NSNotification *)notification{
    _hud.text = @"设备已连接，等待用户呼气...";
}

-(void)dataUpdate:(NSNotification *)notification{
    _hud.text = @"监测到用户呼气，请稍候...";
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

-(void)powerLow:(NSNotification *)notification{
    [ShowHUD showError:@"监测到用户呼气，请稍候..." configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:self.view];
}

-(void)connectTimeout:(NSNotification *)notification{
    [ShowHUD showError:@"连接超时，请确定设备已打开" configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:self.view];
}

-(void)startListening{
    [self stopListening];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceFound:) name:BLE_DEVICE_FOUND object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataUpdate:) name:BLE_UPDATE_DATA object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConneted:) name:BLE_DEVICE_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(powerLow:) name:BLE_POWERLOW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectTimeout:) name:BLE_CONNET_TIMEOUT object:nil];
}

-(void)stopListening{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
