//
//  DateMonidata.h
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateMonidata : NSObject

@property(nonatomic,strong)NSNumber *mid;//             Long		用户编号
@property(nonatomic,strong)NSString *username;//        String		用户名称
@property(nonatomic,strong)NSString *saveDate;//        String		保存日期
@property(nonatomic,strong)NSArray  *dataDetails;//     List< Monidata >		当天检测数据集

@end
