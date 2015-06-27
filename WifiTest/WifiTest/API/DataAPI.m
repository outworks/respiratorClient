//
//  DataAPI.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DataAPI.h"


@implementation DataCommitRequest

-(NSString *)_apiPath{
    return URL_DATA_COMMIT;
}

@end

@implementation DateDatasRequest

-(NSString *)_apiPath{
    return URL_DATA_DATAS;
}

@end

#pragma mark - API

@implementation DataAPI

/**
 *  数据提交
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)dataCommitWithRequest:(DataCommitRequest *)request completionBlockWithSuccess:(void(^)(Monidata *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{
    
    [self request:request resultClass:[Monidata class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        Monidata *data = (Monidata *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];
    
}

/**
 *  按日查询监测数据
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)dateDatasWithRequest:(DateDatasRequest *)request completionBlockWithSuccess:(void(^)(NSArray *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail{


    [self request:request resultClass:[DateMonidata class] completionBlockWithSuccess:^(NSObject *result, NSString *message) {
        NSArray *data = (NSArray *)result;
        sucess(data);
    } Fail:^(int code, NSString *failDescript) {
        fail(code,failDescript);
    }];

}

@end
