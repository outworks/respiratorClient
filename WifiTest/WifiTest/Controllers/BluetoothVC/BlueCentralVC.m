//
//  BlueCentralVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/4.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BlueCentralVC.h"
#import <CoreBluetooth/CoreBluetooth.h>



@interface BlueCentralVC ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_peripheral; //外设ID
@property (weak, nonatomic) IBOutlet UILabel *lb_services; //服务
@property (weak, nonatomic) IBOutlet UILabel *lb_character; //特征
@property (weak, nonatomic) IBOutlet UITextView *tv_content; //接收的内容


@property (strong, nonatomic) CBCentralManager      *centralManager; //中心角色
@property (strong, nonatomic) CBPeripheral          *peripheral; //查找到的外设角色
@property (strong, nonatomic) NSMutableData         *data; //接收到的数据

@end

@implementation BlueCentralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接收端";
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _data = [[NSMutableData alloc] init];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [_centralManager stopScan];
    NSLog(@"Scanning stopped");

    [super viewWillDisappear:animated];
}

#pragma mark -private

-(void)loadUI{


}



-(void)scan{
    
    //第一步搜索外设
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"Scanning started");


}

#pragma mark - buttonAciton 

- (IBAction)btnScanAciton:(id)sender {
    
    
    
}

#pragma mark - Central Methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"centralStateChange: Powered On");
            // As soon as the peripheral/bluetooth is turned on, start initializing
            // the service.
            break;
        case CBCentralManagerStatePoweredOff: {
            NSLog(@"centralStateChange: Powered Off");
            break;
        }
        case CBCentralManagerStateResetting: {
            NSLog(@"centralStateChange: Resetting");
            break;
        }
        case CBCentralManagerStateUnauthorized: {
            NSLog(@"centralStateChange: Deauthorized");
            break;
        }
        case CBCentralManagerStateUnsupported: {
            NSLog(@"centralStateChange: Unsupported");
            break;
        }
        case CBCentralManagerStateUnknown:
            NSLog(@"centralStateChange: Unknown");
            break;
        default:
            break;
    }

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
//    // Reject any where the value is above reasonable range
//    if (RSSI.integerValue > -15)
//    {
//        return;
//    }
//    
//    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
//    if (RSSI.integerValue < -35)
//    {
//        return;
//    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);

    if (_peripheral != peripheral)
    {
        _peripheral = peripheral;
        
        UIAlertView *t_alerView = [[UIAlertView alloc] initWithTitle:PROGRAMNAME message:[NSString stringWithFormat:@"发现设备%@在%@db,是否连接",peripheral.name,RSSI] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        t_alerView.tag = 1;
        [t_alerView show];
    }
    
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    

    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSLog(@"Received: %@", stringFromData);
    [self.data appendData:characteristic.value];
    
    [self.tv_content setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
    
    // Cancel our subscription to the characteristic
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    // and disconnect from the peripehral
    [self.centralManager cancelPeripheralConnection:peripheral];
    
}

/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying)
    {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.peripheral = nil;
    
}


#pragma mark - UIAlertViewDelegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",buttonIndex);
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSLog(@"Connecting to peripheral %@", _peripheral);
            //第二步连接外设
            [_centralManager connectPeripheral:_peripheral options:nil];
        }
    }
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


#pragma mark - dealloc

-(void)dealloc{


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
