//
//  HeartRateVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/12.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "HeartRateVC.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface HeartRateVC ()<CBCentralManagerDelegate, CBPeripheralDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lb_heartRate;

@property (strong, nonatomic) CBCentralManager      *centralManager; //中心角色
@property (strong, nonatomic) CBPeripheral          *peripheral; //查找到的外设角色


@end

@implementation HeartRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"心电图";
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - buttonAction 


-(void)backAction{
    [self cleanup];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - private method


- (void) startScan{
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
    //    [manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
}


- (void) stopScan{
    [_centralManager stopScan];
}


- (BOOL) isLECapableHardware{

    NSString * state = nil;
    switch ([_centralManager state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
            NSLog(@"centralStateChange: Unknown");
            break;
        case CBCentralManagerStateResetting: {
            NSLog(@"centralStateChange: Resetting");
            break;
        }
        default:
            return FALSE;
    }
    NSLog(@"Central manager state: %@", state);
    return FALSE;

}


- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!_peripheral.isConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_peripheral.services != nil)
    {
        for (CBService *service in _peripheral.services)
        {
            if (service.characteristics != nil)
            {
                for (CBCharacteristic *characteristic in service.characteristics)
                {
                    if (characteristic.isNotifying)
                    {
                        [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                        return;
                    }
                    
//                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]])
//                    {
//                        if (characteristic.isNotifying)
//                        {
//                            [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
//                            return;
//                        }
//                    }
                }
            }
        }
    }
    [_centralManager cancelPeripheralConnection:_peripheral];
    [_peripheral setDelegate:nil];
    _peripheral = nil;
    
}

- (void) updateWithHRMData:(NSData *)data
{
        NSLog(@"%@",data);
    const uint8_t *reportData = [data bytes];
}



#pragma mark - CBCentralManager delegate methods


#pragma mark - 蓝牙状态改变

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    [self isLECapableHardware];
}

#pragma mark - 搜索到外设

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    [self stopScan];
    
    if (_peripheral != peripheral)
    {
        _peripheral = peripheral;
        
        UIAlertView *t_alerView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:@"发现设备%@在%@db,是否连接",peripheral.name,RSSI] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        t_alerView.tag = 1;
        [t_alerView show];
    }
}

#pragma mark -  重连已知设备

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
     NSLog(@"didRetrievePeripherals");
    NSLog(@"Retrieved peripheral: %u - %@", [peripherals count], peripherals);
   
    // If there are any known devices, automatically connect to it.
    if([peripherals count] >= 1) {
        _peripheral = [peripherals objectAtIndex:0];
        [_centralManager connectPeripheral:_peripheral
                                options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    
    NSLog(@"didRetrieveConnectedPeripherals");
    if ([peripherals count])
    {
        NSLog(@"connected peripherals: %@", peripherals);
        CBPeripheral *aPeripheral = [peripherals objectAtIndex: 0];
        /* reconnecting to the peripheral will break the connection. Cancelling the connection doesn't seem to work */
        [_centralManager connectPeripheral: aPeripheral options: nil];
    }
    
    [_centralManager retrieveConnectedPeripherals];
}


#pragma mark - 连接外设成功

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"didConnectPeripheral");
    [ShowHUD showTextOnly:@"连接成功" configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:self.view];
    
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
    //[aPeripheral discoverServices:@[[CBUUID UUIDWithString:@"FF00"]]];
    
}

#pragma mark - 外设失去连接

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"didDisconnectPeripheral");
    
    [ShowHUD showTextOnly:@"失去连接，重新连接" configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:self.view];
    if (_peripheral) {
        
        
        [_centralManager retrievePeripherals:[NSArray arrayWithObject:(id)_peripheral.UUID]];
    }

}



#pragma mark - 外设连接失败

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    if( _peripheral )
    {
        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }
    [self startScan];
}

#pragma mark - CBPeripheral delegate methods


- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aPeripheral.services)
    {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        
        [aPeripheral discoverCharacteristics:nil forService:aService];
        /* Device Information Service */
//        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"FF00"]])
//        {
//            [aPeripheral discoverCharacteristics:nil forService:aService];
//            //[aPeripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"FF02"]] forService:aService];
//        }
        
    }
}


- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"service.UUID: %@", service.UUID);
    
    for (CBCharacteristic *aChar in service.characteristics)
    {
        
        [aPeripheral readValueForCharacteristic:aChar];
        /* Read device name */
//        NSLog(@"characteristics.UUID: %@", aChar.UUID);
//        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]])
//        {
//            [aPeripheral readValueForCharacteristic:aChar];
//           
//        }
//        
//        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]])
//        {
//            [aPeripheral readValueForCharacteristic:aChar];
//        }
    }

}

- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    /* Updated value for heart rate measurement received */
    
    NSLog(@"didUpdateValueForCharacteristic----%@",characteristic.UUID);
    
    if( (characteristic.value)  || !error )
    {
        /* Update UI with heart rate data */
        [self updateWithHRMData:characteristic.value];
    }
    
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]])
//    {
//        
//    }
//    
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]])
//    {
//        if( (characteristic.value)  || !error )
//        {
//            /* Update UI with heart rate data */
//            [self updateWithHRMData:characteristic.value];
//        }
//    }
    
}



#pragma mark - ButtonAciton 

- (IBAction)connectAction:(id)sender {
    
    if (_peripheral) {
        [_centralManager cancelPeripheralConnection:_peripheral];

        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }
   
    
    [self startScan];
}


#pragma mark - UIAlerViewDelegate 



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSLog(@"Connecting to peripheral %@", _peripheral);
            //第二步连接外设
            
            [_centralManager connectPeripheral:_peripheral options:nil];
        }
    }
}





#pragma mark -  dealloc 

-(void)dealloc{

    NSLog(@"HeartRateVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
