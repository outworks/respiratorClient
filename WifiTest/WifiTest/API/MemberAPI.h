//
//  MemberAPI.h
//  WifiTest
//
//  Created by Hcat on 15/6/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface MemberLoginRequest : BaseRequest

@property(nonatomic,strong)NSString *username;//	String	IN	Y	用户名
@property(nonatomic,strong)NSString *pwd;//	String	IN	Y	密码

@end


@interface MemberRegisterRequest : BaseRequest

@property(nonatomic,strong)NSString *username;//	String	IN	Y	用户名
@property(nonatomic,strong)NSString *pwd;//	String	IN	Y	密码

@end


@interface MemberUpdateRequest : BaseRequest

@property(nonatomic,strong)NSNumber *mid;//	String	IN	Y	用户名
@property(nonatomic,strong)NSString *nickname;//	String	IN	Y	昵称
@property(nonatomic,strong)NSNumber * sex;//        int         性别（0:男  1:女）
@property(nonatomic,strong)NSString * birthday;//	String		生日(yyyy-MM-dd)
@property(nonatomic,strong)NSNumber * height;//     float		身高（单位:厘米）
@property(nonatomic,strong)NSNumber * weight;//

@end



@interface MemberAPI : BaseAPI

/**
 *  登入
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)MemberLoginWithRequest:(MemberLoginRequest *)request completionBlockWithSuccess:(void(^)(Member *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  注册
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)MemberRegisterWithRequest:(MemberRegisterRequest *)request completionBlockWithSuccess:(void(^)(void))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


/**
 *  用户信息修改
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)MemberUpdateWithRequest:(MemberUpdateRequest *)request completionBlockWithSuccess:(void(^)(Member *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;


@end
