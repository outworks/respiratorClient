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

// 处理收到的APNS消息
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

+ (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant;


@end

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end