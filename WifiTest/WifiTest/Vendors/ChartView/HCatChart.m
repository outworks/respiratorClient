//
//  HCatChart.m
//  ChartViewTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HCatChart.h"


@interface HCatChart()

@property(strong,nonatomic) HCatBarChart * barChart;
@property(strong,nonatomic) HCatLineChart *lineChart;
@property(weak,nonatomic) id<HCatChartDataSource> dataSource;

@end



@implementation HCatChart

-(id)initwithHCatChartDataFrame:(CGRect)rect withSource:(id<HCatChartDataSource>)dataSource withStyle:(ChartStyle)style{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = NO;
    }

    return self;
}

#pragma mark - private methods

-(void)showInView:(UIView *)view{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
    [self setUpChart];
    
}


#pragma mark - private methods 

-(void)setUpChart{

    if (self.chartStyle == ChartLineStyle) {
        if(!_lineChart){
            _lineChart = [[HCatLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_lineChart];
        }
        
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(HCatChartChooseRangeInLineChart:)]) {
            [_lineChart setChooseRange:[self.dataSource HCatChartChooseRangeInLineChart:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(HCatChart_ColorArray:)]) {
            [_lineChart setColors:[self.dataSource HCatChart_ColorArray:self]];
        }
       
    
        [_lineChart setYValues:[self.dataSource HCatChart_yValueArray:self]];
        [_lineChart setXLabels:[self.dataSource HCatChart_xLableArray:self]];
        [_lineChart setIsShowTag:NO];
        [_lineChart strokeChart];
        
    }else if (self.chartStyle == ChartBarStyle)
    {
        if (!_barChart) {
            self.barChart = [[HCatBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:self.barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(HCatChartChooseRangeInLineChart:)]) {
            [_barChart setChooseRange:[self.dataSource HCatChartChooseRangeInLineChart:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(HCatChart_ColorArray:)]) {
            [_barChart setColors:[self.dataSource HCatChart_ColorArray:self]];
        }
        [self.barChart setYValues:[self.dataSource HCatChart_yValueArray:self]];
        [self.barChart setChartMargin:_chartMargin];
        [self.barChart setXLabels:[self.dataSource HCatChart_xLableArray:self]];
        [self.barChart setBarStokeColor:_barStorkColor];
        [self.barChart setDelegate:(id<HCatBarChartDelegate>)self];
        
        [_barChart strokeChart];
    }

}


- (void)userClickedOnBarAtIndex:(NSInteger)barIndex{
    if ([self.dataSource respondsToSelector:@selector(ClickedOnBarAtIndex:)]) {
        [self.dataSource ClickedOnBarAtIndex:barIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
