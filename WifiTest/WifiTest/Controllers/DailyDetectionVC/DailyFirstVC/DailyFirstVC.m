//
//  DailyFirstVC.m
//  WifiTest
//
//  Created by nd on 15/8/5.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DailyFirstVC.h"

#import "CCProgressView.h"
#import "PNChart.h"

#import "DataAPI.h"
#import "TestTool.h"
#import "DataTools.h"

@interface DailyFirstVC (){
    ShowHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UIView *v_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UILabel *lb_variability;

@property (weak, nonatomic) IBOutlet UILabel *lb_pefPercent;

@property (strong,nonatomic) CCProgressView *progress;
@property (nonatomic,strong) PNCircleChart * circleChart;

@end

@implementation DailyFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - loadUI

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


#pragma mark - private methods

- (void) initUI{
    
    [ShareFun getCorner:_v_bg withBorderWidth:1.0f withBorderColor:RGB(45, 169, 238)];
    [self reloadData];
}


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
            if ([monidata.level integerValue] == 0) {
                weakSelf.lb_state.textColor = RGB(33, 211, 58);
            }else  if ([monidata.level integerValue] == 1) {
                weakSelf.lb_state.textColor = RGB(237, 229, 107);
            }else  if ([monidata.level integerValue] == 2) {
                weakSelf.lb_state.textColor = RGB(237, 14, 72);
            }
            float value =  [monidata.pef floatValue] / [[ShareValue sharedShareValue].member.defPef floatValue];
            weakSelf.lb_variability.text =@"变异度:10%";
            weakSelf.lb_pefPercent.text = [NSString stringWithFormat:@"尖峰呼气流量百分比:%.1f%%",value*100];
            [weakSelf loadCircleChart:value];
            [self loadPrecentView:value];
        }else{
            _lb_info.text = @"您今天还没测试哦";
            [self loadCircleChart:0];
            [self loadPrecentView:0];
        }
        
    } Fail:^(int code, NSString *failDescript) {
        _lb_info.text = @"您今天还没测试哦";
        
        [self loadCircleChart:0];
    }];
}

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

#pragma mark - buttonAction

- (IBAction)testAcion:(id)sender {
    
    _hud = [ShowHUD showText:@"测试中.." configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    [[GCDQueue globalQueue] execute:^{
        
        [[TestTool sharedTestTool] test];
        
        NSLog(@"%f",[TestTool sharedTestTool].pef);
        NSLog(@"%f",[TestTool sharedTestTool].fvc);
        
        NSLog(@"%2f",[TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue]);
        [weakSelf commitData];
        
    }];
    
}

#pragma mark - dealloc 

-(void)dealloc{
    
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
