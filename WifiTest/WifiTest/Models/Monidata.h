//
//  Monidata.h
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Monidata : NSObject

@property(nonatomic,strong)NSNumber *id;//          Long		编号
@property(nonatomic,strong)NSNumber *pef;//         int		pef
@property(nonatomic,strong)NSNumber *fev1;//        float		Fev1
@property(nonatomic,strong)NSNumber *fvc;//         int		组织架构编码
@property(nonatomic,strong)NSNumber *mid;//         Long		用户编号
@property(nonatomic,strong)NSNumber *level;//       Int		数据状态  0:良好  1:正常  2:危险
@property(nonatomic,strong)NSNumber *inputType;// 	Int		输入的数据类型  0:日常  1:运动  2:用药
@property(nonatomic,strong)NSNumber *otherType;// 	Int 		其他类型（如用药前用1，用药后用2）

@property(nonatomic,strong)NSString *username;//	String		用户名
@property(nonatomic,strong)NSString *saveTime;//	String		保存时间(yyyy-MM-dd HH:mm:ss)

-(NSString *)stateString;

@end
