//
//  BaseAPI.h
//  WifiTest
//
//  Created by Hcat on 15/6/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject



-(NSString *)_serverUrl;
-(NSString *)_method;
-(NSString *)_apiPath;

@end


@interface BaseResult : NSObject

@property(nonatomic,assign) int code;
@property(nonatomic,strong) NSString *msg;
@property(nonatomic,strong) NSObject *data;

@end



@interface BaseAPI : NSObject

/**
 *  向服务器发起请求
 *
 *  @param request 请求对象
 *  @param sucess 成功返回的Block
 *  @param fail 失败返回的Block
 *
 */
+(void)request:(BaseRequest *)request resultClass:(Class)resultClass completionBlockWithSuccess:(void(^)(NSObject *result,NSString *message))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
