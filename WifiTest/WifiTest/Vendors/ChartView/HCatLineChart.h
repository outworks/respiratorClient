//
//  HCatLineChart.h
//  ChartTest
//
//  Created by Hcat on 15/8/5.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCatColor.h"

@interface HCatLineChart : UIView

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;
@property (nonatomic, assign) BOOL isShowTag;


-(void)strokeChart;

@end
