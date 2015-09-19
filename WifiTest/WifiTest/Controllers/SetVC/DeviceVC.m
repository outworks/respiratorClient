//
//  DeviceVC.m
//  WifiTest
//
//  Created by ilikeido on 15/8/6.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DeviceVC.h"
#import "DeviceHelper.h"

@interface DeviceVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextView *tv_content;

@end

@implementation DeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的设备";
    [[DeviceHelper sharedDeviceHelper]scan];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDatas) name:BLE_DEVICE_FOUND object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appendRecive:) name:BLE_UPDATE_DATA object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appendSend:) name:BLE_DATA_WRITE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -function
-(void)reloadDatas{
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *deviceName = [[DeviceHelper sharedDeviceHelper].deviceNames objectAtIndex:indexPath.row];
    [[DeviceHelper sharedDeviceHelper]connectDeviceByName:deviceName];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DeviceHelper sharedDeviceHelper].deviceNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *deviceName = [[DeviceHelper sharedDeviceHelper].deviceNames objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"找到设备:%@",deviceName];
    return cell;
}


-(void)appendRecive:(NSNotification *)notification{
    NSString *data = [notification.userInfo objectForKey:@"data"];
    NSString *content = _tv_content.text;
    NSString *message = [notification.userInfo objectForKey:@"msg"];
    _tv_content.text = [NSString stringWithFormat:@"%@:\n%@\n%@\n\n",message,data,content];
}

-(void)appendSend:(NSNotification *)notification{
    NSString *data = [notification.userInfo objectForKey:@"data"];
    NSString *msg = [notification.userInfo objectForKey:@"msg"];
    NSString *content = _tv_content.text;
    _tv_content.text = [NSString stringWithFormat:@"%@\n：%@\n%@\n\n",msg,data,content];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
