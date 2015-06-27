//
//  DataAPI.h
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monidata.h"
#import "DateMonidata.h"

@interface DataCommitRequest : BaseRequest

@property(nonatomic,strong)NSNumber *mid;       //	Long	IN	Y	用户编号(登录用户)
@property(nonatomic,strong)NSNumber *pef;       //	Int	IN	Y	pef
@property(nonatomic,strong)NSNumber *fev1;      //	Float	IN	Y	Fev1
@property(nonatomic,strong)NSNumber *fvc;       //	Int	IN	Y	组织架构编码
@property(nonatomic,strong)NSNumber *level;     //	Int	IN	N	数据状态  0:良好  1:正常  2:危险 (根据计算工式，不传由服务端计算)

@end


@interface DateDatasRequest : BaseRequest

@property(nonatomic,strong)NSNumber *mid;        //	Long	IN	Y	用户编号(登录用户)
@property(nonatomic,strong)NSNumber *page;       //	Int 	IN	N	当前页
@property(nonatomic,strong)NSNumber *pagesize;   //	Int	IN	N	每页条数（不传默认为7）

@end


@interface DataAPI : BaseAPI

/**
 *  数据提交
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)dataCommitWithRequest:(DataCommitRequest *)request completionBlockWithSuccess:(void(^)(Monidata *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

/**
 *  按日查询监测数据
 *
 *  @param params 参数
 *  @param sucess 成功block
 *  @param fail   失败block
 */
+(void)dateDatasWithRequest:(DateDatasRequest *)request completionBlockWithSuccess:(void(^)(NSArray *))sucess  Fail:(void(^)(int code,NSString *failDescript))fail;

@end
