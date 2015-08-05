//
//  HCatBar.h
//  ChartViewTest
//
//  Created by nd on 15/8/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HCatBar : UIView

@property (nonatomic) float grade; //比例高度

@property (nonatomic,strong) CAShapeLayer * chartLine; //画柱状的layer

@property (nonatomic, strong) UIColor * barColor; //柱状的颜色
@property (nonatomic) CGFloat barRadius; //柱状圆角

@property (nonatomic, strong) UIColor *barColorGradientStart; //柱状的颜色渐变
@property (nonatomic, strong) CAShapeLayer *gradientMask; //柱状渐变掩膜

- (void)rollBack; // 清空纵坐标的颜色

@end
