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

@interface PEFSecondVC ()


@property (weak, nonatomic) IBOutlet UIView *v_barChart;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_pef;
@property (weak, nonatomic) IBOutlet UILabel *lb_fev1;
@property (weak, nonatomic) IBOutlet UILabel *lb_fvc;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *mutArr;

@end

@implementation PEFSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray array];
    [self loadDateMonidata];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private 

-(void)loadDateMonidata{
    
    __weak typeof(self) weakSelf = self;
    
    DateDatasRequest *t_request = [[DateDatasRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    [DataAPI dateDatasWithRequest:t_request completionBlockWithSuccess:^(NSArray *data) {
        
        [weakSelf.data addObjectsFromArray:data];
        
        [weakSelf loadBarChart];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];
}


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
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *t_dateStr = [dateFormatter stringFromDate:date];
    
        NSArray *t_date_Arr = [t_dateStr componentsSeparatedByString:@"-"];
        NSString *destDateString = [NSString stringWithFormat:@"%@/%@",t_date_Arr[1],t_date_Arr[2]];
        [t_dateArr addObject:destDateString];
        [t_dataArr addObject:t_monidata.pef];
        
        if ([t_monidata.level isEqualToNumber:@0]) {
            [t_colorArr addObject:PNGreen];
        }else if ([t_monidata.level isEqualToNumber:@1]) {
            [t_colorArr addObject:PNYellow];
        }else if ([t_monidata.level isEqualToNumber:@2]) {
            [t_colorArr addObject:PNRed];
        }else{
            [t_colorArr addObject:PNRed];
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
    if ([t_monidata.level isEqualToNumber:@0]) {
        _lb_state.text = @"良好";
    }else if ([t_monidata.level isEqualToNumber:@1]) {
        _lb_state.text = @"正常";
    }else if ([t_monidata.level isEqualToNumber:@2]) {
        _lb_state.text = @"危险";
    }

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
