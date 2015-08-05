//
//  HCatBar.m
//  ChartViewTest
//
//  Created by nd on 15/8/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HCatBar.h"
#import "HCatColor.h"

@implementation HCatBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
        self.clipsToBounds      = YES;
        [self.layer addSublayer:_chartLine];
        self.barRadius = 2.0;
    }
    
    return self;
}



#pragma mark - set

-(void)setBarRadius:(CGFloat)barRadius
{
    _barRadius = barRadius;
    self.layer.cornerRadius = _barRadius;
}

- (void)setGrade:(float)grade
{
    CGFloat startPosY = (1 - grade) * self.frame.size.height;
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width / 2.0, startPosY)];
    
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    
    
    if (_barColor) {
        _chartLine.strokeColor = [_barColor CGColor];
    }
    else {
        _chartLine.strokeColor = [HCatGreen CGColor];
    }
    
    if (_grade) {
        
        CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id)_chartLine.path;
        pathAnimation.toValue = (id)[progressline CGPath];
        pathAnimation.duration = 0.5f;
        pathAnimation.autoreverses = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_chartLine addAnimation:pathAnimation forKey:@"animationKey"];
        
        _chartLine.path = progressline.CGPath;
        
        if (_barColorGradientStart) {
            
            // Add gradient
            [self.gradientMask addAnimation:pathAnimation forKey:@"animationKey"];
            self.gradientMask.path = progressline.CGPath;
            
        }
        
    }else{
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
        _chartLine.path = progressline.CGPath;
        // Check if user wants to add a gradient from the start color to the bar color
        if (_barColorGradientStart) {
            
            // Add gradient
            self.gradientMask = [CAShapeLayer layer];
            self.gradientMask.fillColor = [[UIColor clearColor] CGColor];
            self.gradientMask.strokeColor = [[UIColor blackColor] CGColor];
            self.gradientMask.lineWidth    = self.frame.size.width;
            self.gradientMask.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.gradientMask.path = progressline.CGPath;
            
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.startPoint = CGPointMake(0.0,0.0);
            gradientLayer.endPoint = CGPointMake(1.0 ,0.0);
            gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            UIColor *middleColor = [UIColor colorWithWhite:255/255 alpha:0.8];
            NSArray *colors = @[
                                (__bridge id)self.barColor.CGColor,
                                (__bridge id)middleColor.CGColor,
                                (__bridge id)self.barColor.CGColor
                                ];
            gradientLayer.colors = colors;
            
            [gradientLayer setMask:self.gradientMask];
            
            [_chartLine addSublayer:gradientLayer];
            
            self.gradientMask.strokeEnd = 1.0;
            [self.gradientMask addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            
        }
    }
    
    _grade = grade;
    
}


- (void)setBarColorGradientStart:(UIColor *)barColorGradientStart
{
    // Set gradient color, remove any existing sublayer first
    for (CALayer *sublayer in [_chartLine sublayers]) {
        [sublayer removeFromSuperlayer];
    }
    _barColorGradientStart = barColorGradientStart;
    
    [self setGrade:_grade];
    
}


#pragma mark - private methods

- (void)rollBack
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations: ^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
}

#pragma mark - drawRect

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
 CGContextFillRect(context, rect);
    
}


@end
