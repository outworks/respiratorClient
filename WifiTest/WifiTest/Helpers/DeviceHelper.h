//
//  DeviceHelper.h
//  responder
//
//  Created by ilikeido on 15/7/25.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCSingletonTemplate.h"



@interface DeviceHelper : NSObject

@property(nonatomic,strong) NSMutableArray *deviceNames;

-(BOOL)isConnected;

-(void)scan;

-(void)stopScan;

/*
 * 重置蓝牙连接
 */

-(void)reset;

/*
 * 连接设备
 */

-(void)connectDeviceByName:(NSString *)deviceName;

/*
 * 取消连接设备
 */

-(void)disconnectDeviceByName:(NSString *)deviceName;

/*
 * 发送重置指令
 */

-(BOOL)sendRestDeviceData;


SYNTHESIZE_SINGLETON_FOR_HEADER(DeviceHelper)

@end
