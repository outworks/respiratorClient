//
//  ShareFun.m
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "ShareFun.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ShareFun

+(NSString *)getVerison{
//    NSString * verison = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * verison = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return verison;
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) validatePhone: (NSString *) phone{
    NSString *phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    return [numberPre evaluateWithObject:phone];
}


+ (UIImage *) getUIImagewithColor:(UIColor *)color withSize:(CGSize) size{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

+ (void) getCorner:(id)sender{
    [ShareFun getCorner:sender withBorderWidth:0.5f withBorderColor:RGB(45, 169, 238)];
}

+ (void) getCorner:(id)sender withCorner:(float)corner withBorderWidth:(float)borderWidth withBorderColor:(UIColor *)borderColor{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton * t_btn = (UIButton *)sender;
        t_btn.layer.cornerRadius = corner;
        t_btn.layer.masksToBounds = YES;
        t_btn.layer.borderWidth = borderWidth;
        t_btn.layer.borderColor = [borderColor CGColor];
    }else if([sender isKindOfClass:[UIImageView class]]){
        UIImageView * t_imageV = (UIImageView *)sender;
        t_imageV.layer.cornerRadius = corner;
        t_imageV.layer.masksToBounds = YES;
        t_imageV.layer.borderWidth = borderWidth;
        t_imageV.layer.borderColor = [borderColor CGColor];
        
    }else if([sender isKindOfClass:[UIView class]]){
        UIView * t_view = (UIImageView *)sender;
        t_view.layer.cornerRadius = corner;
        t_view.layer.masksToBounds = YES;
        t_view.layer.borderWidth = borderWidth;
        t_view.layer.borderColor = [borderColor CGColor];
        
    }

}


+ (void) getCorner:(id)sender withBorderWidth:(float)borderWidth withBorderColor:(UIColor *)borderColor {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton * t_btn = (UIButton *)sender;
        t_btn.layer.cornerRadius = t_btn.frame.size.width/2;
        t_btn.layer.masksToBounds = YES;
        t_btn.layer.borderWidth = borderWidth;
        t_btn.layer.borderColor = [borderColor CGColor];
    }else if([sender isKindOfClass:[UIImageView class]]){
        UIImageView * t_imageV = (UIImageView *)sender;
        t_imageV.layer.cornerRadius = t_imageV.frame.size.width/2;
        t_imageV.layer.masksToBounds = YES;
        t_imageV.layer.borderWidth = borderWidth;
        t_imageV.layer.borderColor = [borderColor CGColor];
    
    }else if([sender isKindOfClass:[UIView class]]){
        UIView * t_view = (UIImageView *)sender;
        t_view.layer.cornerRadius = t_view.frame.size.width/2;
        t_view.layer.masksToBounds = YES;
        t_view.layer.borderWidth = borderWidth;
        t_view.layer.borderColor = [borderColor CGColor];
        
    }

}

+(NSString*) convertStringFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo{



}


+(void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr2 multiplier:1.0 constant:constant]];
}

@end




@implementation NSString (md5)

-(NSString *) md5HexDigest

{
    
    const char *original_str = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
    
}

@end