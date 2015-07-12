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
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
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
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]])
                    {
                        if (characteristic.isNotifying)
                        {
                            [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    [_centralManager cancelPeripheralConnection:_peripheral];
}

- (void) updateWithHRMData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0)
    {
        /* uint8 bpm */
        bpm = reportData[1];
    }
    else
    {
        /* uint16 bpm */
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }
    
//    uint16_t oldBpm = self.heartRate;
//    self.heartRate = bpm;
//    self.heartRateLabel.text = [NSString stringWithFormat: @"%d", self.heartRate];
//    if (!self.pulseTimer) {
//        self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / heartRate) target:self selector:@selector(pulse) userInfo:nil repeats: YES];
//    } else if (oldBpm != self.heartRate) {
//        [self.pulseTimer invalidate];
//        self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / heartRate) target:self selector:@selector(pulse) userInfo:nil repeats: YES];
//    }
}



#pragma mark - CBCentralManager delegate methods


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    [self isLECapableHardware];
}

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

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"didConnectPeripheral");
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
    
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"didDisconnectPeripheral");
    if( _peripheral )
    {
        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }

}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    if( _peripheral )
    {
        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }
}

#pragma mark - CBPeripheral delegate methods


- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aPeripheral.services)
    {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        /* Heart Rate Service */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180D"]])
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        /* Device Information Service */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180A"]])
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        /* GAP (Generic Access Profile) for Device Name */
        if ( [aService.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] )
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
    }
}


- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"service.UUID: %@", service.UUID);
    
    if ( [service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] )
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Read device name */
            NSLog(@"characteristics.UUID: %@", aChar.UUID);
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
            {
                [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Name Characteristic");
            }
        }
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Read manufacturer name */
             NSLog(@"characteristics.UUID: %@", aChar.UUID);
            
           
        }
    }
}

- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    /* Updated value for heart rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]])
    {
        if( (characteristic.value)  || !error )
        {
            /* Update UI with heart rate data */
            [self updateWithHRMData:characteristic.value];
        }
    }
    /* Value for body sensor location received */
    else  if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]])
    {
        NSData * updatedValue = characteristic.value;
        uint8_t* dataPointer = (uint8_t*)[updatedValue bytes];
        if(dataPointer)
        {
            uint8_t location = dataPointer[0];
            NSString*  locationString;
            switch (location)
            {
                case 0:
                    locationString = @"Other";
                    break;
                case 1:
                    locationString = @"Chest";
                    break;
                case 2:
                    locationString = @"Wrist";
                    break;
                case 3:
                    locationString = @"Finger";
                    break;
                case 4:
                    locationString = @"Hand";
                    break;
                case 5:
                    locationString = @"Ear Lobe";
                    break;
                case 6:
                    locationString = @"Foot";
                    break;
                default:
                    locationString = @"Reserved";
                    break;
            }
            NSLog(@"Body Sensor Location = %@ (%d)", locationString, location);
        }
    }
    /* Value for device Name received */
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
    {
        NSString * deviceName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Device Name = %@", deviceName);
    }
    /* Value for manufacturer name received */
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]])
    {
       
    }
}



#pragma mark - ButtonAciton 

- (IBAction)connectAction:(id)sender {
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
