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


+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo{



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