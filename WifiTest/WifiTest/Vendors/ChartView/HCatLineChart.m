//
//  HCatLineChart.m
//  ChartTest
//
//  Created by Hcat on 15/8/5.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "HCatLineChart.h"
#import "HCatChartLabel.h"


#define HCatYLabelwidth   30 //纵坐标数值的宽度
#define HCatLabelHeight   10 //纵坐标高度
#define HCatTagLabelwidth     80

@interface HCatLineChart()

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation HCatLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    
    for (NSArray * ary in yLabels) {
        
        for (NSString *valueString in ary) {
            
            NSInteger value = [valueString integerValue];
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
        
        _yValueMin = min;
        
    }else{
        
        _yValueMin = min;
        
    }
    
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
        
    }
    
    float level = (_yValueMax-_yValueMin) /4.0;
    
    CGFloat chartCavanHeight = self.frame.size.height - HCatLabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<4; i++) {
        HCatChartLabel * label = [[HCatChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight-0.5*levelHeight, HCatYLabelwidth, 20)];
        label.font = [UIFont boldSystemFontOfSize:12.0f];
        NSString *t_string;
        if (i == 0) {
            t_string = @"危险";
        }else if(i == 1){
            t_string = @"差";
        }else if(i == 2){
            t_string = @"一般";
        }else if(i == 3){
            t_string = @"良好";
        }
        
        label.text = t_string;
        [self addSubview:label];
    }
    
    //画横线
    for (int i=0; i<4; i++) {
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(HCatYLabelwidth,HCatLabelHeight+i*levelHeight)];
        [path addLineToPoint:CGPointMake(self.frame.size.width,HCatLabelHeight+i*levelHeight)];
        [path addLineToPoint:CGPointMake(self.frame.size.width,HCatLabelHeight+(i+1)*levelHeight)];
        [path addLineToPoint:CGPointMake(HCatYLabelwidth,HCatLabelHeight+(i+1)*levelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        
        if (i == 0) {
            shapeLayer.fillColor = [HCatLightGreen CGColor];
        }else if(i == 1){
            shapeLayer.fillColor = [HCatStarYellow CGColor];
            
        }else if(i == 2){
            shapeLayer.fillColor = [[UIColor orangeColor] CGColor];
        }else if(i == 3){
            shapeLayer.fillColor = [HCatRed CGColor];
        }
       // shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
        
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(HCatYLabelwidth, 0, self.frame.size.width-HCatYLabelwidth, self.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    
    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - HCatYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        HCatChartLabel * label = [[HCatChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, self.frame.size.height - HCatLabelHeight, _xLabelWidth, HCatLabelHeight)];
        label.text = labelText;
        [_scrollView addSubview:label];
    }
    
    float max = [xLabels count] *_xLabelWidth;
    if (_scrollView.frame.size.width < max) {
        _scrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }

    
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart{
    
    for (int i = 0; i < _yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        
        if (childAry.count==0) {
            return;
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [_scrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = _xLabelWidth/2.0;
        CGFloat chartCavanHeight = self.frame.size.height - HCatLabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin); //比例
        
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+HCatLabelHeight)
                 index:i
                isShow:_isShowTag
                 value:firstValue];

        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+HCatLabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+HCatLabelHeight);
                [progressline addLineToPoint:point];
                
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:_isShowTag
                         value:[valueString floatValue]];
                
                //                [progressline stroke];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [HCatGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
        
    }


}


- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isShowTag value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 6, 6)];
    view.center = point;
    //view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1.5;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:HCatGreen.CGColor;
    
    //view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:HCatGreen;
    view.backgroundColor = [UIColor whiteColor];
    if (isShowTag) {
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:HCatGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-HCatTagLabelwidth/2.0, point.y-HCatLabelHeight*2, HCatTagLabelwidth, HCatLabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [_scrollView addSubview:label];
    }
    
    [_scrollView addSubview:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
