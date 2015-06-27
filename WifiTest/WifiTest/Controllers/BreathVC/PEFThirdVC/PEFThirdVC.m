//
//  PEFThirdVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "PEFThirdVC.h"
#import "ShareValue.h"
#import "DataAPI.h"

@interface PEFThirdVC ()<PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property(nonatomic,strong) NSMutableArray *arr_data;
@property(nonatomic,strong) NSMutableArray *arr_motidatas;

@property (nonatomic) PNLineChart * lineChart;

@end

@implementation PEFThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr_data = [NSMutableArray array];
    _arr_motidatas = [NSMutableArray array];
    [self loadDateMonidata];
    [self loadLineChart];
}

#pragma mark - buttonAction 

- (IBAction)pefAction:(id)sender {
    
    _lb_title.text = @"PEF量测记录";
    
    NSMutableArray *t_dataArr = [NSMutableArray array];
    for (int i = 0; i < [_arr_motidatas count]; i++) {
        Monidata *t_monidata = _arr_motidatas[i];
       [t_dataArr addObject:t_monidata.pef];
    }
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *array = [t_dataArr sortedArrayUsingComparator:cmptr];
    NSNumber *max = [array lastObject];
    NSLog(@"%@",max);
    self.lineChart.yFixedValueMax = [max floatValue]*1.25;
    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = t_dataArr.count;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [t_dataArr[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    [self.lineChart updateChartData:@[data01]];
    
}


- (IBAction)fev1Action:(id)sender {
    
    _lb_title.text = @"FEV1量测记录";
    
    NSMutableArray *t_dataArr = [NSMutableArray array];
    for (int i = 0; i < [_arr_motidatas count]; i++) {
        Monidata *t_monidata = _arr_motidatas[i];
        [t_dataArr addObject:t_monidata.fev1];
        
    }
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *array = [t_dataArr sortedArrayUsingComparator:cmptr];
    NSNumber *max = [array lastObject];
    
    NSLog(@"%@",max);

    self.lineChart.yFixedValueMax = [max floatValue]*1.25;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = t_dataArr.count;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [t_dataArr[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    [self.lineChart updateChartData:@[data01]];

}


#pragma mark - private

-(void)loadLineChart{

    NSMutableArray *t_dateArr = [NSMutableArray array];
    NSMutableArray *t_dataArr = [NSMutableArray array];
    
    for (int i = 0; i < [_arr_motidatas count]; i++) {
        Monidata *t_monidata = _arr_motidatas[i];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date= [dateFormatter dateFromString:t_monidata.saveTime];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *t_dateStr = [dateFormatter stringFromDate:date];

        [t_dateArr addObject:t_dateStr];
        
    }
    

    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, _v_bg.frame.size.height-20)];
    self.lineChart.center = CGPointMake(ScreenWidth/2, _v_bg.frame.size.height/2);
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:t_dateArr];
    self.lineChart.showCoordinateAxis = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
//    self.lineChart.yFixedValueMax = 300.0;
    self.lineChart.yFixedValueMin = 0.0;
    
//    [self.lineChart setYLabels:@[
//                                 @"0 min",
//                                 @"50 min",
//                                 @"100 min",
//                                 @"150 min",
//                                 @"200 min",
//                                 @"250 min",
//                                 @"300 min",
//                                 ]
//     ];
    
    // Line Chart #1
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = PNLightBlue;
    data01.alpha = 1.f;
    data01.itemCount = t_dataArr.count;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [t_dataArr[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
    [_v_bg addSubview:self.lineChart];
}


-(void)loadDateMonidata{
    
    __weak typeof(self) weakSelf = self;
    
    DateDatasRequest *t_request = [[DateDatasRequest alloc] init];
    t_request.mid = [ShareValue sharedShareValue].member.mid;
    [DataAPI dateDatasWithRequest:t_request completionBlockWithSuccess:^(NSArray *data) {
        
        [weakSelf.arr_data addObjectsFromArray:data];
        
        for (int i = 0; i < [_arr_data count]; i++) {
            
            if (i == 0) {
                DateMonidata *t_dateMonidata = [_arr_data objectAtIndex:i];
                for (int j = 0; j < [t_dateMonidata.dataDetails count]; j++) {
                    Monidata *t_monidata = t_dateMonidata.dataDetails[j];
                    [_arr_motidatas addObject:t_monidata];
                }
            }
            
        }
        [self pefAction:nil];
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
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
