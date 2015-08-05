//
//  HCatChart.h
//  ChartViewTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCatBarChart.h"
#import "HCatLineChart.h"
#import "HCatColor.h"


//类型
typedef enum {
    ChartLineStyle, //线
    ChartBarStyle //柱状图
} ChartStyle;

@class HCatChart;

@protocol HCatChartDataSource <NSObject>

//横坐标标题数组
- (NSArray *)HCatChart_xLableArray:(HCatChart *)chart;

//数值多重数组
- (NSArray *)HCatChart_yValueArray:(HCatChart *)chart;



@optional
//选择柱状图反应
- (void)ClickedOnBarAtIndex:(NSInteger)barIndex;

//颜色数组
- (NSArray *)HCatChart_ColorArray:(HCatChart *)chart;

//显示数值范围
- (CGRange)HCatChartChooseRangeInLineChart:(HCatChart *)chart;


@end



@interface HCatChart : UIView

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;
@property (nonatomic,strong) UIColor *barStorkColor;
@property (nonatomic,assign) float chartMargin; //柱状图之间的间隔

@property (assign) ChartStyle chartStyle;

-(id)initwithHCatChartDataFrame:(CGRect)rect withSource:(id<HCatChartDataSource>)dataSource withStyle:(ChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;


@end
