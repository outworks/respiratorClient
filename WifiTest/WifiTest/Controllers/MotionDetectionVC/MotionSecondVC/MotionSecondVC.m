//
//  MotionSecondVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/3.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "MotionSecondVC.h"
#import "DataTools.h"

@interface MotionSecondVC ()<HCatChartDataSource>

@property (weak, nonatomic) IBOutlet UIView *v_barChart;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_fvc;
@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (nonatomic,strong) HCatChart * chartView; //图表
@property (nonatomic,strong) NSMutableArray *mutArr;

@end

@implementation MotionSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [NotificationCenter addObserver:self selector:@selector(loadBarChart) name:NOTIFICATION_DATACHANGE object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private methods 

-(void)loadData{
    
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
}



-(void)loadBarChart{
    
    [self loadData];

    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    
    _chartView = [[HCatChart alloc]initwithHCatChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, _v_barChart.frame.size.height-20)
                                                   withSource:self
                                                    withStyle:ChartBarStyle];
    _chartView.barStorkColor = [UIColor grayColor];
    _chartView.chartMargin = 10.0f;
    [_chartView showInView:_v_barChart];


}


#pragma mark - HCatChartDataSource

//横坐标标题数组
- (NSArray *)HCatChart_xLableArray:(HCatChart *)chart{
    
    NSMutableArray *t_dateArr = [NSMutableArray array];
    
    for (int i = 0; i < [_mutArr count]; i++) {
        Monidata *t_monidata = _mutArr[i];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date= [dateFormatter dateFromString:t_monidata.saveTime];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *t_dateStr = [dateFormatter stringFromDate:date];
        [t_dateArr addObject:t_dateStr];
    }
//    NSArray *ary1 = @[@"11:30",@"11:31",@"11:32",@"11:33",@"11:34",@"11:35",@"11:36",@"11:37",@"11:38"];
    return t_dateArr;
}

//数值多重数组
- (NSArray *)HCatChart_yValueArray:(HCatChart *)chart{
    
    NSMutableArray *t_dataArr = [NSMutableArray array];
    
    for (int i = 0; i < [_mutArr count]; i++) {
        Monidata *t_monidata = _mutArr[i];
        [t_dataArr addObject:t_monidata.fvc];
    }
    
    return @[t_dataArr];
    
//    NSArray *ary1 = @[@"122",@"324",@"215",@"310",@"242",@"177",@"143",@"177",@"143"];
//    NSArray *ary2 = @[@"176",@"234",@"354",@"223",@"406",@"332",@"217",@"406",@"332"];
//    return @[ary1,ary2];
    //return @[ary1];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)HCatChart_ColorArray:(HCatChart *)chart
{
    return @[HCatGreen,HCatBrown,HCatBrown];
}


- (void)ClickedOnBarAtIndex:(NSInteger)barIndex{
    NSLog(@"Click on bar %@", @(barIndex));
    
    Monidata *t_monidata = _mutArr[barIndex];
    _lb_fvc.text = [t_monidata.fvc stringValue];
    _lb_time.text = t_monidata.saveTime;
    _lb_state.text = t_monidata.stateString;

}

#pragma mark - dealloc 

-(void)dealloc{
    [NotificationCenter removeObserver:self];
    NSLog(@"MotionSecondVC dealloc");
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
