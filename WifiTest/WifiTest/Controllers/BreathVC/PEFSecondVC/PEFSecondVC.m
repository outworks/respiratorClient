//
//  PEFSecondVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "PEFSecondVC.h"
#import "ShareValue.h"
#import "DataAPI.h"
#import "NoticeMacro.h"
#import "UtilsMacro.h"
#import "DataTools.h"

@interface PEFSecondVC ()


@property (weak, nonatomic) IBOutlet UIView *v_barChart;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_pef;
@property (weak, nonatomic) IBOutlet UILabel *lb_fev1;
@property (weak, nonatomic) IBOutlet UILabel *lb_fvc;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic,strong) NSMutableArray *mutArr;

@end

@implementation PEFSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [NotificationCenter addObserver:self selector:@selector(loadBarChart) name:NOTIFICATION_DATACHANGE object:nil];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private

-(void)loadBarChart{
    
    [self.barChart removeFromSuperview];
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, _v_barChart.frame.size.height)];
    self.barChart.center = CGPointMake(ScreenWidth/2, _v_barChart.frame.size.height/2);
    
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%0.f",yValueParsed];
        return labelText;
    };
    
    _mutArr = [NSMutableArray array];
    NSArray *_data = [DataTools sharedDataTools].dateDatas;
    if (_data.count==0) {
        return;
    }
    for (int i = 0; i < [_data count]; i++) {
        
        if (i == 0) {
            DateMonidata *t_dateMonidata = [_data objectAtIndex:i];
            for (int j = 0; j < [t_dateMonidata.dataDetails count]; j++) {
                Monidata *t_monidata = t_dateMonidata.dataDetails[j];
                [_mutArr addObject:t_monidata];
            }
        }
        
    }
    
    NSMutableArray *t_dateArr = [NSMutableArray array];
    NSMutableArray *t_dataArr = [NSMutableArray array];
    NSMutableArray *t_colorArr = [NSMutableArray array];
    
    for (int i = 0; i < [_mutArr count]; i++) {
        Monidata *t_monidata = _mutArr[i];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date= [dateFormatter dateFromString:t_monidata.saveTime];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *t_dateStr = [dateFormatter stringFromDate:date];
        [t_dateArr addObject:t_dateStr];
        [t_dataArr addObject:t_monidata.pef];
        
        if ([t_monidata.level isEqualToNumber:@0]) {
            [t_colorArr addObject:RGB(33, 211, 58)];
        }else if ([t_monidata.level isEqualToNumber:@1]) {
            [t_colorArr addObject:[UIColor greenColor]];
        }else if ([t_monidata.level isEqualToNumber:@2]) {
            [t_colorArr addObject:RGB(237, 229, 107)];
        }else if ([t_monidata.level isEqualToNumber:@3]){
            [t_colorArr addObject:RGB(237, 14, 72)];
        }
    }

    self.barChart.yMaxValue = [[ShareValue sharedShareValue].member.defPef floatValue];
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    [self.barChart setXLabels:t_dateArr];
    [self.barChart setYValues:t_dataArr];
    [self.barChart setStrokeColors:t_colorArr];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    
    [self.barChart strokeChart];
    
    self.barChart.delegate = self;
    
    [_v_barChart addSubview:self.barChart];
    
    [self userClickedOnBarAtIndex:0];
    
}

#pragma mark - PNChartDelegate

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
    Monidata *t_monidata = _mutArr[barIndex];
    _lb_pef.text = [t_monidata.pef stringValue];
    _lb_fev1.text = [t_monidata.fev1 stringValue];
    _lb_fvc.text = [t_monidata.fvc stringValue];    
    _lb_time.text = t_monidata.saveTime;
    _lb_state.text = t_monidata.stateString;

    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
    
}


#pragma mark - dealloc

-(void)dealloc{
    [NotificationCenter removeObserver:self];
    NSLog(@"MotionThirdVC dealloc");
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
