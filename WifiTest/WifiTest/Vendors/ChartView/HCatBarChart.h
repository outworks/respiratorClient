//
//  HCatBarChart.h
//  ChartViewTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCatColor.h"

@protocol HCatBarChartDelegate <NSObject>

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex;

@end


@interface HCatBarChart : UIView

@property (weak,nonatomic) id<HCatBarChartDelegate>delegate;

@property (strong, nonatomic) NSArray * xLabels; //横坐标的值

@property (strong, nonatomic) NSArray * yLabels; //纵坐标的值

@property (strong, nonatomic) NSArray * yValues; //柱状图的值

@property (nonatomic, strong) NSArray * colors; //颜色

@property (nonatomic) CGFloat xLabelWidth; //横坐标的宽度
@property (nonatomic) CGFloat chartMargin; //柱状图间隔

@property (nonatomic) float yValueMax;
@property (nonatomic) float yValueMin;


@property (nonatomic,strong) UIColor *barStokeColor; // 柱状图背景颜色

@property (nonatomic, assign) BOOL showRange;  //是否显示范围

@property (nonatomic, assign) CGRange chooseRange; //设置选择范围


-(void)strokeChart;

@end
