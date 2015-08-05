//
//  HCatColor.m
//  ChartViewTest
//
//  Created by nd on 15/8/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "HCatColor.h"

@implementation HCatColor

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
