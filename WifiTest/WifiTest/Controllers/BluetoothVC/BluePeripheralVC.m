//
//  BluePeripheralVC.m
//  WifiTest
//
//  Created by Hcat on 15/7/4.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BluePeripheralVC.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluePeripheralVC ()<CBPeripheralManagerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView        *tf_content;
@property (strong, nonatomic) CBPeripheralManager       *peripheral;
@property (strong, nonatomic) CBMutableCharacteristic   *characteristic;
@property(nonatomic, strong) CBMutableService           *service;
@property (strong, nonatomic) NSData                    *dataToSend;

@property(nonatomic, strong) CBUUID                     *serviceUUID;
@property(nonatomic, strong) CBUUID                     *characteristicUUID;
@property(nonatomic, strong) NSString                   *serviceName;
@property(nonatomic, assign) BOOL                       serviceRequiresRegistration;

@end

@implementation BluePeripheralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发送端";
    self.peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    self.serviceName = @"Test";
    self.serviceUUID = [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID];
    self.characteristicUUID = [CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.peripheral stopAdvertising];
    
    [super viewWillDisappear:animated];
}

#pragma mark - private 

- (void)enableService {
    // If the service is already registered, we need to re-register it again.
    if (self.service) {
        [self.peripheral removeService:self.service];
    }
    
    // Create a BTLE Peripheral Service and set it to be the primary. If it
    // is not set to the primary, it will not be found when the app is in the
    // background.
    self.service = [[CBMutableService alloc]
                    initWithType:self.serviceUUID primary:YES];
    
    // Set up the characteristic in the service. This characteristic is only
    // readable through subscription (CBCharacteristicsPropertyNotify) and has
    // no default value set.
    //
    // There is no need to set the permission on characteristic.
    self.characteristic =
    [[CBMutableCharacteristic alloc]
     initWithType:self.characteristicUUID
     properties:CBCharacteristicPropertyNotify
     value:nil
     permissions:0];
    
    // Assign the characteristic.
    self.service.characteristics =
    [NSArray arrayWithObject:self.characteristic];
    
    // Add the service to the peripheral manager.
    [self.peripheral addService:self.service];
}

- (void)disableService {
    if (self.service) {
        [self.peripheral removeService:self.service];
    }
    self.service = nil;
    [self stopAdvertising];
}


- (void)startAdvertising {
    if (self.peripheral.isAdvertising) {
        [self.peripheral stopAdvertising];
    }
    
    NSDictionary *advertisment = @{
                                   CBAdvertisementDataServiceUUIDsKey : @[self.serviceUUID],
                                   CBAdvertisementDataLocalNameKey: self.serviceName
                                   };
    [self.peripheral startAdvertising:advertisment];
}

- (void)stopAdvertising {
    [self.peripheral stopAdvertising];
}

- (BOOL)isAdvertising {
    return [self.peripheral isAdvertising];
}

- (void)sendToSubscribers:(NSData *)data {
    if (self.peripheral.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"sendToSubscribers: peripheral not ready for sending state: %ld", self.peripheral.state);
        return;
    }
    
    BOOL success = [self.peripheral updateValue:data
                              forCharacteristic:self.characteristic
                           onSubscribedCentrals:nil];
    if (!success) {
        NSLog(@"Failed to send data, buffering data for retry once ready.");
        self.dataToSend = data;
        return;
    }
}

#pragma mark - Peripheral methods 

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"peripheralStateChange: Powered On");
            // As soon as the peripheral/bluetooth is turned on, start initializing
            // the service.
            [self enableService];
            break;
        case CBPeripheralManagerStatePoweredOff: {
            NSLog(@"peripheralStateChange: Powered Off");
            [self disableService];
            self.serviceRequiresRegistration = YES;
            break;
        }
        case CBPeripheralManagerStateResetting: {
            NSLog(@"peripheralStateChange: Resetting");
            self.serviceRequiresRegistration = YES;
            break;
        }
        case CBPeripheralManagerStateUnauthorized: {
            NSLog(@"peripheralStateChange: Deauthorized");
            [self disableService];
            self.serviceRequiresRegistration = YES;
            break;
        }
        case CBPeripheralManagerStateUnsupported: {
            NSLog(@"peripheralStateChange: Unsupported");
            self.serviceRequiresRegistration = YES;
            // TODO: Give user feedback that Bluetooth is not supported.
            break;
        }
        case CBPeripheralManagerStateUnknown:
            NSLog(@"peripheralStateChange: Unknown");
            break;
        default:
            break;
    }
}


/** Catch when someone subscribes to our characteristic, then start sending them data
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central subscribed to characteristic");
    
    // Get the data
    [self sendToSubscribers:[self.tf_content.text dataUsingEncoding:NSUTF8StringEncoding]];
}


- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    // Start sending again
    if (self.dataToSend) {
        NSData *data = [self.dataToSend copy];
        self.dataToSend = nil;
        [self sendToSubscribers:data];
    }
}

/** Recognise when the central unsubscribes
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
}



#pragma mark - buttonAction 

- (IBAction)sendAction:(id)sender {
    
    [self startAdvertising];
    
}

- (IBAction)stopActiton:(id)sender {
    
    if ([self isAdvertising]) {
        [self stopAdvertising];
    }
}

#pragma mark - 

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self isAdvertising]) {
        [self stopAdvertising];
    }
    
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
