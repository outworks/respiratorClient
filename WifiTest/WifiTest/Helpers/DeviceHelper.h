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

#define BLE_DEVICE_CONNECTED @"BLE_DEVICE_CONNECTED"

#define BLE_DEVICES_REST @"BLE_DEVICES_REST"

#define BLE_UPDATE_DATA @"BLE_UPDATE_DATA"

#define BLE_HISTORY_DATA @"BLE_HISTORY_DATA"

#define BLE_DATA_WRITE @"BLE_DATA_WRITE"

#define BLE_DATA_NOTI @"BLE_DATA_NOTI"

#define BLE_POWERLOW @"BLE_POWERLOW"

#define BLE_NOTOWERN @"BLE_NOTOWERN"

#define BLE_RESTSUCCESS @"BLE_RESTSUCCESS"

#define BLE_BINDNAME_SUCCESS @"BLE_BINDNAME_SUCCESS"

#define BLE_POWER_OFF @"BLE_POWER_OFF"

#define BLE_POWER_ON @"BLE_POWER_ON"

#define BLE_CONNET_TIMEOUT @"BLE_CONNET_TIMEOUT"

@interface DeviceHelper : NSObject

@property(nonatomic,strong) NSMutableArray *deviceNames;

-(BOOL)isConnected;

-(void)scan;

-(void)stopScan;

-(void)reset;

-(BOOL)sendRestDeviceData;

-(void)connectDeviceByName:(NSString *)deviceName;

-(void)disconnectDeviceByName:(NSString *)deviceName;


SYNTHESIZE_SINGLETON_FOR_HEADER(DeviceHelper)

@end
