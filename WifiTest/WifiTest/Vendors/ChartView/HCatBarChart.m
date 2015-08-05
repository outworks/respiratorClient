//
//  HCatBarChart.m
//  ChartViewTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HCatBarChart.h"
#import "HCatChartLabel.h"
#import "HCatBar.h"


#define HCatYLabelwidth   30 //纵坐标数值的宽度
#define HCatLabelHeight   10 //纵坐标高度

@interface HCatBarChart()

@property(nonatomic,strong) UIScrollView *scrollView;

@end


@implementation HCatBarChart

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - set

-(void)setYValues:(NSArray *)yValues{

    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels{

    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *value_n in ary) {
            NSInteger value = [value_n integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - HCatLabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<5; i++) {
        HCatChartLabel * label = [[HCatChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, HCatYLabelwidth, HCatLabelHeight)];
        label.text = [NSString stringWithFormat:@"%.1f",level * i+_yValueMin];
        [self addSubview:label];
    }

    //画纵坐标线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(HCatYLabelwidth,HCatLabelHeight)];
    [path addLineToPoint:CGPointMake(HCatYLabelwidth,self.frame.size.height-2*HCatLabelHeight)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 1.f;
    [self.layer addSublayer:shapeLayer];
    
}


-(void)setXLabels:(NSArray *)xLabels
{

    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(HCatYLabelwidth, 0, self.frame.size.width-HCatYLabelwidth, self.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    _xLabels = xLabels;
    
    NSInteger num;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    
    float companyWidth = _scrollView.frame.size.width/num;
    
    _xLabelWidth = companyWidth - _chartMargin;
    
    for (int i=0; i<xLabels.count; i++) {
        
        HCatChartLabel * label = [[HCatChartLabel alloc] initWithFrame:CGRectMake(((i+1)*_chartMargin + i * _xLabelWidth), self.frame.size.height - HCatLabelHeight, _xLabelWidth, HCatLabelHeight)];
        label.text = xLabels[i];
        label.tag = i+10000;
        [_scrollView addSubview:label];
    }
    
    float max = [xLabels count] *companyWidth + _chartMargin;
    if (_scrollView.frame.size.width < max) {
        _scrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
    
    //画横坐标线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(HCatYLabelwidth,self.frame.size.height-2*HCatLabelHeight)];
    [path addLineToPoint:CGPointMake(self.frame.size.width,self.frame.size.height-2*HCatLabelHeight)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 1;
    [self.layer addSublayer:shapeLayer];
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

#pragma mark - private methods

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - HCatLabelHeight*3;
    
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            
            HCatChartLabel*t_xLabel = (HCatChartLabel*)[_scrollView viewWithTag:j+10000];
            float t_xLabel_x =  t_xLabel.frame.origin.x;
            
            HCatBar * bar = [[HCatBar alloc] initWithFrame:CGRectMake((_yValues.count==1?t_xLabel_x+(0.1*_xLabelWidth):t_xLabel_x +(i+1)*_xLabelWidth * 0.25), HCatLabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.25), chartCavanHeight)];
            bar.backgroundColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:0.7f];
            bar.tag = i*100+j+1;
            
            bar.barColor = [_colors objectAtIndex:i];
            if (_barStokeColor) {
                bar.backgroundColor = _barStokeColor;
            }
            
            if (_yValues.count != 1) {
                bar.barRadius = 0.0f;
                bar.backgroundColor = [UIColor clearColor];
            }
            
            bar.grade = grade;
            [_scrollView addSubview:bar];
            
        }
        
    }
    
    NSArray *childAry = _yValues[0];
    
    for (int j=0; j<childAry.count; j++) {
       
        HCatChartLabel*t_xLabel = (HCatChartLabel*)[_scrollView viewWithTag:j+10000];
        float t_xLabel_x =  t_xLabel.frame.origin.x;
        
        UIButton *t_btn = [[UIButton alloc] initWithFrame:CGRectMake(t_xLabel_x, HCatLabelHeight, _xLabelWidth, chartCavanHeight)];
        t_btn.backgroundColor = [UIColor clearColor];
        t_btn.tag = j+1000;
        [t_btn addTarget:self action:@selector(userClickedOnBar:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:t_btn];
        
    }
    
    
}

-(void)userClickedOnBar:(id)sender{
    
    
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            HCatBar * bar = (HCatBar *)[_scrollView viewWithTag:i*100 +j+1];
            bar.backgroundColor = _barStokeColor;
            if (_yValues.count != 1) {
                bar.barRadius = 0.0f;
                bar.backgroundColor = [UIColor clearColor];
            }
        }
        
        HCatBar * bar = (HCatBar *)[_scrollView viewWithTag:i*100 +([sender tag]-1000+1)];
        bar.backgroundColor = [UIColor whiteColor];
        
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
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:[sender tag]-1000];
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
