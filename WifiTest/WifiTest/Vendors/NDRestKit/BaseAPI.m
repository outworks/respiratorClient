//
//  BaseAPI.m
//  WifiTest
//
//  Created by Hcat on 15/6/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BaseAPI.h"
#import "AFNetworking.h"
#import "APIConfig.h"
#import "LK_NSDictionary2Object.h"
#import <objc/runtime.h>

@implementation BaseRequest

/**
 *  服务端地址
 *
 */
-(NSString *)_serverUrl{
    return URL_SERVER_BASE;
}

/**
 *  请求方法
 *
 */
-(NSString *)_method{
    return NDAPI_METHOD;
}

-(NSString *)_apiPath{
    return nil;
}

@end

@implementation BaseResult

@end


@interface BaseAPI(p)
+(AFHTTPClient *)client;
@end

@implementation BaseAPI

+(AFHTTPClient *)client{
    static dispatch_once_t onceToken;
    static AFHTTPClient *_client;
    dispatch_once(&onceToken, ^{
        _client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:URL_SERVER_BASE]];
    });
    return _client;
}

+(AFHTTPClient *)clientByRequest:(BaseRequest *)request{
    if ([request._serverUrl isEqual:URL_SERVER_BASE]) {
        return [BaseAPI client];
    }
    return [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:request._serverUrl]];
}

+(NSString *)getFailDescriptByErrorCode:(int)errorCode{
    NSString *failDescription = @"";
    switch (errorCode) {
        case 101:
            failDescription = @"";
            break;
        default:
            break;
    }
    return failDescription;
}

+(void)request:(BaseRequest *)request resultClass:(Class)resultClass completionBlockWithSuccess:(void(^)(NSObject *result,NSString *message))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    NSDictionary *dict = request.lkDictionary;
    AFHTTPClient *client = [BaseAPI clientByRequest:request];
    NSString *path = [NSString stringWithFormat:@"%@%@",request._serverUrl,request._apiPath];
    
    NSURLRequest *urlRequest = [client requestWithMethod:request._method path:path  parameters:dict];
    AFHTTPRequestOperation *operation =
    [client HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            responseString  = [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
            NSLog(@"url:%@|response:%@",urlRequest.URL,responseString);
            NSError *error = nil;
            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
            if (dict) {
                BaseResult *response = [dict objectByClass:[BaseResult class]];
                if (!response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        fail(-1,@"服务器异常");
                    });
                    return ;
                }
                if (response.code != SUCCESS_CODE) {
                    NSString *errorMessage = [self getFailDescriptByErrorCode:response.code];
                    NSString *message = response.msg;
                    if (errorMessage.length == 0) {
                        errorMessage = message;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        fail(response.code,errorMessage);
                    });
    
                    return;
                }
                
                if([response.data isKindOfClass:[NSArray class]]){
                    NSMutableArray *results = [NSMutableArray array];
                    for (NSDictionary *dic in (NSArray *)response.data) {
                        NSObject *obj = [dic objectByClass:resultClass];
                        [results addObject:obj];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sucess(results,response.msg);
                    });
                    
                }else if([response.data isKindOfClass:[NSDictionary class]]){
                    NSDictionary *dic = (NSDictionary *)response.data;
                    NSObject *obj = [dic objectByClass:resultClass];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sucess(obj,response.msg);
                    });
                }else{
                    sucess(nil,response.msg);
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(-1,@"服务器异常");
                });
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"url:%@,fail:%@",urlRequest.URL,[error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(-1,@"网络不给力");
        });
    }];
    [client enqueueHTTPRequestOperation:operation];


}

@end
