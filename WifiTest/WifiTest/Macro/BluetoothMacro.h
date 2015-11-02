//
//  BluetoothMacro.h
//  WifiTest
//
//  Created by Hcat on 15/11/2.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#ifndef BluetoothMacro_h
#define BluetoothMacro_h

////////////////////////////////////////////////////////////////////////////////////////////////

#define BLE_DATA_WRITE @"BLE_DATA_WRITE"                //软件写入设备通知

#define BLE_DATA_NOTI @"BLE_DATA_NOTI"                  //设备数据传达通知

////////////////////////////////////////////////////////////////////////////////////////////////

#define BLE_DEVICE_FOUND @"BLE_DEVICE_FOUND"            //查找到设备通知

#define BLE_DEVICE_CONNECTED @"BLE_DEVICE_CONNECTED"    //设备连接通知

#define BLE_UPDATE_DATA @"BLE_UPDATE_DATA"              //设备发送单笔吹气通知

#define BLE_HISTORY_DATA @"BLE_HISTORY_DATA"            //设备历史记录通知

#define BLE_POWERLOW @"BLE_POWERLOW"                    //设备低电量通知

#define BLE_NOTOWERN @"BLE_NOTOWERN"                    //不是设备的绑定号码通知

#define BLE_DEVICES_REST @"BLE_DEVICES_REST"            //软件重置蓝牙通知

#define BLE_RESTSUCCESS @"BLE_RESTSUCCESS"              //设备重置成功通知，也就是和软件蓝牙匹配成功通知

#define BLE_POWER_OFF @"BLE_POWER_OFF"                  //软件蓝牙关闭通知

#define BLE_CONNET_TIMEOUT @"BLE_CONNET_TIMEOUT"        //查找设备超时通知

#define BLE_BINDNAME_SUCCESS @"BLE_BINDNAME_SUCCESS"

#define BLE_POWER_ON @"BLE_POWER_ON"

#endif /* BluetoothMacro_h */
