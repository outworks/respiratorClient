//
//  DeviceHelper.h
//  responder
//
//  Created by ilikeido on 15/7/25.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCSingletonTemplate.h"

#define BLE_DEVICE_FOUND @"BLE_DEVICE_FOUND"

#define BLE_UPDATE_DATA @"BLE_UPDATE_DATA"

#define BLE_DATA_WRITE @"BLE_DATA_WRITE"

#define BLE_POWERLOW @"BLE_POWERLOW"

@interface DeviceHelper : NSObject

@property(nonatomic,strong) NSMutableArray *deviceNames;

-(void)scan;

-(void)stopScan;

-(void)reset;

-(void)connectDeviceByName:(NSString *)deviceName;

-(void)disconnectDeviceByName:(NSString *)deviceName;


SYNTHESIZE_SINGLETON_FOR_HEADER(DeviceHelper)

@end
