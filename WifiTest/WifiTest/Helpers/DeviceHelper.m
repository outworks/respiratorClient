//
//  DeviceHelper.m
//  responder
//
//  Created by ilikeido on 15/7/25.
//  Copyright (c) 2015年 ilikeido. All rights reserved.
//

#import "DeviceHelper.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define UUIDSTR_ISSC_PROPRIETARY_SERVICE @"FFF0"

#define HAL_KEY_SW_A 0x01
#define HAL_KEY_SW_B 0x02
#define HAL_KEY_SW_C 0x04
#define HAL_KEY_SW_D 0x08
#define HAL_KEY_SW_E 0x10
#define HAL_KEY_START 0xaa

@interface DeviceHelper ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong) NSMutableDictionary *deviceDict;

@property(nonatomic,strong) CBCentralManager *manager;

@property(nonatomic,strong) NSMutableArray *peripheralList;

@property(nonatomic,strong) CBPeripheral  *testPeripheral;

@property(nonatomic,strong) NSTimer *connectTimer;

@property(nonatomic,strong) CBCharacteristic *broadcastCharacteristic;

@property(nonatomic,strong) CBCharacteristic *readCharacteristic;

@property(nonatomic,strong) CBCharacteristic *writeCharacteristic;

@property(nonatomic,strong) CBCharacteristic *notifyCharacteristic;

@property(nonatomic,strong) NSMutableData *recvData;
@property(nonatomic,assign) int packLength;

//@property(nonatomic,strong) NSTimer *ackTimer;


@end

@implementation DeviceHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(DeviceHelper)


-(id)init{
    self = [super init];
    if (self) {
        self.deviceDict = [NSMutableDictionary dictionary];
        self.deviceNames = [NSMutableArray array];
        self.peripheralList = [NSMutableArray array];
        _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];

    }
    return self;
}


#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        
        [_manager scanForPeripheralsWithServices:nil options:nil];
        
    }else if (central.state == CBCentralManagerStatePoweredOff) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:BLE_POWER_OFF object:nil];
        [_manager stopScan];
        [self clear];
        
    }else if (central.state == CBCentralManagerStateUnknown) {
        
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    //当central管理者与peripheral建立连接失败时调用
    NSLog(@"%@(%@) didFailToConnectPeripheral",peripheral.name,peripheral.identifier.UUIDString);
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    //当已经与peripheral建立的连接断开时调用
     NSLog(@"%@(%@) didDisconnectPeripheral",peripheral.name,peripheral.identifier.UUIDString);
    [self reset];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    //当和一个peripheral设备成功建立连接时调用
    NSLog(@"didDiscoveredPeripherals:%@", peripheral);
    
    if(![self.peripheralList containsObject:peripheral] && [peripheral.name isEqual:@"ForeverStrong"]){
        
        [self.peripheralList addObject:peripheral];
        NSString *perpheralName = [NSString stringWithFormat:@"%@(%@)",peripheral.name,peripheral.identifier.UUIDString];
        [self.deviceNames addObject:perpheralName];
        [self.deviceDict setObject:peripheral forKey:perpheralName];
        [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DEVICE_FOUND object:nil];
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [_connectTimer invalidate];//停止时钟
    NSLog(@"Did connect to peripheral: %@", peripheral);
    _testPeripheral = peripheral;
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DEVICE_CONNECTED object:nil];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"didDiscoverServices");
    
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        
        //        if ([self respondsToSelector:@selector(DidNotifyFailConnectService:withPeripheral:error:)])
        //            [self.delegate DidNotifyFailConnectService:nil withPeripheral:nil error:nil];
        
        return;
    }
    
    
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Service found with UUID: %@", service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        
        return;
    }
    for (CBCharacteristic * characteristic in service.characteristics)
    {
        NSLog(@"Discovered write characteristics:%@ ,perperties:%lu for service: %@", characteristic.UUID, (unsigned long)characteristic.properties,service.UUID);
        if ([characteristic.UUID.UUIDString isEqual:@"FFF2" ]) {
            _writeCharacteristic = characteristic;
        }
        if ([characteristic.UUID.UUIDString isEqual:@"FFF1" ]) {
            _notifyCharacteristic = characteristic;
        }
//        switch (characteristic.properties) {
//            case CBCharacteristicPropertyBroadcast:
//                _broadcastCharacteristic = characteristic;
//                break;
//            case CBCharacteristicPropertyRead:{
//                if (_readCharacteristic) {
//                    _readCharacteristic2 = characteristic;
//                }else{
//                    _readCharacteristic = characteristic;
//                }
//            }
//                break;
//            case CBCharacteristicPropertyWrite:
//                _writeCharacteristic = characteristic;
//                break;
//            case CBCharacteristicPropertyNotify:
//                _notifyCharacteristic = characteristic;
//                break;
//            default:
//                break;
//        }
    }
    if (_notifyCharacteristic) {
        [_testPeripheral setNotifyValue:YES forCharacteristic:_notifyCharacteristic];
    }
//    if (_writeCharacteristic) {
//        _ackTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(writeAck) userInfo:nil repeats:YES];
//        [_ackTimer fire];
//    }
}

//-(void)writeAck{
//    int i = 1;
//    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
//    [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse ];
//}
//
//-(void)proessData{
//    if (self.recvData.length>2) {
//        NSData *keyData = [self.recvData subdataWithRange:NSMakeRange(0, 1)];
//        int temp = 0;
//        [keyData getBytes: &temp length: sizeof(temp)];
//        if (temp == HAL_KEY_START) {
//            NSData *lengthData = [self.recvData subdataWithRange:NSMakeRange(1, 1)];
//            [lengthData getBytes: &temp length: sizeof(temp)];
//            self.packLength = temp;
//        }
//        if (self.packLength>0 && self.recvData.length >= self.packLength) {
//            NSData *data = [self.recvData subdataWithRange:NSMakeRange(0, self.packLength + 3)];
//            [self submitData:data];
//            NSData *subData = [self.recvData subdataWithRange:NSMakeRange(data.length, self.recvData.length - data.length)];
//            if (subData.length == 0) {
//                self.recvData = [NSMutableData data];
//            }else{
//                self.recvData = [subData mutableCopy];
//            }
//            [self proessData];
//        }
//    }
//    
//}
//
//-(void)submitData:(NSData *)data{
//    BOOL flag = [self checkData:data];
//    if (flag) {
//        NSData *busData = [data subdataWithRange:NSMakeRange(2, data.length - 3)];
//        [self handleData:busData];
//    }else{
//        NSLog(@"dataCheckError:%@",[self dataToString:data]);
//    }
//    
//}
//
//-(void)handleData:(NSData *)data {
//    NSString *dataString = [self dataToString:data];
//    NSString *type = [dataString substringToIndex:4];
//    NSString *mac = [dataString substringWithRange:NSMakeRange(4, 16)];
//    NSLog(@"mac :%@，type:%@",mac,type);
//    NSMutableArray *answers = [NSMutableArray array];
//    NSString *noticicationName = @"";
//    if ([@"f901" isEqual:type ]) {
//        noticicationName = BLE_SUBDEVICE_ONLINE;
//    }
//    if ([@"f904" isEqual:type ]) {
//        noticicationName = BLE_SUBDEVICE_OFFLINE;
//    }
//    if ([@"f903" isEqual:type ]) {
//        noticicationName = BLE_SUBDEVICE_CHECK;
//    }
//    
//    if ([@"f902" isEqual:type ]) {
//        noticicationName = BLE_SUBDEVICE_SUBMIT;
//        const unsigned char *txbuf =  [data bytes];
//        const unsigned int choose = txbuf[10];
//        if (choose & HAL_KEY_SW_A) {
//            [answers addObject:@"A"];
//        }
//        if (choose & HAL_KEY_SW_B) {
//            [answers addObject:@"B"];
//        }
//        if (choose & HAL_KEY_SW_C) {
//            [answers addObject:@"C"];
//        }
//        if (choose & HAL_KEY_SW_D) {
//            [answers addObject:@"D"];
//        }
//        if (choose & HAL_KEY_SW_E) {
//            [answers addObject:@"E"];
//        }
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:noticicationName object:@{@"mac":mac,@"value":answers}];
//}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    NSData *data = characteristic.value;
    NSLog(@"%@",[self dataToString:data]);
    if (data.length == 16) {
        
        const unsigned char *txbuf =[data bytes];
        if (txbuf[0] == 0x90 && txbuf[2]==0x01) {
            
            /************ 1.硬件发送同步时间指令 ************/
            NSLog(@"1.硬件发送同步时间指令:%@",[self dataToString:data]);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":@"请求同步时间"}];
            unsigned char mbytes[16];
            mbytes[0] = txbuf[0];
            mbytes[1] = 0x01;
            mbytes[2] = txbuf[2];
            NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
            [formatter setDateFormat:@"MMddhhmmssSSS"];
            NSString *date =  [formatter stringFromDate:[NSDate date]];
            NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
            int month = [timeLocal substringWithRange:NSMakeRange(0, 2)].intValue;
            int day = [timeLocal substringWithRange:NSMakeRange(2, 2)].intValue;
            int hour = [timeLocal substringWithRange:NSMakeRange(4, 2)].intValue;
            int minute = [timeLocal substringWithRange:NSMakeRange(6, 2)].intValue;
            int second = [timeLocal substringWithRange:NSMakeRange(8, 2)].intValue;
            int s1 = [timeLocal substringWithRange:NSMakeRange(10, 1)].intValue;
            int s2 = [timeLocal substringWithRange:NSMakeRange(11, 1)].intValue;
            int s3 = [timeLocal substringWithRange:NSMakeRange(12, 1)].intValue;
            mbytes[3] = month;
            mbytes[4] = day;
            mbytes[5] = hour;
            mbytes[6] = minute;
            mbytes[7] = second;
            mbytes[8] = s1;
            mbytes[10] = s2;
            mbytes[12] = s3;
            mbytes[14] = 0x00;
            int addTx = 0;
            for (int i =0 ; i<15; i++) {
                addTx += mbytes[i];
            }
            mbytes[15] = addTx;
            NSData *data = [NSData dataWithBytes:mbytes length:16];
            
            /************ 2.软件回应时间指令 ************/
            NSLog(@"2.软件回应时间指令:%@",[self dataToString:data]);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_WRITE object:nil userInfo:@{@"data":[self dataToString:data ],@"msg":@"回应时间同步"}];
            [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x02){//低电量
            
            /************ 硬件发送电量低指令 ************/
            NSLog(@"硬件发送电量低指令:%@",[self dataToString:data]);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":@"电量低"}];
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_POWERLOW object:nil userInfo:nil];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x03){
            
            /************ 3.硬件请求手机号码 ************/
            NSLog(@"3.硬件请求手机号码:%@",[self dataToString:data]);
            
            NSString *noString = [[self dataToString:data] substringWithRange:NSMakeRange(3*2, 10*2)];
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":[NSString stringWithFormat:@"请求手机帐号,%@",noString]}];
            unsigned char mbytes[16];
            mbytes[0] = txbuf[0];
            mbytes[1] = 0x01;
            mbytes[2] = txbuf[2];
            int temp = 3;
            NSString *sendNo = [ShareValue sharedShareValue].m_username;
            if (sendNo.length>11) {
                sendNo = [sendNo substringToIndex:10];
            }else{
                for ( int i=0; i<11-sendNo.length; i++) {
                    mbytes[temp] = 0x00;
                    temp ++;
                }
            }
            for (int i=0; i<sendNo.length; i++) {
                mbytes[temp + i] = [sendNo characterAtIndex:i] & 0xFF;
            }
            int addTx = 0;
            for (int i =0 ; i<15; i++) {
                addTx += mbytes[i];
            }
            mbytes[15] = addTx;
            NSData *data = [NSData dataWithBytes:mbytes length:16];
            
            /************ 4.软件回应手机号码 ************/
            NSLog(@"4.软件回应手机号码:%@",[self dataToString:data]);
            
            [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_WRITE object:nil userInfo:@{@"data":[self dataToString:data ],@"msg":@"回传手机号"}];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x41){
            
            /************ 2.1.硬件发送单笔吹气数据 ************/
            NSLog(@"2.1.硬件发送单笔吹气数据:%@",[self dataToString:data]);
            
            int month = txbuf[3];
            int day = txbuf[4];
            int hour = txbuf[5];
            int minute = txbuf[6];
            int second = txbuf[7];
            NSString *dateString = [NSString stringWithFormat:@"%02d-%02d %02d:%02d:%02d",month,day,hour,minute,second];
            int x = txbuf[9] & 0xFF;
            x |= ((txbuf[8] << 8) & 0xFF00);
            int x1 = txbuf[11] & 0xFF;
            x1 |= ((txbuf[10] << 8) & 0xFF00);
            int x2 = txbuf[13] & 0xFF;
            x2 |= ((txbuf[12] << 8) & 0xFF00);
            
            unsigned char mbytes[16];
            mbytes[0] = txbuf[0];
            mbytes[1] = 0x01;
            mbytes[2] = 0x41;
            for (int i=3; i<15; i++) {
                mbytes[i] = txbuf[i];
            }
            int addTx = 0;
            for (int i =0 ; i<15; i++) {
                addTx += mbytes[i];
            }
            mbytes[15] = addTx;
            NSData *data = [NSData dataWithBytes:mbytes length:16];
            
            /************ 2.2.软件回应收到单笔吹气数据 ************/
            NSLog(@"2.2.软件回应收到单笔吹气数据:%@",[self dataToString:data]);
            
            [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":[NSString stringWithFormat:@"获得数据X:%d,X1:%d,X2:%d",x,x1,x2]}];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_UPDATE_DATA object:nil userInfo:@{@"data":dateString,@"X":@(x),@"X1":@(x1),@"X2":@(x2),@"msg":[NSString stringWithFormat:@"获得数据X:%d,X1:%d,X2:%d",x,x1,x2]}];
            
        }
        else if (txbuf[0] == 0x90 && txbuf[2]==0x05){
            
            /************ 7.硬件回应历史记录 ************/
            NSLog(@"7.硬件回应历史记录:%@",[self dataToString:data]);
            
            int month = txbuf[3];
            int day = txbuf[4];
            int hour = txbuf[5];
            int minute = txbuf[6];
            int second = txbuf[7];
            NSLog(@"历史记录时间点：%@",[NSString stringWithFormat:@"%02d-%02d %02d:%02d:%02d",month,day,hour,minute,second]);
            NSString *dateString = [NSString stringWithFormat:@"%02d-%02d %02d:%02d:%02d",month,day,hour,minute,second];
            int x = txbuf[8] & 0xFF;
            x |= ((txbuf[9] << 8) & 0xFF00);
            int x1 = txbuf[10] & 0xFF;
            x1 |= ((txbuf[11] << 8) & 0xFF00);
            int x2 = txbuf[12] & 0xFF;
            x2 |= ((txbuf[13] << 8) & 0xFF00);
            
            unsigned char mbytes[16];
            mbytes[0] = txbuf[0];
            mbytes[1] = 0x01;
            mbytes[2] = 0x41;
            for (int i=3; i<15; i++) {
                mbytes[i] = txbuf[i];
            }
            int addTx = 0;
            for (int i =0 ; i<15; i++) {
                addTx += mbytes[i];
            }
            mbytes[15] = addTx;
            NSData *data = [NSData dataWithBytes:mbytes length:16];
            
            [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":[NSString stringWithFormat:@"获得历史数据X:%d,X1:%d,X2:%d",x,x1,x2]}];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_HISTORY_DATA object:nil userInfo:@{@"data":dateString,@"X":@(x),@"X1":@(x1),@"X2":@(x2),@"msg":[NSString stringWithFormat:@"获得数据X:%d,X1:%d,X2:%d",x,x1,x2]}];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_WRITE object:nil userInfo:@{@"date":[self dataToString:data],@"msg":@"回应呼吸数据"}];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x42){
            
            /************ 硬件停止工作指令 ************/
            NSLog(@"硬件停止工作指令:%@",[self dataToString:data]);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":@"停止"}];
            [self reset];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x06){
            
            /************ 5.软件回应手机号码通过 ************/
            NSLog(@"5.软件回应手机号码通过:%@",[self dataToString:data]);
            
            unsigned char mbytes[16];
            mbytes[0] = 0x90;
            mbytes[1] = 0x01;
            mbytes[2] = 0x05;
            for (int i=3; i<15; i++) {
                mbytes[i] = 0x00;
            }
            int addTx = 0;
            for (int i =0 ; i<15; i++) {
                addTx += mbytes[i];
            }
            mbytes[15] = addTx;
            NSData *data = [NSData dataWithBytes:mbytes length:16];
            
            /************ 6.软件发送请求读取历史记录 ************/
            
            NSLog(@"6.软件发送请求读取历史记录:%@",[self dataToString:data]);
            
            [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_WRITE object:nil userInfo:@{@"data":[self dataToString:data],@"msg":@"发送读取历史记录指令"}];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x07){
            
            /************ 5.软件回应手机号码不通过 ************/
            NSLog(@"5.软件回应手机号码不通过:%@",[self dataToString:data]);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":@"不是本机"}];
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_NOTOWERN object:nil userInfo:nil];
            
        }else if (txbuf[0] == 0x90 && txbuf[2]==0x08){
            
            /************ 8.硬件回传重置成功 ************/
            NSLog(@"8.硬件回传重置成功:%@",[self dataToString:data]);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_NOTI object:nil userInfo:@{@"data":[self dataToString:data],@"msg":@"重置成功"}];
            [[NSNotificationCenter defaultCenter]postNotificationName:BLE_RESTSUCCESS object:nil userInfo:nil];
            
        }
    }
    return;
    
    
//    NSLog(@"data:%@",hexStr);
//    if ([[hexStr substringToIndex:2] isEqual:@"aa"]) {
//        self.recvData = nil;
//        self.recvData = [[NSMutableData alloc]init];
//        [self.recvData appendData:data];
//    }else{
//        NSString *hexStr = [self dataToString:data];
//        NSRange rang = [hexStr rangeOfString:@"aa"];
//        if (rang.length == 0) {
//            [self.recvData appendData:data];
//        }else{
//            [self.recvData appendData:[data subdataWithRange:NSMakeRange(0, rang.location/2)]];
//        }
//        NSString *allData = [self dataToString:self.recvData];
//        NSString *dataString = [allData substringWithRange:NSMakeRange(4, allData.length - 2 - 4)];
//        NSLog(@"result:%@",dataString);
//        [self processData:dataString];
//        if (rang.length != 0){
//            self.recvData = nil;
//            self.recvData = [[NSMutableData alloc]init];
//            NSData *subData = [data subdataWithRange:NSMakeRange(rang.location/2, data.length - rang.location/2)];
//            [self.recvData appendData:subData];
//        }
//    }
    
}


#pragma mark - 
#pragma mark - private methods

//连接指定的设备

-(BOOL)connectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connect start");
    _testPeripheral = nil;
    
//    [_manager connectPeripheral:peripheral
//                        options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    [_manager connectPeripheral:peripheral
                        options:nil];
    
    //开一个定时器监控连接超时的情况
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(connectTimeout:) userInfo:peripheral repeats:NO];
    
    return (YES);
}


-(void)connectTimeout:(CBPeripheral *)peripheral{
    
    [self reset];
    NSLog(@"超时!");
    [[NSNotificationCenter defaultCenter]postNotificationName:BLE_CONNET_TIMEOUT object:nil userInfo:nil];
    
}


-(BOOL)checkData:(NSData *)data{
    
    BOOL flag = false;
    const unsigned char *txbuf =  [data bytes];
    unsigned int tx_xor = 0;
    if (txbuf[0] == 0xaa) {
        unsigned int size = txbuf[1];
        unsigned char i;
        tx_xor ^= size;
        for (i =0 ; i<size; ++i) {
            tx_xor ^= txbuf[2+i];
        }
        Byte checkByte = tx_xor & 0xff;
        if (txbuf[2+i] == checkByte) {
            flag = true;
        }
    }
    return flag;
}

-(void)processData:(NSString *)dataString{
    
}



-(NSString *)dataToString:(NSData *)data{
    
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

//-(NSString *)peripheralName:(CBPeripheral *)peripheral{
//    
//    return [NSString stringWithFormat:@"%@(%@)",peripheral.name,peripheral.identifier.UUIDString];
//    
//}

-(void)clear{
    
    self.broadcastCharacteristic = nil;
    
    self.readCharacteristic = nil;
    
    self.writeCharacteristic = nil;
    
    self.notifyCharacteristic = nil;
    
    self.testPeripheral = nil;
    
    [self.peripheralList removeAllObjects];
    [self.deviceNames removeAllObjects];
    [self.deviceDict removeAllObjects];
}

#pragma mark - 
#pragma mark - public methods


-(BOOL)isConnected{
    
    return _testPeripheral;
    
}

-(void)scan{
    [_manager scanForPeripheralsWithServices:nil options:nil];
}

-(void)stopScan{
    
    [_manager stopScan];
    
}

-(void)connectDeviceByName:(NSString *)deviceName{
    
    CBPeripheral *peripheral = [self.deviceDict objectForKey:deviceName];
    [self connectPeripheral:peripheral];

}

-(void)disconnectDeviceByName:(NSString *)deviceName{
    
    CBPeripheral *peripheral = [self.deviceDict objectForKey:deviceName];
    [_manager cancelPeripheralConnection:peripheral];
    
}

-(void)reset{
    
    if (_testPeripheral) {
        [_manager cancelPeripheralConnection:_testPeripheral];
        _testPeripheral = nil;
    }
    [self clear];
    
    [_manager stopScan];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DEVICES_REST object:nil];
}

-(BOOL)sendRestDeviceData{
    
    if (_testPeripheral && _writeCharacteristic) {
        unsigned char mbytes[16];
        mbytes[0] = 0x90;
        mbytes[1] = 0x01;
        mbytes[2] = 0x04;
        for (int i=3; i<15; i++) {
            mbytes[i] = 0x00;
        }
        int addTx = 0;
        for (int i =0 ; i<15; i++) {
            addTx += mbytes[i];
        }
        mbytes[15] = addTx;
        NSData *data = [NSData dataWithBytes:mbytes length:16];
        [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        [[NSNotificationCenter defaultCenter]postNotificationName:BLE_DATA_WRITE object:nil userInfo:@{@"date":[self dataToString:data],@"msg":@"发送重置指令"}];
        return YES;
    }else{
        return NO;
    }
}

@end
