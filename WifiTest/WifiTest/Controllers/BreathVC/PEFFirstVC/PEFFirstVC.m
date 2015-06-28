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

@interface PEFFirstVC ()

@property (weak, nonatomic) IBOutlet UIView *v_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UILabel *lb_pef;

@property (nonatomic) PNCircleChart * circleChart;


@end

@implementation PEFFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private 

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
//    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,0, _v_bg.frame.size.width-10, _v_bg.frame.size.width-10)
//                                                      total:@100
//                                                    current:[NSNumber numberWithFloat:number*100]
//                                                  clockwise:YES];
    self.circleChart = [[PNCircleChart alloc]initWithFrame:CGRectMake(0,0, _v_bg.frame.size.width-10, _v_bg.frame.size.width-10) total:@100 current:[NSNumber numberWithFloat:number*100] clockwise:YES shadow:YES shadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.center = CGPointMake(_v_bg.frame.size.width/2, _v_bg.frame.size.width/2);
    [self.circleChart setStrokeColor:color];
    //[self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
    [self.circleChart setLineWidth:@10];
    [self.circleChart strokeChart];
    [_v_bg addSubview:self.circleChart];
    
}

-(void)loadUI{

    _v_bg.layer.cornerRadius = _v_bg.frame.size.width/2;
    _v_bg.layer.masksToBounds = YES;
    _v_bg.layer.borderWidth = 1.0f;
    _v_bg.layer.borderColor = [RGB(45, 169, 238) CGColor];
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
            }else{
                _lb_info.text = @"您今天还没测试呼吸哦";
                [self loadCircleChart:0];
            }
        
    } Fail:^(int code, NSString *failDescript) {
        _lb_info.text = @"您今天还没测试呼吸哦";
        
        [self loadCircleChart:0];
    }];
}

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


#pragma mark - buttonAction

- (IBAction)testAcion:(id)sender {
    
    ShowHUD *hud = [ShowHUD showText:@"测试中.." configParameter:^(ShowHUD *config) {
    } inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    [[GCDQueue globalQueue] execute:^{
        
        [[TestTool sharedTestTool] test];
        
        NSLog(@"%f",[TestTool sharedTestTool].pef);
        NSLog(@"%f",[TestTool sharedTestTool].fvc);
       
        NSLog(@"%2f",[TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue]);
        float t_state = [TestTool sharedTestTool].pef/[[ShareValue sharedShareValue].member.defPef floatValue];
        if (t_state > 1) {
            t_state = 1;
        }
        [self commitData:t_state showHud:hud];
        
    }];
    
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
