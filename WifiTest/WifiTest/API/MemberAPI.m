//
//  MemberAPI.m
//  WifiTest
//
//  Created by Hcat on 15/6/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "MemberAPI.h"

@implementation MemberLoginRequest

-(NSString *)_apiPath{
    return URL_MEMBER_LOGIN;
}

@end

@implementation MemberRegisterRequest

-(NSString *)_apiPath{
    return URL_MEMBER_REGISTER;
}

@end

@implementation MemberUpdateRequest

-(NSString *)_apiPath{
    return URL_MEMBER_MEMBERUPDATE;
}

@end





@implementation MemberAPI

+(void)MemberLoginWithRequest:(MemberLoginRequest *)request completionBlockWithSuccess:(void(^)(Member *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    [self request:request resultClass:[Member class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Member *data = (Member *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

/**
 *  注册
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)MemberRegisterWithRequest:(MemberRegisterRequest *)request completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        sucess();
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
}

/**
 *  用户信息修改
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)MemberUpdateWithRequest:(MemberUpdateRequest *)request completionBlockWithSuccess:(void(^)(Member *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    [self request:request resultClass:[NSObject class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Member *data = (Member *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];



}

@end
