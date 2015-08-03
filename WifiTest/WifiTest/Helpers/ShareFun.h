//
//  ShareFun.h
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareFun : NSObject

//获取版本号
+(NSString *)getVerison;
+ (BOOL) validateEmail: (NSString *) candidate; //验证邮箱的有效性
+ (BOOL) validatePhone: (NSString *) phone; //验证手机号码的有效性

+ (UIImage *) getUIImagewithColor:(UIColor *)color withSize:(CGSize)size;
+ (void) getCorner:(id)sender;
+ (void) getCorner:(id)sender withCorner:(float)corner withBorderWidth:(float)borderWidth withBorderColor:(UIColor *)borderColor;
+ (void) getCorner:(id)sender withBorderWidth:(float)borderWidth withBorderColor:(UIColor *)borderColor;

+(NSString*) convertStringFromDate:(NSDate*)date;


// 处理收到的APNS消息
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

+ (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant;


@end

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end