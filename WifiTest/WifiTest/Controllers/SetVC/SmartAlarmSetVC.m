//
//  SmartAlarmSetVC.m
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SmartAlarmSetVC.h"
#import "LRPicker.h"

@interface SmartAlarmSetVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_determine;
@property (nonatomic,strong) LRPicker *picker;

@end

@implementation SmartAlarmSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == SmartAlarmSetTypeAdd) {
        _alarm = [[Alarm alloc] init];
        _alarm.status = YES;
        _alarm.time = @"12:00";
    }
    
    [self initUI];
    
    
    
}

#pragma mark - private methods 

- (void)initUI{
    
    self.navigationItem.title = @"智能闹钟";
    [ShareFun getCorner:_btn_determine withCorner:CGRectGetHeight(_btn_determine.frame)/2 withBorderWidth:1.f withBorderColor:UIColorFromRGB(0x40BAC8)];
    
    NSMutableArray *t_hour = [NSMutableArray array];
    NSArray *tip = @[@":"];
    NSMutableArray *t_min  = [NSMutableArray array];
    
    for (int i = 0; i < 24; i++) {
        [t_hour addObject:[NSString stringWithFormat:@"%@%d",(i < 10)?@"0":@"",i]];
    }
    
    for (int i = 0; i<60; i++) {
        [t_min addObject:[NSString stringWithFormat:@"%@%d",(i < 10)?@"0":@"",i]];
    }
    
    NSArray *arr_data       = @[t_hour,tip,t_min];
    NSArray *arr_enbaled    = @[@(YES),@(NO),@(YES)];
    
    NSValue *value_hour = [NSValue valueWithCGRect:CGRectMake((ScreenWidth-20)/2-80, 0, 80, 200)];
    NSValue *value_tip  = [NSValue valueWithCGRect:CGRectMake((ScreenWidth-20)/2, 0, 20, 200)];
    NSValue *value_min  = [NSValue valueWithCGRect:CGRectMake((ScreenWidth+20)/2, 0, 80, 200)];
    
    
    NSArray *arr_frame      = @[value_hour,value_tip,value_min];
    
    _picker = [[LRPicker alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 200) withDataArray:arr_data withFrameArray:arr_frame withScrollEnabledArray:arr_enbaled withOptions:@{
                                                                                                                                                                                        LRPickerOptionColonFont:[UIFont systemFontOfSize:27.f],
                                                                                                                                                                                LRPickerOptionColonHeight:@(40.f),
                                                                                                                                                                                        LRPickerOptionSelectedColor:UIColorFromRGB(0x3EBACA),
                                                                                                                                                                                        LRPickerOptionUnSelectedColor:[UIColor lightGrayColor]                                                                                                         }];
    _picker.backgroundColor = [UIColor clearColor];
    
    if (_alarm) {
        NSArray *arr_time = [_alarm.time componentsSeparatedByString:@":"];
        NSArray *arr_default = @[arr_time[0],@":",arr_time[1]];
        [_picker setDefaultData:arr_default];
    }
    
    [self.view addSubview:_picker];
    
    
}




#pragma mark - buttonAction


- (IBAction)btnDetermineAction:(id)sender {

    NSArray *arr_data = [_picker getSelectedData];
    
    NSString *str_data = @"";
    for (int i = 0; i < [arr_data count]; i++) {
        NSString *t_str = arr_data[i];
        str_data = [str_data stringByAppendingString:t_str];
    }
    
    _alarm.time = str_data;
    
    if (_type == SmartAlarmSetTypeAdd) {
        if (_deleaget && [_deleaget respondsToSelector:@selector(alarmIsdidAdded:)]) {
            [_deleaget alarmIsdidAdded:_alarm];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALARMCHANGE object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc 

- (void)dealloc{
    NSLog(@"SmartAlarmSetVC dealloc");
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
