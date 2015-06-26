//
//  Member.h
//  WifiTest
//
//  Created by Hcat on 15/6/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property(nonatomic,strong)NSNumber * mid ;//       Long		用户编号
@property(nonatomic,strong)NSString * username;//   String		用户名
@property(nonatomic,strong)NSString * nickname;//	String		姓名
@property(nonatomic,strong)NSNumber * sex;//        int         性别（0:男  1:女）
@property(nonatomic,strong)NSString * birthday;//	String		生日(yyyy-MM-dd)
@property(nonatomic,strong) NSNumber * age;//	年龄
@property(nonatomic,strong) NSNumber * height;//     float		身高（单位:厘米）
@property(nonatomic,strong)NSNumber * weight;//     float		体重（单位：公斤）
@property(nonatomic,strong)NSNumber * infoFlag;//	int         信息完整度（0:未完整  1:完整）

@property(nonatomic,strong) NSNumber *defPef;//参考值

@end
